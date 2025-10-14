// filename: lib/presentation/controllers/workload_balancer_controller.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkloadBalancerController extends GetxController {
  final Random _random = Random();
  Timer? _updateTimer;

  // Source ore feed
  final RxDouble totalOreFeed = 500.0.obs; // tons/hour
  final RxBool isAutoBalancing = true.obs;

  // Machines (Crushers)
  final RxList<CrusherMachine> crushers = <CrusherMachine>[].obs;

  // Flow data for arrows
  final RxMap<String, FlowData> flows = <String, FlowData>{}.obs;

  // Statistics
  final RxDouble systemEfficiency = 0.0.obs;
  final RxDouble totalThroughput = 0.0.obs;
  final RxDouble loadImbalance = 0.0.obs;
  final RxInt optimizationCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCrushers();
    _startSimulation();
  }

  void _initializeCrushers() {
    crushers.value = [
      CrusherMachine(
        id: '1',
        name: 'Crusher A',
        icon: '⚙️',
        maxCapacity: 200.0,
        currentLoad: 150.0,
        efficiency: 85.0,
        status: MachineStatus.optimal,
        color: 0xFF4CAF50,
      ),
      CrusherMachine(
        id: '2',
        name: 'Crusher B',
        icon: '🔧',
        maxCapacity: 200.0,
        currentLoad: 180.0,
        efficiency: 78.0,
        status: MachineStatus.high,
        color: 0xFF2196F3,
      ),
      CrusherMachine(
        id: '3',
        name: 'Crusher C',
        icon: '⚡',
        maxCapacity: 200.0,
        currentLoad: 120.0,
        efficiency: 92.0,
        status: MachineStatus.optimal,
        color: 0xFF9C27B0,
      ),
      CrusherMachine(
        id: '4',
        name: 'Crusher D',
        icon: '🔩',
        maxCapacity: 200.0,
        currentLoad: 50.0,
        efficiency: 65.0,
        status: MachineStatus.low,
        color: 0xFFFF9800,
      ),
    ];

    _updateFlows();
  }

  void _startSimulation() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _simulateWorkload();
      if (isAutoBalancing.value) {
        _balanceWorkload();
      }
      _updateFlows();
      _updateStatistics();
    });
  }

  void _simulateWorkload() {
    for (var crusher in crushers) {
      // Simulate load fluctuations
      final loadChange = (_random.nextDouble() - 0.5) * 10;
      crusher.currentLoad = (crusher.currentLoad + loadChange).clamp(
        20.0,
        crusher.maxCapacity,
      );

      // Efficiency changes based on load
      final optimalLoad = crusher.maxCapacity * 0.75;
      final loadDiff = (crusher.currentLoad - optimalLoad).abs();
      crusher.efficiency = (100 - (loadDiff / crusher.maxCapacity) * 50).clamp(
        50.0,
        100.0,
      );

      // Update status
      crusher.status = _getStatusFromLoad(
        crusher.currentLoad / crusher.maxCapacity,
      );
    }
    crushers.refresh();
  }

  void _balanceWorkload() {
    // Calculate average load
    final totalCapacity = crushers.fold<double>(
      0,
      (sum, crusher) => sum + crusher.maxCapacity,
    );
    final totalLoad = crushers.fold<double>(
      0,
      (sum, crusher) => sum + crusher.currentLoad,
    );
    final targetLoad = totalLoad / crushers.length;

    // Redistribute load
    for (var crusher in crushers) {
      final loadDiff = crusher.currentLoad - targetLoad;
      if (loadDiff.abs() > 10) {
        // Gradually move towards target
        crusher.currentLoad -= loadDiff * 0.2;
        crusher.currentLoad = crusher.currentLoad.clamp(
          0.0,
          crusher.maxCapacity,
        );
      }
    }

    optimizationCount.value++;
    crushers.refresh();
  }

  void _updateFlows() {
    flows.clear();

    for (var crusher in crushers) {
      final flowRate = crusher.currentLoad;
      final intensity = crusher.currentLoad / crusher.maxCapacity;

      flows[crusher.id] = FlowData(
        flowRate: flowRate,
        intensity: intensity,
        isActive: crusher.currentLoad > 10,
        color: crusher.color,
      );
    }
  }

  void _updateStatistics() {
    // System efficiency (weighted average)
    final totalLoad = crushers.fold<double>(
      0,
      (sum, crusher) => sum + crusher.currentLoad,
    );
    final weightedEfficiency = crushers.fold<double>(
      0,
      (sum, crusher) => sum + (crusher.efficiency * crusher.currentLoad),
    );
    systemEfficiency.value = totalLoad > 0 ? weightedEfficiency / totalLoad : 0;

    // Total throughput
    totalThroughput.value = totalLoad;

    // Load imbalance (standard deviation)
    final avgLoad = totalLoad / crushers.length;
    final variance =
        crushers.fold<double>(
          0,
          (sum, crusher) => sum + pow(crusher.currentLoad - avgLoad, 2),
        ) /
        crushers.length;
    loadImbalance.value = sqrt(variance);
  }

  MachineStatus _getStatusFromLoad(double loadPercentage) {
    if (loadPercentage > 0.9) return MachineStatus.critical;
    if (loadPercentage > 0.75) return MachineStatus.high;
    if (loadPercentage > 0.5) return MachineStatus.optimal;
    return MachineStatus.low;
  }

  void toggleAutoBalancing() {
    isAutoBalancing.value = !isAutoBalancing.value;

    Get.snackbar(
      isAutoBalancing.value
          ? 'Auto-Balancing Enabled'
          : 'Auto-Balancing Disabled',
      isAutoBalancing.value
          ? 'System will automatically balance workload'
          : 'Manual control mode activated',
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void manualBalance() {
    _balanceWorkload();
    Get.snackbar(
      'Workload Balanced',
      'Load distribution optimized across all crushers',
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void adjustMachineLoad(String machineId, double newLoad) {
    final index = crushers.indexWhere((m) => m.id == machineId);
    if (index != -1) {
      crushers[index].currentLoad = newLoad.clamp(
        0.0,
        crushers[index].maxCapacity,
      );
      crushers.refresh();
      _updateFlows();
      _updateStatistics();
    }
  }

  @override
  void onClose() {
    _updateTimer?.cancel();
    super.onClose();
  }
}

enum MachineStatus { low, optimal, high, critical }

class CrusherMachine {
  final String id;
  final String name;
  final String icon;
  final double maxCapacity;
  double currentLoad;
  double efficiency;
  MachineStatus status;
  final int color;

  CrusherMachine({
    required this.id,
    required this.name,
    required this.icon,
    required this.maxCapacity,
    required this.currentLoad,
    required this.efficiency,
    required this.status,
    required this.color,
  });

  double get loadPercentage =>
      (currentLoad / maxCapacity * 100).clamp(0.0, 100.0);
}

class FlowData {
  final double flowRate;
  final double intensity;
  final bool isActive;
  final int color;

  FlowData({
    required this.flowRate,
    required this.intensity,
    required this.isActive,
    required this.color,
  });
}
