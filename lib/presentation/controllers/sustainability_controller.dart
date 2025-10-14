// filename: lib/presentation/controllers/sustainability_controller.dart
import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';

class SustainabilityController extends GetxController {
  final Random _random = Random();
  Timer? _updateTimer;

  // Carbon metrics
  final RxDouble carbonSavedToday = 0.0.obs;
  final RxDouble currentEmissionRate = 0.0.obs;
  final RxDouble targetEmissionRate = 50.0.obs;
  final RxDouble carbonIntensity = 0.0.obs;
  final RxDouble totalCarbonOffset = 0.0.obs;

  // Historical data
  final RxList<EmissionDataPoint> hourlyEmissions = <EmissionDataPoint>[].obs;
  final RxList<EmissionDataPoint> dailyEmissions = <EmissionDataPoint>[].obs;
  final RxList<EmissionDataPoint> weeklyEmissions = <EmissionDataPoint>[].obs;

  // Stats
  final RxDouble treesEquivalent = 0.0.obs;
  final RxDouble energySavedKwh = 0.0.obs;
  final RxDouble waterSavedLiters = 0.0.obs;
  final RxInt ecoScore = 0.obs;

  // Period selection
  final RxString selectedPeriod = 'day'.obs;

  // Goals
  final RxDouble monthlyGoal = 1000.0.obs;
  final RxDouble goalProgress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _startRealTimeUpdates();
  }

  void _initializeData() {
    // Initialize historical data
    _generateHourlyData();
    _generateDailyData();
    _generateWeeklyData();

    // Calculate initial metrics
    _updateMetrics();
  }

  void _generateHourlyData() {
    final now = DateTime.now();
    hourlyEmissions.clear();

    for (int i = 23; i >= 0; i--) {
      final time = now.subtract(Duration(hours: i));
      final baseEmission = 45.0 + _random.nextDouble() * 30;
      final optimizedEmission = baseEmission * 0.7;

      hourlyEmissions.add(
        EmissionDataPoint(
          timestamp: time,
          value: _random.nextBool() ? baseEmission : optimizedEmission,
          isOptimized: _random.nextBool(),
        ),
      );
    }
  }

  void _generateDailyData() {
    final now = DateTime.now();
    dailyEmissions.clear();

    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final baseEmission = 500.0 + _random.nextDouble() * 300;
      final optimizedEmission = baseEmission * 0.65;

      dailyEmissions.add(
        EmissionDataPoint(
          timestamp: date,
          value: _random.nextDouble() < 0.7 ? optimizedEmission : baseEmission,
          isOptimized: _random.nextDouble() < 0.7,
        ),
      );
    }
  }

  void _generateWeeklyData() {
    final now = DateTime.now();
    weeklyEmissions.clear();

    for (int i = 11; i >= 0; i--) {
      final date = now.subtract(Duration(days: i * 7));
      final baseEmission = 3500.0 + _random.nextDouble() * 2000;
      final optimizedEmission = baseEmission * 0.68;

      weeklyEmissions.add(
        EmissionDataPoint(
          timestamp: date,
          value: _random.nextDouble() < 0.8 ? optimizedEmission : baseEmission,
          isOptimized: _random.nextDouble() < 0.8,
        ),
      );
    }
  }

  void _startRealTimeUpdates() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _updateRealTimeMetrics();
    });
  }

  void _updateRealTimeMetrics() {
    // Update current emission rate
    currentEmissionRate.value = 40.0 + _random.nextDouble() * 40;

    // Update carbon saved
    final savedRate = targetEmissionRate.value - currentEmissionRate.value;
    if (savedRate > 0) {
      carbonSavedToday.value += savedRate * 0.0005; // Small increment
    }

    // Update carbon intensity
    carbonIntensity.value = (currentEmissionRate.value / 100).clamp(0.0, 1.0);

    // Add new hourly data point occasionally
    if (_random.nextDouble() < 0.1) {
      hourlyEmissions.add(
        EmissionDataPoint(
          timestamp: DateTime.now(),
          value: currentEmissionRate.value,
          isOptimized: currentEmissionRate.value < targetEmissionRate.value,
        ),
      );

      if (hourlyEmissions.length > 24) {
        hourlyEmissions.removeAt(0);
      }
    }

    _updateMetrics();
  }

  void _updateMetrics() {
    // Calculate trees equivalent (1 tree absorbs ~21.77 kg CO2/year ≈ 0.06 kg/day)
    treesEquivalent.value = carbonSavedToday.value / 0.06;

    // Calculate energy saved (approximate)
    energySavedKwh.value = carbonSavedToday.value * 1.2;

    // Calculate water saved (approximate, based on energy-water nexus)
    waterSavedLiters.value = energySavedKwh.value * 3.5;

    // Calculate eco score (0-100)
    final reductionPercent =
        (carbonSavedToday.value / targetEmissionRate.value * 100).clamp(
          0.0,
          100.0,
        );
    ecoScore.value = reductionPercent.round();

    // Update goal progress
    goalProgress.value = (carbonSavedToday.value / monthlyGoal.value * 100)
        .clamp(0.0, 100.0);
  }

  List<EmissionDataPoint> getCurrentPeriodData() {
    switch (selectedPeriod.value) {
      case 'day':
        return hourlyEmissions;
      case 'month':
        return dailyEmissions;
      case 'year':
        return weeklyEmissions;
      default:
        return hourlyEmissions;
    }
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
  }

  double getAverageEmission() {
    final data = getCurrentPeriodData();
    if (data.isEmpty) return 0;
    return data.map((e) => e.value).reduce((a, b) => a + b) / data.length;
  }

  double getPeakEmission() {
    final data = getCurrentPeriodData();
    if (data.isEmpty) return 0;
    return data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
  }

  double getLowestEmission() {
    final data = getCurrentPeriodData();
    if (data.isEmpty) return 0;
    return data.map((e) => e.value).reduce((a, b) => a < b ? a : b);
  }

  String getEmissionTrend() {
    final data = getCurrentPeriodData();
    if (data.length < 2) return 'stable';

    final recent = data.sublist(data.length - 5);
    final older = data.sublist(data.length - 10, data.length - 5);

    final recentAvg =
        recent.map((e) => e.value).reduce((a, b) => a + b) / recent.length;
    final olderAvg =
        older.map((e) => e.value).reduce((a, b) => a + b) / older.length;

    if (recentAvg < olderAvg * 0.95) return 'decreasing';
    if (recentAvg > olderAvg * 1.05) return 'increasing';
    return 'stable';
  }

  void refresh() {
    _initializeData();
  }

  @override
  void onClose() {
    _updateTimer?.cancel();
    super.onClose();
  }
}

class EmissionDataPoint {
  final DateTime timestamp;
  final double value;
  final bool isOptimized;

  EmissionDataPoint({
    required this.timestamp,
    required this.value,
    required this.isOptimized,
  });
}
