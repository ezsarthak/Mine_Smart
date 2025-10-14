// filename: lib/presentation/controllers/safety_dashboard_controller.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SafetyDashboardController extends GetxController {
  final Random _random = Random();
  Timer? _monitoringTimer;

  // Machines being monitored
  final RxList<MachineSafety> machines = <MachineSafety>[].obs;

  // Dashboard statistics
  final RxInt totalMachines = 0.obs;
  final RxInt lowRiskCount = 0.obs;
  final RxInt mediumRiskCount = 0.obs;
  final RxInt highRiskCount = 0.obs;
  final RxInt criticalAlerts = 0.obs;
  final RxDouble overallSafetyScore = 0.0.obs;

  // AI monitoring
  final RxBool isMonitoring = true.obs;
  final RxInt predictionsMade = 0.obs;
  final RxInt incidentsPrevented = 0.obs;
  final RxDouble aiAccuracy = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeMachines();
    _startSafetyMonitoring();
  }

  void _initializeMachines() {
    machines.value = [
      MachineSafety(
        id: '1',
        name: 'Crusher Unit A',
        type: 'Crusher',
        icon: '⚙️',
        riskLevel: RiskLevel.low,
        riskScore: 25.0,
        vibrationLevel: 3.2,
        temperature: 65.0,
        pressure: 85.0,
        operatingHours: 1250,
        lastMaintenance: DateTime.now().subtract(const Duration(days: 15)),
        nextMaintenance: DateTime.now().add(const Duration(days: 15)),
        riskFactors: [
          RiskFactor(
            name: 'Vibration',
            severity: 'Low',
            value: 3.2,
            threshold: 5.0,
            description: 'Vibration levels within safe range',
          ),
          RiskFactor(
            name: 'Temperature',
            severity: 'Low',
            value: 65.0,
            threshold: 80.0,
            description: 'Operating temperature normal',
          ),
        ],
        preventionTips: [
          'Continue regular monitoring',
          'Schedule maintenance as planned',
          'Monitor vibration trends',
        ],
      ),
      MachineSafety(
        id: '2',
        name: 'Mill Unit B',
        type: 'Mill',
        icon: '🔄',
        riskLevel: RiskLevel.medium,
        riskScore: 55.0,
        vibrationLevel: 4.8,
        temperature: 78.0,
        pressure: 110.0,
        operatingHours: 2340,
        lastMaintenance: DateTime.now().subtract(const Duration(days: 35)),
        nextMaintenance: DateTime.now().add(const Duration(days: 10)),
        riskFactors: [
          RiskFactor(
            name: 'Vibration',
            severity: 'Medium',
            value: 4.8,
            threshold: 5.0,
            description: 'Approaching vibration threshold',
          ),
          RiskFactor(
            name: 'Temperature',
            severity: 'Medium',
            value: 78.0,
            threshold: 80.0,
            description: 'Temperature approaching limits',
          ),
          RiskFactor(
            name: 'Bearing Wear',
            severity: 'Medium',
            value: 65.0,
            threshold: 70.0,
            description: 'Bearings showing signs of wear',
          ),
        ],
        preventionTips: [
          'Increase monitoring frequency',
          'Check bearing condition',
          'Schedule maintenance earlier if vibration increases',
          'Ensure proper lubrication',
        ],
      ),
      MachineSafety(
        id: '3',
        name: 'Conveyor Belt C',
        type: 'Conveyor',
        icon: '↔️',
        riskLevel: RiskLevel.high,
        riskScore: 78.0,
        vibrationLevel: 5.5,
        temperature: 85.0,
        pressure: 95.0,
        operatingHours: 3200,
        lastMaintenance: DateTime.now().subtract(const Duration(days: 60)),
        nextMaintenance: DateTime.now().subtract(const Duration(days: 5)),
        riskFactors: [
          RiskFactor(
            name: 'Belt Tension',
            severity: 'High',
            value: 82.0,
            threshold: 75.0,
            description: 'Critical: Belt tension exceeds safe limits',
          ),
          RiskFactor(
            name: 'Temperature',
            severity: 'High',
            value: 85.0,
            threshold: 80.0,
            description: 'Overheating detected - motor stress',
          ),
          RiskFactor(
            name: 'Maintenance Overdue',
            severity: 'Critical',
            value: 100.0,
            threshold: 50.0,
            description: 'Maintenance overdue by 5 days',
          ),
        ],
        preventionTips: [
          'URGENT: Stop operation and inspect immediately',
          'Replace worn belt sections',
          'Check motor cooling system',
          'Perform emergency maintenance',
          'Monitor continuously until resolved',
        ],
      ),
      MachineSafety(
        id: '4',
        name: 'Pump System D',
        type: 'Pump',
        icon: '💧',
        riskLevel: RiskLevel.low,
        riskScore: 18.0,
        vibrationLevel: 2.1,
        temperature: 58.0,
        pressure: 92.0,
        operatingHours: 890,
        lastMaintenance: DateTime.now().subtract(const Duration(days: 8)),
        nextMaintenance: DateTime.now().add(const Duration(days: 37)),
        riskFactors: [
          RiskFactor(
            name: 'Pressure',
            severity: 'Low',
            value: 92.0,
            threshold: 120.0,
            description: 'Pressure levels optimal',
          ),
        ],
        preventionTips: [
          'Maintain current operating parameters',
          'Regular visual inspections',
        ],
      ),
      MachineSafety(
        id: '5',
        name: 'Separator E',
        type: 'Separator',
        icon: '🔬',
        riskLevel: RiskLevel.medium,
        riskScore: 48.0,
        vibrationLevel: 4.2,
        temperature: 72.0,
        pressure: 105.0,
        operatingHours: 1850,
        lastMaintenance: DateTime.now().subtract(const Duration(days: 28)),
        nextMaintenance: DateTime.now().add(const Duration(days: 17)),
        riskFactors: [
          RiskFactor(
            name: 'Filter Clogging',
            severity: 'Medium',
            value: 55.0,
            threshold: 60.0,
            description: 'Filters approaching cleaning threshold',
          ),
          RiskFactor(
            name: 'Vibration',
            severity: 'Medium',
            value: 4.2,
            threshold: 5.0,
            description: 'Slight increase in vibration detected',
          ),
        ],
        preventionTips: [
          'Clean filters within next week',
          'Monitor vibration trends',
          'Check for material buildup',
        ],
      ),
      MachineSafety(
        id: '6',
        name: 'Drilling Rig F',
        type: 'Drilling',
        icon: '🔧',
        riskLevel: RiskLevel.high,
        riskScore: 72.0,
        vibrationLevel: 6.8,
        temperature: 88.0,
        pressure: 135.0,
        operatingHours: 2890,
        lastMaintenance: DateTime.now().subtract(const Duration(days: 45)),
        nextMaintenance: DateTime.now().add(const Duration(days: 5)),
        riskFactors: [
          RiskFactor(
            name: 'Hydraulic Pressure',
            severity: 'High',
            value: 135.0,
            threshold: 130.0,
            description: 'Pressure exceeding safe operating range',
          ),
          RiskFactor(
            name: 'Vibration',
            severity: 'High',
            value: 6.8,
            threshold: 5.5,
            description: 'Excessive vibration - possible misalignment',
          ),
          RiskFactor(
            name: 'Temperature',
            severity: 'High',
            value: 88.0,
            threshold: 85.0,
            description: 'Hydraulic system overheating',
          ),
        ],
        preventionTips: [
          'Reduce operating pressure immediately',
          'Inspect hydraulic system for leaks',
          'Check drill bit alignment',
          'Schedule urgent maintenance',
          'Consider temporary shutdown for inspection',
        ],
      ),
    ];

    totalMachines.value = machines.length;
    _updateStatistics();
  }

  void _startSafetyMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (isMonitoring.value) {
        _simulateRiskChanges();
        _updateStatistics();
        predictionsMade.value++;
      }
    });
  }

  void _simulateRiskChanges() {
    for (var machine in machines) {
      // Simulate risk score fluctuations
      final change = (_random.nextDouble() - 0.5) * 5;
      machine.riskScore = (machine.riskScore + change).clamp(0.0, 100.0);

      // Update risk level based on score
      if (machine.riskScore < 35) {
        machine.riskLevel = RiskLevel.low;
      } else if (machine.riskScore < 65) {
        machine.riskLevel = RiskLevel.medium;
      } else {
        machine.riskLevel = RiskLevel.high;
      }

      // Simulate sensor readings
      machine.vibrationLevel += (_random.nextDouble() - 0.5) * 0.3;
      machine.vibrationLevel = machine.vibrationLevel.clamp(0.0, 10.0);

      machine.temperature += (_random.nextDouble() - 0.5) * 2;
      machine.temperature = machine.temperature.clamp(40.0, 100.0);

      machine.pressure += (_random.nextDouble() - 0.5) * 3;
      machine.pressure = machine.pressure.clamp(50.0, 150.0);

      // Occasionally trigger critical alerts
      if (_random.nextDouble() < 0.02 && machine.riskLevel == RiskLevel.high) {
        _triggerAlert(machine);
      }
    }
    machines.refresh();
  }

  void _triggerAlert(MachineSafety machine) {
    Get.snackbar(
      '⚠️ Safety Alert',
      '${machine.name}: High risk detected!',
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
    );
  }

  void _updateStatistics() {
    lowRiskCount.value = machines
        .where((m) => m.riskLevel == RiskLevel.low)
        .length;
    mediumRiskCount.value = machines
        .where((m) => m.riskLevel == RiskLevel.medium)
        .length;
    highRiskCount.value = machines
        .where((m) => m.riskLevel == RiskLevel.high)
        .length;
    criticalAlerts.value = machines.where((m) => m.riskScore > 75).length;

    // Calculate overall safety score
    final totalRisk = machines.fold<double>(0, (sum, m) => sum + m.riskScore);
    overallSafetyScore.value = 100 - (totalRisk / machines.length);

    // Simulate improving AI accuracy
    if (aiAccuracy.value < 98) {
      aiAccuracy.value += 0.05;
    }

    // Track incidents prevented
    if (_random.nextDouble() < 0.1 && highRiskCount.value > 0) {
      incidentsPrevented.value++;
    }
  }

  void toggleMonitoring() {
    isMonitoring.value = !isMonitoring.value;

    Get.snackbar(
      isMonitoring.value ? 'Monitoring Active' : 'Monitoring Paused',
      isMonitoring.value
          ? 'AI safety monitoring resumed'
          : 'Safety monitoring paused',
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void acknowledgeMachine(String machineId) {
    final index = machines.indexWhere((m) => m.id == machineId);
    if (index != -1) {
      machines[index].lastInspection = DateTime.now();
      Get.snackbar(
        'Acknowledged',
        '${machines[index].name} marked for inspection',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  @override
  void onClose() {
    _monitoringTimer?.cancel();
    super.onClose();
  }
}

enum RiskLevel { low, medium, high }

class MachineSafety {
  final String id;
  final String name;
  final String type;
  final String icon;
  RiskLevel riskLevel;
  double riskScore;
  double vibrationLevel;
  double temperature;
  double pressure;
  final int operatingHours;
  final DateTime lastMaintenance;
  final DateTime nextMaintenance;
  DateTime? lastInspection;
  final List<RiskFactor> riskFactors;
  final List<String> preventionTips;

  MachineSafety({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.riskLevel,
    required this.riskScore,
    required this.vibrationLevel,
    required this.temperature,
    required this.pressure,
    required this.operatingHours,
    required this.lastMaintenance,
    required this.nextMaintenance,
    this.lastInspection,
    required this.riskFactors,
    required this.preventionTips,
  });
}

class RiskFactor {
  final String name;
  final String severity;
  final double value;
  final double threshold;
  final String description;

  RiskFactor({
    required this.name,
    required this.severity,
    required this.value,
    required this.threshold,
    required this.description,
  });
}
