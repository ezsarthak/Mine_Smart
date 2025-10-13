// filename: lib/presentation/controllers/digital_twin_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import '../../data/models/sensor_reading_model.dart';
import 'sensor_controller.dart';
import 'package:flutter/material.dart';

class DigitalTwinController extends GetxController
    with GetTickerProviderStateMixin {
  final SensorController _sensorController = Get.find<SensorController>();

  // Observable values
  final RxDouble temperature = 0.0.obs;
  final RxDouble vibration = 0.0.obs;
  final RxDouble energy = 0.0.obs;
  final RxDouble rotationSpeed = 0.0.obs;
  final RxDouble glowIntensity = 0.0.obs;
  final RxBool isStressTesting = false.obs;
  final RxInt stressTestCountdown = 0.obs;
  final RxString equipmentStatus = 'normal'.obs;

  // Stress test timer
  Timer? _stressTestTimer;

  @override
  void onInit() {
    super.onInit();
    _listenToSensorData();
  }

  void _listenToSensorData() {
    ever(_sensorController.currentReading, (SensorReadingModel? reading) {
      if (reading != null) {
        _updateMetrics(reading);
      }
    });

    // Initial update
    if (_sensorController.currentReading.value != null) {
      _updateMetrics(_sensorController.currentReading.value!);
    }
  }

  void _updateMetrics(SensorReadingModel reading) {
    if (!isStressTesting.value) {
      temperature.value = reading.temperature;
      vibration.value = reading.vibration;
      energy.value = reading.energy;
      equipmentStatus.value = reading.status;

      // Calculate derived values
      rotationSpeed.value = _calculateRotationSpeed(reading);
      glowIntensity.value = _calculateGlowIntensity(reading);
    }
  }

  double _calculateRotationSpeed(SensorReadingModel reading) {
    // Base speed on energy consumption (50-500 kW → 0.5-5.0 rotations/sec)
    return (reading.energy / 100).clamp(0.5, 5.0);
  }

  double _calculateGlowIntensity(SensorReadingModel reading) {
    // Base intensity on temperature (20-85°C → 0.2-1.0)
    return ((reading.temperature - 20) / 65).clamp(0.2, 1.0);
  }

  void startStressTest() {
    if (isStressTesting.value) return;

    isStressTesting.value = true;
    stressTestCountdown.value = 10;

    // Simulate stress test conditions
    temperature.value = 95.0; // High temperature
    vibration.value = 12.0; // High vibration
    energy.value = 550.0; // High energy
    rotationSpeed.value = 6.0; // Very fast rotation
    glowIntensity.value = 1.0; // Maximum glow
    equipmentStatus.value = 'critical';

    // Countdown timer
    _stressTestTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      stressTestCountdown.value--;

      if (stressTestCountdown.value <= 0) {
        stopStressTest();
      }
    });

    Get.snackbar(
      'Stress Test Started',
      'Simulating high-load conditions for 10 seconds',
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  void stopStressTest() {
    _stressTestTimer?.cancel();
    isStressTesting.value = false;
    stressTestCountdown.value = 0;

    // Return to normal readings
    if (_sensorController.currentReading.value != null) {
      _updateMetrics(_sensorController.currentReading.value!);
    }

    Get.snackbar(
      'Stress Test Complete',
      'Equipment returned to normal operation',
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    _stressTestTimer?.cancel();
    super.onClose();
  }
}
