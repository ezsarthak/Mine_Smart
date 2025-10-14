// filename: lib/presentation/controllers/digital_twin_controller.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DigitalTwinController extends GetxController {
  final Random _random = Random();
  Timer? _simulationTimer;

  // Simulation parameters
  final RxDouble feedRate = 100.0.obs; // 0-200 t/h
  final RxDouble oreHardness = 50.0.obs; // 0-100 (soft to hard)
  final RxDouble crushingPressure = 100.0.obs; // 0-200 bar
  final RxDouble millSpeed = 50.0.obs; // 0-100 RPM

  // Output metrics
  final RxDouble outputEfficiency = 75.0.obs; // 0-100%
  final RxDouble energyConsumption = 350.0.obs; // kW
  final RxDouble throughput = 85.0.obs; // t/h
  final RxDouble particleSize = 2.5.obs; // mm
  final RxDouble wearRate = 15.0.obs; // %

  // Simulation state
  final RxBool isSimulating = false.obs;
  final RxBool isOptimized = false.obs;
  final RxList<SimulationDataPoint> efficiencyHistory =
      <SimulationDataPoint>[].obs;
  final RxList<SimulationDataPoint> energyHistory = <SimulationDataPoint>[].obs;

  // Plant component states
  final RxDouble crusherLoad = 0.0.obs;
  final RxDouble millLoad = 0.0.obs;
  final RxDouble conveyorSpeed = 0.0.obs;
  final RxDouble separatorEfficiency = 0.0.obs;

  // Alerts
  final RxString currentAlert = ''.obs;
  final RxString alertLevel = 'normal'.obs; // normal, warning, critical

  @override
  void onInit() {
    super.onInit();
    _initializeHistoricalData();
    _startSimulation();
  }

  void _initializeHistoricalData() {
    final now = DateTime.now();
    for (int i = 30; i >= 0; i--) {
      final timestamp = now.subtract(Duration(seconds: i * 2));
      efficiencyHistory.add(
        SimulationDataPoint(
          timestamp: timestamp,
          value: 70.0 + _random.nextDouble() * 15,
        ),
      );
      energyHistory.add(
        SimulationDataPoint(
          timestamp: timestamp,
          value: 300.0 + _random.nextDouble() * 100,
        ),
      );
    }
  }

  void _startSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _updateSimulation();
    });
  }

  void _updateSimulation() {
    if (!isSimulating.value) return;

    // Calculate output efficiency based on parameters
    final baseEfficiency = 100.0;
    final feedPenalty = (feedRate.value - 100).abs() * 0.15;
    final hardnessPenalty = (oreHardness.value - 50) * 0.2;
    final pressureFactor = (crushingPressure.value / 100) * 5;
    final speedFactor = (millSpeed.value / 50) * 3;

    outputEfficiency.value =
        (baseEfficiency -
                feedPenalty -
                hardnessPenalty +
                pressureFactor +
                speedFactor +
                _random.nextDouble() * 5 -
                2.5)
            .clamp(40.0, 98.0);

    // Calculate energy consumption
    final baseEnergy = 250.0;
    final feedEnergy = feedRate.value * 1.5;
    final hardnessEnergy = oreHardness.value * 2.0;
    final pressureEnergy = crushingPressure.value * 1.2;
    final speedEnergy = millSpeed.value * 1.8;

    energyConsumption.value =
        (baseEnergy +
                feedEnergy +
                hardnessEnergy +
                pressureEnergy +
                speedEnergy +
                _random.nextDouble() * 30 -
                15)
            .clamp(200.0, 800.0);

    // Calculate throughput
    throughput.value =
        (feedRate.value * (outputEfficiency.value / 100) +
                _random.nextDouble() * 5 -
                2.5)
            .clamp(30.0, 180.0);

    // Calculate particle size
    particleSize.value =
        (5.0 -
                (crushingPressure.value / 100) * 3.0 -
                (millSpeed.value / 100) * 1.5 +
                _random.nextDouble() * 0.3)
            .clamp(0.5, 5.0);

    // Calculate wear rate
    wearRate.value =
        (oreHardness.value * 0.3 +
                feedRate.value * 0.1 +
                _random.nextDouble() * 5)
            .clamp(5.0, 40.0);

    // Update component states
    _updateComponentStates();

    // Add to history
    final now = DateTime.now();
    efficiencyHistory.add(
      SimulationDataPoint(timestamp: now, value: outputEfficiency.value),
    );
    energyHistory.add(
      SimulationDataPoint(timestamp: now, value: energyConsumption.value),
    );

    // Keep only last 30 data points
    if (efficiencyHistory.length > 30) {
      efficiencyHistory.removeAt(0);
    }
    if (energyHistory.length > 30) {
      energyHistory.removeAt(0);
    }

    // Check for alerts
    _checkAlerts();
  }

  void _updateComponentStates() {
    crusherLoad.value = (feedRate.value / 200 * 100 + _random.nextDouble() * 5)
        .clamp(0.0, 100.0);
    millLoad.value = (throughput.value / 180 * 100 + _random.nextDouble() * 5)
        .clamp(0.0, 100.0);
    conveyorSpeed.value =
        (feedRate.value / 200 * 100 + _random.nextDouble() * 5).clamp(
          0.0,
          100.0,
        );
    separatorEfficiency.value =
        (outputEfficiency.value + _random.nextDouble() * 5 - 2.5).clamp(
          0.0,
          100.0,
        );
  }

  void _checkAlerts() {
    currentAlert.value = '';
    alertLevel.value = 'normal';

    if (outputEfficiency.value < 50) {
      currentAlert.value =
          'Low efficiency detected. Consider adjusting parameters.';
      alertLevel.value = 'critical';
    } else if (energyConsumption.value > 600) {
      currentAlert.value = 'High energy consumption. Optimization recommended.';
      alertLevel.value = 'warning';
    } else if (wearRate.value > 30) {
      currentAlert.value = 'High wear rate. Schedule maintenance soon.';
      alertLevel.value = 'warning';
    } else if (outputEfficiency.value > 85) {
      currentAlert.value = 'Optimal performance achieved!';
      alertLevel.value = 'normal';
    }
  }

  void startSimulation() {
    isSimulating.value = true;
    Get.snackbar(
      'Simulation Started',
      'Real-time simulation is now active',
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  void stopSimulation() {
    isSimulating.value = false;
    Get.snackbar(
      'Simulation Stopped',
      'Simulation paused',
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  void optimizeParameters() {
    // AI-driven optimization
    feedRate.value = 120.0;
    oreHardness.value = 45.0;
    crushingPressure.value = 140.0;
    millSpeed.value = 65.0;
    isOptimized.value = true;

    Get.snackbar(
      'Parameters Optimized',
      'AI has calculated optimal settings',
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );

    Future.delayed(const Duration(seconds: 3), () {
      isOptimized.value = false;
    });
  }

  void resetParameters() {
    feedRate.value = 100.0;
    oreHardness.value = 50.0;
    crushingPressure.value = 100.0;
    millSpeed.value = 50.0;
  }

  @override
  void onClose() {
    _simulationTimer?.cancel();
    super.onClose();
  }
}

class SimulationDataPoint {
  final DateTime timestamp;
  final double value;

  SimulationDataPoint({required this.timestamp, required this.value});
}
