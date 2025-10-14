// filename: lib/presentation/controllers/ore_hardness_controller.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OreHardnessController extends GetxController {
  final Random _random = Random();
  Timer? _streamTimer;
  Timer? _predictionTimer;

  // Current hardness data
  final RxDouble currentHardness = 50.0.obs; // 0-100 scale
  final Rx<HardnessLevel> hardnessLevel = HardnessLevel.medium.obs;
  final RxString hardnessLabel = 'Medium'.obs;

  // AI/ML features
  final RxBool isLearning = true.obs;
  final RxDouble predictionAccuracy = 85.0.obs;
  final RxDouble confidenceLevel = 78.0.obs;
  final RxInt samplesProcessed = 0.obs;
  final RxString aiStatus = 'AI-adjusted parameters applied.'.obs;

  // Trend data
  final RxList<HardnessDataPoint> trendData = <HardnessDataPoint>[].obs;
  final RxList<HardnessDataPoint> predictionData = <HardnessDataPoint>[].obs;

  // Statistics
  final RxDouble averageHardness = 50.0.obs;
  final RxDouble minHardness = 30.0.obs;
  final RxDouble maxHardness = 70.0.obs;
  final RxDouble hardnessVariation = 15.0.obs;

  // Equipment adjustments
  final RxDouble recommendedCrusherPressure = 100.0.obs;
  final RxDouble recommendedFeedRate = 100.0.obs;
  final RxDouble energyEfficiency = 85.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeTrendData();
    _startIoTStream();
    _startPredictionEngine();
  }

  void _initializeTrendData() {
    final now = DateTime.now();

    // Initialize with historical data
    for (int i = 30; i >= 0; i--) {
      final timestamp = now.subtract(Duration(seconds: i * 2));
      final baseHardness = 50.0 + _random.nextDouble() * 30 - 15;

      trendData.add(
        HardnessDataPoint(
          timestamp: timestamp,
          value: baseHardness,
          predicted: false,
        ),
      );
    }

    _updateStatistics();
  }

  void _startIoTStream() {
    _streamTimer?.cancel();
    _streamTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _simulateHardnessReading();
    });
  }

  void _simulateHardnessReading() {
    // Simulate realistic ore hardness changes
    final trend = _random.nextDouble() > 0.5 ? 1 : -1;
    final change = (_random.nextDouble() * 5) * trend;

    currentHardness.value = (currentHardness.value + change).clamp(0.0, 100.0);

    // Add some random spikes occasionally
    if (_random.nextDouble() < 0.05) {
      currentHardness.value = _random.nextDouble() * 100;
    }

    // Update hardness level
    _updateHardnessLevel();

    // Add to trend data
    trendData.add(
      HardnessDataPoint(
        timestamp: DateTime.now(),
        value: currentHardness.value,
        predicted: false,
      ),
    );

    // Keep only last 30 data points
    if (trendData.length > 30) {
      trendData.removeAt(0);
    }

    // Update statistics
    _updateStatistics();

    // Update equipment recommendations
    _updateRecommendations();

    // Increment samples processed
    samplesProcessed.value++;
  }

  void _updateHardnessLevel() {
    if (currentHardness.value < 35) {
      hardnessLevel.value = HardnessLevel.soft;
      hardnessLabel.value = 'Soft';
    } else if (currentHardness.value < 65) {
      hardnessLevel.value = HardnessLevel.medium;
      hardnessLabel.value = 'Medium';
    } else {
      hardnessLevel.value = HardnessLevel.hard;
      hardnessLabel.value = 'Hard';
    }
  }

  void _startPredictionEngine() {
    _predictionTimer?.cancel();
    _predictionTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _generatePredictions();
      _updateAIStatus();
    });
  }

  void _generatePredictions() {
    predictionData.clear();

    if (trendData.length < 5) return;

    // Simple trend-based prediction
    final recent = trendData.sublist(trendData.length - 5);
    final avgChange =
        recent
            .asMap()
            .entries
            .skip(1)
            .map((e) => recent[e.key].value - recent[e.key - 1].value)
            .reduce((a, b) => a + b) /
        4;

    // Generate future predictions
    var lastValue = currentHardness.value;
    final now = DateTime.now();

    for (int i = 1; i <= 10; i++) {
      lastValue = (lastValue + avgChange + (_random.nextDouble() - 0.5) * 3)
          .clamp(0.0, 100.0);

      predictionData.add(
        HardnessDataPoint(
          timestamp: now.add(Duration(seconds: i * 2)),
          value: lastValue,
          predicted: true,
        ),
      );
    }

    // Simulate improving prediction accuracy
    if (predictionAccuracy.value < 95) {
      predictionAccuracy.value += 0.1;
    }
    if (confidenceLevel.value < 90) {
      confidenceLevel.value += 0.05;
    }
  }

  void _updateStatistics() {
    if (trendData.isEmpty) return;

    final values = trendData.map((d) => d.value).toList();
    averageHardness.value = values.reduce((a, b) => a + b) / values.length;
    minHardness.value = values.reduce((a, b) => a < b ? a : b);
    maxHardness.value = values.reduce((a, b) => a > b ? a : b);

    // Calculate standard deviation
    final mean = averageHardness.value;
    final variance =
        values.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) /
        values.length;
    hardnessVariation.value = sqrt(variance);
  }

  void _updateRecommendations() {
    // Adjust crusher pressure based on hardness
    if (currentHardness.value < 35) {
      recommendedCrusherPressure.value = 80.0 + _random.nextDouble() * 10;
    } else if (currentHardness.value < 65) {
      recommendedCrusherPressure.value = 100.0 + _random.nextDouble() * 10;
    } else {
      recommendedCrusherPressure.value = 130.0 + _random.nextDouble() * 20;
    }

    // Adjust feed rate inversely to hardness
    recommendedFeedRate.value =
        150 - (currentHardness.value * 0.5) + _random.nextDouble() * 10;

    // Energy efficiency improves with AI optimization
    energyEfficiency.value = (90 - (hardnessVariation.value * 0.5)).clamp(
      70.0,
      95.0,
    );
  }

  void _updateAIStatus() {
    final statusMessages = [
      'AI-adjusted parameters applied.',
      'Machine learning model updated.',
      'Prediction accuracy improved.',
      'Optimal crushing parameters set.',
      'Self-learning algorithm active.',
      'Neural network optimizing...',
    ];

    aiStatus.value = statusMessages[_random.nextInt(statusMessages.length)];
  }

  void toggleLearning() {
    isLearning.value = !isLearning.value;

    if (isLearning.value) {
      _startPredictionEngine();
      Get.snackbar(
        'AI Learning Enabled',
        'Self-learning algorithm is now active',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      _predictionTimer?.cancel();
      Get.snackbar(
        'AI Learning Disabled',
        'Running in manual mode',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void calibrateSensor() {
    Get.snackbar(
      'Sensor Calibrating',
      'Recalibrating hardness sensor...',
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );

    Future.delayed(const Duration(seconds: 2), () {
      predictionAccuracy.value = 95.0;
      confidenceLevel.value = 92.0;

      Get.snackbar(
        'Calibration Complete',
        'Sensor recalibrated successfully',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }

  @override
  void onClose() {
    _streamTimer?.cancel();
    _predictionTimer?.cancel();
    super.onClose();
  }
}

enum HardnessLevel { soft, medium, hard }

class HardnessDataPoint {
  final DateTime timestamp;
  final double value;
  final bool predicted;

  HardnessDataPoint({
    required this.timestamp,
    required this.value,
    required this.predicted,
  });
}
