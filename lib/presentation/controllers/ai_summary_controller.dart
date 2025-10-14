// filename: lib/presentation/controllers/ai_summary_controller.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AISummaryController extends GetxController {
  final Random _random = Random();
  Timer? _updateTimer;

  // Summary data
  final RxList<InsightCategory> insights = <InsightCategory>[].obs;
  final RxString reportDate = ''.obs;
  final RxBool isGenerating = false.obs;
  final RxBool isPlayingVoice = false.obs;
  final RxDouble generationProgress = 0.0.obs;

  // Statistics
  final RxInt totalInsights = 0.obs;
  final RxInt criticalInsights = 0.obs;
  final RxInt positiveInsights = 0.obs;
  final RxInt improvementSuggestions = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _generateReport();
    _startAutoUpdate();
  }

  void _startAutoUpdate() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updateInsights();
    });
  }

  void _generateReport() {
    reportDate.value = _formatDate(DateTime.now());
    insights.clear();

    // Energy & Efficiency Insights
    insights.add(
      InsightCategory(
        title: '⚡ Energy & Efficiency',
        icon: '⚡',
        items: [
          InsightItem(
            emoji: '📉',
            title: 'Energy Consumption',
            description: 'Energy used today decreased by 8%',
            value: '-8%',
            trend: TrendType.positive,
            priority: PriorityLevel.normal,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          InsightItem(
            emoji: '🎯',
            title: 'Efficiency Optimization',
            description: 'Crusher Unit A achieved 92% efficiency',
            value: '92%',
            trend: TrendType.positive,
            priority: PriorityLevel.normal,
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          InsightItem(
            emoji: '💡',
            title: 'Power Savings',
            description: 'Smart optimization saved 245 kWh today',
            value: '245 kWh',
            trend: TrendType.positive,
            priority: PriorityLevel.high,
            timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
          ),
        ],
      ),
    );

    // Anomaly Detection
    insights.add(
      InsightCategory(
        title: '🔍 Anomaly Detection',
        icon: '🔍',
        items: [
          InsightItem(
            emoji: '⚠️',
            title: 'Vibration Anomaly',
            description: '1 anomaly detected in Crusher 2',
            value: 'Medium',
            trend: TrendType.negative,
            priority: PriorityLevel.critical,
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
          InsightItem(
            emoji: '🌡️',
            title: 'Temperature Alert',
            description: 'Mill Unit B running 5°C above normal',
            value: '+5°C',
            trend: TrendType.negative,
            priority: PriorityLevel.high,
            timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
          ),
          InsightItem(
            emoji: '✅',
            title: 'System Health',
            description: 'All other systems operating normally',
            value: 'OK',
            trend: TrendType.neutral,
            priority: PriorityLevel.normal,
            timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          ),
        ],
      ),
    );

    // Production Insights
    insights.add(
      InsightCategory(
        title: '📊 Production',
        icon: '📊',
        items: [
          InsightItem(
            emoji: '📈',
            title: 'Output Increase',
            description: 'Daily throughput increased by 12%',
            value: '+12%',
            trend: TrendType.positive,
            priority: PriorityLevel.high,
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          ),
          InsightItem(
            emoji: '⏱️',
            title: 'Downtime Reduced',
            description: 'Unplanned downtime decreased to 0.5 hours',
            value: '-45min',
            trend: TrendType.positive,
            priority: PriorityLevel.normal,
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          ),
          InsightItem(
            emoji: '🎨',
            title: 'Quality Metrics',
            description: 'Product quality maintained at 98.5%',
            value: '98.5%',
            trend: TrendType.neutral,
            priority: PriorityLevel.normal,
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          ),
        ],
      ),
    );

    // Maintenance Updates
    insights.add(
      InsightCategory(
        title: '🔧 Maintenance',
        icon: '🔧',
        items: [
          InsightItem(
            emoji: '✔️',
            title: 'Maintenance Completed',
            description: 'Pump System D serviced successfully',
            value: 'Done',
            trend: TrendType.positive,
            priority: PriorityLevel.normal,
            timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          ),
          InsightItem(
            emoji: '📅',
            title: 'Upcoming Service',
            description: '2 machines due for maintenance within 7 days',
            value: '2 units',
            trend: TrendType.neutral,
            priority: PriorityLevel.normal,
            timestamp: DateTime.now().subtract(const Duration(hours: 7)),
          ),
          InsightItem(
            emoji: '🛠️',
            title: 'Predictive Maintenance',
            description: 'AI suggests early service for Conveyor C',
            value: 'Priority',
            trend: TrendType.negative,
            priority: PriorityLevel.high,
            timestamp: DateTime.now().subtract(const Duration(hours: 8)),
          ),
        ],
      ),
    );

    // Environmental Impact
    insights.add(
      InsightCategory(
        title: '🌱 Sustainability',
        icon: '🌱',
        items: [
          InsightItem(
            emoji: '🌍',
            title: 'Carbon Footprint',
            description: 'CO₂ emissions reduced by 15 kg today',
            value: '-15 kg',
            trend: TrendType.positive,
            priority: PriorityLevel.high,
            timestamp: DateTime.now().subtract(const Duration(hours: 9)),
          ),
          InsightItem(
            emoji: '💧',
            title: 'Water Conservation',
            description: 'Water usage optimized, saving 150 liters',
            value: '150L',
            trend: TrendType.positive,
            priority: PriorityLevel.normal,
            timestamp: DateTime.now().subtract(const Duration(hours: 10)),
          ),
          InsightItem(
            emoji: '♻️',
            title: 'Recycling Rate',
            description: 'Material recycling rate at 87%',
            value: '87%',
            trend: TrendType.positive,
            priority: PriorityLevel.normal,
            timestamp: DateTime.now().subtract(const Duration(hours: 11)),
          ),
        ],
      ),
    );

    // AI Recommendations
    insights.add(
      InsightCategory(
        title: '🤖 AI Recommendations',
        icon: '🤖',
        items: [
          InsightItem(
            emoji: '💡',
            title: 'Optimization Tip',
            description:
                'Reduce Crusher 2 feed rate by 5% for better efficiency',
            value: '-5%',
            trend: TrendType.neutral,
            priority: PriorityLevel.normal,
            timestamp: DateTime.now().subtract(const Duration(hours: 12)),
          ),
          InsightItem(
            emoji: '⚙️',
            title: 'Parameter Adjustment',
            description: 'Mill speed can be increased to 65 RPM safely',
            value: '+5 RPM',
            trend: TrendType.positive,
            priority: PriorityLevel.normal,
            timestamp: DateTime.now().subtract(const Duration(hours: 13)),
          ),
          InsightItem(
            emoji: '📊',
            title: 'Workload Balance',
            description:
                'Redistribute load to Crusher A for optimal performance',
            value: 'Action',
            trend: TrendType.neutral,
            priority: PriorityLevel.high,
            timestamp: DateTime.now().subtract(const Duration(hours: 14)),
          ),
        ],
      ),
    );

    _updateStatistics();
  }

  void _updateInsights() {
    // Simulate new insights
    for (var category in insights) {
      for (var item in category.items) {
        // Random value updates
        if (_random.nextDouble() < 0.3) {
          item.timestamp = DateTime.now();
        }
      }
    }
    insights.refresh();
  }

  void _updateStatistics() {
    totalInsights.value = insights.fold(
      0,
      (sum, cat) => sum + cat.items.length,
    );
    criticalInsights.value = insights
        .expand((cat) => cat.items)
        .where((item) => item.priority == PriorityLevel.critical)
        .length;
    positiveInsights.value = insights
        .expand((cat) => cat.items)
        .where((item) => item.trend == TrendType.positive)
        .length;
    improvementSuggestions.value = insights
        .where((cat) => cat.title.contains('Recommendation'))
        .fold(0, (sum, cat) => sum + cat.items.length);
  }

  void regenerateReport() {
    isGenerating.value = true;
    generationProgress.value = 0.0;

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      generationProgress.value += 0.1;

      if (generationProgress.value >= 1.0) {
        timer.cancel();
        _generateReport();
        isGenerating.value = false;
        generationProgress.value = 0.0;

        Get.snackbar(
          'Report Generated',
          'AI summary has been updated with latest insights',
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    });
  }

  void downloadPDF() {
    Get.snackbar(
      '📄 Generating PDF',
      'Your daily report is being prepared for download...',
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.snackbar(
        '✅ PDF Ready',
        'Report downloaded: AI_Summary_${_formatDate(DateTime.now())}.pdf',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }

  void playVoiceSummary() {
    isPlayingVoice.value = true;

    Get.snackbar(
      '🔊 Voice Playback',
      'Playing AI-generated summary...',
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );

    // Simulate voice playback duration
    Future.delayed(const Duration(seconds: 8), () {
      isPlayingVoice.value = false;

      Get.snackbar(
        '✅ Playback Complete',
        'Voice summary finished',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }

  void stopVoicePlayback() {
    isPlayingVoice.value = false;

    Get.snackbar(
      '⏸️ Playback Stopped',
      'Voice summary paused',
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String getRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  void onClose() {
    _updateTimer?.cancel();
    super.onClose();
  }
}

enum TrendType { positive, negative, neutral }

enum PriorityLevel { normal, high, critical }

class InsightCategory {
  final String title;
  final String icon;
  final List<InsightItem> items;

  InsightCategory({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class InsightItem {
  final String emoji;
  final String title;
  final String description;
  final String value;
  final TrendType trend;
  final PriorityLevel priority;
  DateTime timestamp;

  InsightItem({
    required this.emoji,
    required this.title,
    required this.description,
    required this.value,
    required this.trend,
    required this.priority,
    required this.timestamp,
  });
}
