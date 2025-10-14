// filename: lib/presentation/pages/ore_hardness/ore_hardness_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/ore_hardness_controller.dart';
import '../widgets/hardness_indicator.dart';
import '../../../core/theme/app_theme.dart';

class OreHardnessPage extends StatelessWidget {
  OreHardnessPage({super.key});

  final OreHardnessController _controller = Get.put(OreHardnessController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh logic
          },
          color: AppTheme.accentColor,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHardnessIndicatorSection(context),
                      const SizedBox(height: 24),
                      _buildAIStatusBadge(context),
                      const SizedBox(height: 32),
                      _buildTrendChart(context),
                      const SizedBox(height: 32),
                      _buildStatistics(context),
                      const SizedBox(height: 32),
                      _buildRecommendations(context),
                      const SizedBox(height: 32),
                      _buildControls(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: AppTheme.cardColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.accentColor),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: AppTheme.accentColor, size: 24)
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: 2000.ms,
                      color: AppTheme.accentColor.withOpacity(0.5),
                    ),
                const SizedBox(width: 8),
                Text(
                  'Ore Hardness',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'AI Prediction System',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.accentColor),
            ),
          ],
        ),
        titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
      ),
      actions: [
        Obx(
          () => Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _controller.isLearning.value
                      ? AppTheme.successColor
                      : Colors.grey,
                  _controller.isLearning.value
                      ? AppTheme.successColor.withOpacity(0.5)
                      : Colors.grey.withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _controller.isLearning.value
                      ? AppTheme.successColor.withOpacity(0.3)
                      : Colors.transparent,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.white, size: 16)
                    .animate(
                      onPlay: (controller) => _controller.isLearning.value
                          ? controller.repeat()
                          : null,
                    )
                    .rotate(duration: 2000.ms),
                const SizedBox(width: 6),
                Text(
                  'AI LEARNING',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHardnessIndicatorSection(BuildContext context) {
    return Obx(
      () => Center(
        child: HardnessIndicator(
          hardness: _controller.currentHardness.value,
          level: _controller.hardnessLevel.value,
          size: 280,
        ).animate().fadeIn(delay: 100.ms).scale(),
      ),
    );
  }

  Widget _buildAIStatusBadge(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.accentColor.withOpacity(0.2), AppTheme.cardColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.accentColor.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentColor.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  Icon(
                        Icons.auto_awesome,
                        color: AppTheme.accentColor,
                        size: 28,
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .rotate(duration: 2000.ms),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                        _controller.aiStatus.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                        duration: 2000.ms,
                        color: AppTheme.accentColor.withOpacity(0.3),
                      ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildMiniStat(
                        'Accuracy',
                        '${_controller.predictionAccuracy.value.toStringAsFixed(1)}%',
                        AppTheme.successColor,
                      ),
                      const SizedBox(width: 16),
                      _buildMiniStat(
                        'Confidence',
                        '${_controller.confidenceLevel.value.toStringAsFixed(0)}%',
                        AppTheme.accentColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTrendChart(BuildContext context) {
    return Obx(() {
      if (_controller.trendData.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.accentColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.show_chart,
                      color: AppTheme.accentColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Hardness Trend',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.successColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.show_chart,
                            color: AppTheme.successColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: AppTheme.successColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .fadeIn(duration: 1000.ms)
                    .then()
                    .fadeOut(duration: 1000.ms),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (_controller.trendData.length - 1).toDouble(),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    // Actual data
                    LineChartBarData(
                      spots: _controller.trendData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.value);
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4CAF50),
                          const Color(0xFFFFC107),
                          const Color(0xFFF44336),
                        ],
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF4CAF50).withOpacity(0.3),
                            const Color(0xFFFFC107).withOpacity(0.2),
                            const Color(0xFFF44336).withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Prediction data
                    if (_controller.predictionData.isNotEmpty)
                      LineChartBarData(
                        spots: _controller.predictionData.asMap().entries.map((
                          entry,
                        ) {
                          final baseIndex = _controller.trendData.length - 1;
                          return FlSpot(
                            (baseIndex + entry.key).toDouble(),
                            entry.value.value,
                          );
                        }).toList(),
                        isCurved: true,
                        color: AppTheme.accentColor,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        dashArray: [5, 5],
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.accentColor.withOpacity(0.2),
                              AppTheme.accentColor.withOpacity(0.05),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      // tooltipBgColor: AppTheme.cardColor,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            spot.y.toStringAsFixed(1),
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildChartLegend('Actual', const Color(0xFF4CAF50), false),
                const SizedBox(width: 20),
                _buildChartLegend('Predicted', AppTheme.accentColor, true),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
    });
  }

  Widget _buildChartLegend(String label, Color color, bool isDashed) {
    return Row(
      children: [
        Container(
          width: isDashed ? 24 : 16,
          height: 3,
          decoration: isDashed
              ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: List.generate(
                      5,
                      (index) => index.isEven ? color : Colors.transparent,
                    ),
                  ),
                )
              : BoxDecoration(color: color),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withOpacity(0.3),
              AppTheme.cardColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.accentColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: AppTheme.accentColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Statistics',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    'Average',
                    _controller.averageHardness.value,
                    Icons.trending_flat,
                    AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'Minimum',
                    _controller.minHardness.value,
                    Icons.trending_down,
                    AppTheme.successColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    'Maximum',
                    _controller.maxHardness.value,
                    Icons.trending_up,
                    AppTheme.errorColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'Variation',
                    _controller.hardnessVariation.value,
                    Icons.scatter_plot,
                    AppTheme.warningColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatBox(String label, double value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: color.withOpacity(0.3)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.successColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.settings_suggest,
                  color: AppTheme.successColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'AI Recommendations',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildRecommendationItem(
              'Crusher Pressure',
              '${_controller.recommendedCrusherPressure.value.toStringAsFixed(0)} bar',
              Icons.compress,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem(
              'Feed Rate',
              '${_controller.recommendedFeedRate.value.toStringAsFixed(0)} t/h',
              Icons.input,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem(
              'Energy Efficiency',
              '${_controller.energyEfficiency.value.toStringAsFixed(1)}%',
              Icons.bolt,
              AppTheme.successColor,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildRecommendationItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Controls',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _controller.toggleLearning,
                  icon: Obx(
                    () => Icon(
                      _controller.isLearning.value
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                  label: Obx(
                    () => Text(
                      _controller.isLearning.value ? 'Pause AI' : 'Start AI',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _controller.calibrateSensor,
                  icon: const Icon(Icons.tune),
                  label: const Text('Calibrate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1, end: 0);
  }
}
