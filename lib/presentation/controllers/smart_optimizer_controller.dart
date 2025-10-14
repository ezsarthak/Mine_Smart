// filename: lib/presentation/controllers/smart_optimizer_controller.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmartOptimizerController extends GetxController {
  final Random _random = Random();
  Timer? _updateTimer;

  // Optimization state
  final RxBool isOptimizationEnabled = false.obs;
  final RxDouble energySavedPercentage = 0.0.obs;
  final RxDouble targetEnergySaved = 15.0.obs;

  // Mock IoT readings
  final RxDouble crusherSpeed = 850.0.obs;
  final RxDouble feedRate = 120.0.obs;
  final RxDouble millRotation = 18.5.obs;
  final RxDouble beltSpeed = 2.5.obs;
  final RxDouble powerConsumption = 425.0.obs;
  final RxDouble vibrationLevel = 4.2.obs;
  final RxDouble temperature = 68.0.obs;
  final RxDouble efficiency = 72.0.obs;

  // Target optimized values
  final Map<String, double> _optimizedTargets = {
    'crusherSpeed': 780.0,
    'feedRate': 105.0,
    'millRotation': 16.8,
    'beltSpeed': 2.2,
    'powerConsumption': 310.0,
    'vibrationLevel': 2.8,
    'temperature': 58.0,
    'efficiency': 88.0,
  };

  @override
  void onInit() {
    super.onInit();
    _startRealtimeUpdates();
  }

  void _startRealtimeUpdates() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _updateReadings();
    });
  }

  void _updateReadings() {
    if (isOptimizationEnabled.value) {
      _optimizeValues();
    } else {
      _normalOperation();
    }
    _updateEnergySaved();
  }

  void _normalOperation() {
    // Normal fluctuations around base values
    crusherSpeed.value = 850.0 + _randomFluctuation(30);
    feedRate.value = 120.0 + _randomFluctuation(10);
    millRotation.value = 18.5 + _randomFluctuation(1.5);
    beltSpeed.value = 2.5 + _randomFluctuation(0.3);
    powerConsumption.value = 425.0 + _randomFluctuation(35);
    vibrationLevel.value = 4.2 + _randomFluctuation(0.8);
    temperature.value = 68.0 + _randomFluctuation(5);
    efficiency.value = 72.0 + _randomFluctuation(5);
  }

  void _optimizeValues() {
    // Gradually move towards optimized targets
    crusherSpeed.value = _moveTowardsTarget(
      crusherSpeed.value,
      _optimizedTargets['crusherSpeed']!,
      10,
    );
    feedRate.value = _moveTowardsTarget(
      feedRate.value,
      _optimizedTargets['feedRate']!,
      5,
    );
    millRotation.value = _moveTowardsTarget(
      millRotation.value,
      _optimizedTargets['millRotation']!,
      0.5,
    );
    beltSpeed.value = _moveTowardsTarget(
      beltSpeed.value,
      _optimizedTargets['beltSpeed']!,
      0.1,
    );
    powerConsumption.value = _moveTowardsTarget(
      powerConsumption.value,
      _optimizedTargets['powerConsumption']!,
      15,
    );
    vibrationLevel.value = _moveTowardsTarget(
      vibrationLevel.value,
      _optimizedTargets['vibrationLevel']!,
      0.3,
    );
    temperature.value = _moveTowardsTarget(
      temperature.value,
      _optimizedTargets['temperature']!,
      2,
    );
    efficiency.value = _moveTowardsTarget(
      efficiency.value,
      _optimizedTargets['efficiency']!,
      3,
    );
  }

  double _moveTowardsTarget(double current, double target, double maxStep) {
    final difference = target - current;
    if (difference.abs() < maxStep) {
      return target + _randomFluctuation(maxStep * 0.1);
    }
    return current +
        (difference > 0 ? maxStep : -maxStep) +
        _randomFluctuation(maxStep * 0.2);
  }

  double _randomFluctuation(double range) {
    return (_random.nextDouble() - 0.5) * range;
  }

  void _updateEnergySaved() {
    if (isOptimizationEnabled.value) {
      // Gradually increase energy saved
      if (energySavedPercentage.value < targetEnergySaved.value) {
        energySavedPercentage.value = (energySavedPercentage.value + 0.5).clamp(
          0.0,
          targetEnergySaved.value,
        );
      }
    } else {
      // Gradually decrease energy saved when optimization is off
      if (energySavedPercentage.value > 0) {
        energySavedPercentage.value = (energySavedPercentage.value - 0.3).clamp(
          0.0,
          100.0,
        );
      }
    }
  }

  void toggleOptimization() {
    isOptimizationEnabled.value = !isOptimizationEnabled.value;

    if (isOptimizationEnabled.value) {
      Get.snackbar(
        'Optimization Enabled',
        'AI agent is now optimizing energy consumption',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Optimization Disabled',
        'Manual control mode activated',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }

  double getTotalEnergySavedKwh() {
    // Calculate energy saved in kWh based on percentage
    final baseConsumption = 425.0; // kW
    final savedPower = baseConsumption * (energySavedPercentage.value / 100);
    return savedPower * 8; // Assuming 8 hours of operation
  }

  double getCostSavings() {
    // Assuming $0.12 per kWh
    return getTotalEnergySavedKwh() * 0.12;
  }

  @override
  void onClose() {
    _updateTimer?.cancel();
    super.onClose();
  }
}
