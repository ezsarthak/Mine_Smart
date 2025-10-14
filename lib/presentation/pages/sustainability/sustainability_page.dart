// filename: lib/presentation/pages/sustainability/sustainability_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';
import '../../controllers/sustainability_controller.dart';
import '../widgets/carbon_meter.dart';
import '../../../core/theme/app_theme.dart';

class SustainabilityPage extends StatelessWidget {
  SustainabilityPage({super.key});

  final SustainabilityController _controller = Get.put(
    SustainabilityController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _controller.refresh();
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
                      _buildCarbonMeterSection(context),
                      const SizedBox(height: 32),
                      _buildCO2SavedCard(context),
                      const SizedBox(height: 24),
                      _buildPeriodSelector(),
                      const SizedBox(height: 24),
                      _buildEmissionChart(context),
                      const SizedBox(height: 32),
                      _buildImpactMetrics(context),
                      const SizedBox(height: 24),
                      _buildGoalProgress(context),
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
                Icon(Icons.eco, color: AppTheme.successColor, size: 24)
                    .animate(onPlay: (controller) => controller.repeat())
                    .rotate(duration: 3000.ms),
                const SizedBox(width: 8),
                Text(
                  'Sustainability',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Carbon Footprint Tracker',
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
          () =>
              Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.successColor,
                          AppTheme.successColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.successColor.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Score: ${_controller.ecoScore.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    duration: 2000.ms,
                    color: Colors.white.withOpacity(0.3),
                  ),
        ),
      ],
    );
  }

  Widget _buildCarbonMeterSection(BuildContext context) {
    return Obx(
      () => Center(
        child: CarbonMeter(
          intensity: _controller.carbonIntensity.value,
          size: 280,
        ).animate().fadeIn(delay: 100.ms).scale(),
      ),
    );
  }

  Widget _buildCO2SavedCard(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.successColor.withOpacity(0.2),
              AppTheme.cardColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.successColor.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.successColor.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_outlined,
                  color: AppTheme.successColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'CO₂ Saved Today',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0,
                    end: _controller.carbonSavedToday.value,
                  ),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          value.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader =
                                  LinearGradient(
                                    colors: [
                                      AppTheme.successColor,
                                      AppTheme.accentColor,
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(0, 0, 300, 70),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12, left: 8),
                          child: Text(
                            'kg',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.successColor.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: 2000.ms,
                  color: AppTheme.successColor.withOpacity(0.3),
                ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildEcoLeaf(Icons.local_florist, 'Clean Air'),
                _buildEcoLeaf(Icons.water_drop, 'Less Water'),
                _buildEcoLeaf(Icons.energy_savings_leaf, 'Energy Saved'),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildEcoLeaf(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.successColor, size: 32)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(duration: 2000.ms, begin: 0, end: -10)
            .fadeIn(),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.successColor.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Obx(
      () => Row(
        children: [
          Expanded(child: _buildPeriodButton('Day', 'day')),
          const SizedBox(width: 12),
          Expanded(child: _buildPeriodButton('Month', 'month')),
          const SizedBox(width: 12),
          Expanded(child: _buildPeriodButton('Year', 'year')),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildPeriodButton(String label, String value) {
    final isSelected = _controller.selectedPeriod.value == value;

    return GestureDetector(
      onTap: () => _controller.changePeriod(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppTheme.successColor, AppTheme.accentColor],
                )
              : null,
          color: isSelected ? null : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.successColor
                : AppTheme.successColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.successColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildEmissionChart(BuildContext context) {
    return Obx(() {
      final data = _controller.getCurrentPeriodData();
      if (data.isEmpty) {
        return _buildShimmerChart();
      }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Emission Trends',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                _buildTrendIndicator(_controller.getEmissionTrend()),
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
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: data.length / 6,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < data.length) {
                            return Text(
                              _formatTimeLabel(data[value.toInt()].timestamp),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
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
                  maxX: (data.length - 1).toDouble(),
                  minY: 0,
                  maxY: _controller.getPeakEmission() * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.value);
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [AppTheme.successColor, AppTheme.accentColor],
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          final isOptimized = data[index].isOptimized;
                          return FlDotCirclePainter(
                            radius: 4,
                            color: isOptimized
                                ? AppTheme.successColor
                                : AppTheme.warningColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.successColor.withOpacity(0.3),
                            AppTheme.accentColor.withOpacity(0.1),
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
                            '${spot.y.toStringAsFixed(1)} kg CO₂',
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
            _buildChartLegend(),
          ],
        ),
      ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1, end: 0);
    });
  }

  Widget _buildTrendIndicator(String trend) {
    IconData icon;
    Color color;
    String label;

    switch (trend) {
      case 'decreasing':
        icon = Icons.trending_down;
        color = AppTheme.successColor;
        label = 'Improving';
        break;
      case 'increasing':
        icon = Icons.trending_up;
        color = AppTheme.errorColor;
        label = 'Worsening';
        break;
      default:
        icon = Icons.trending_flat;
        color = AppTheme.warningColor;
        label = 'Stable';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Optimized', AppTheme.successColor),
        const SizedBox(width: 20),
        _buildLegendItem('Normal', AppTheme.warningColor),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildImpactMetrics(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Environmental Impact',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildImpactCard(
                  '🌳',
                  'Trees',
                  _controller.treesEquivalent.value,
                  'equivalent',
                  AppTheme.successColor,
                ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2, end: 0),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildImpactCard(
                  '⚡',
                  'Energy',
                  _controller.energySavedKwh.value,
                  'kWh saved',
                  AppTheme.accentColor,
                ).animate().fadeIn(delay: 350.ms).slideX(begin: -0.2, end: 0),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildImpactCard(
                  '💧',
                  'Water',
                  _controller.waterSavedLiters.value,
                  'liters saved',
                  Colors.blue,
                ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2, end: 0),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildImpactCard(
                  '🌍',
                  'Impact',
                  _controller.ecoScore.value.toDouble(),
                  'eco score',
                  Colors.green,
                ).animate().fadeIn(delay: 450.ms).slideX(begin: -0.2, end: 0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard(
    String emoji,
    String label,
    double value,
    String unit,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), AppTheme.cardColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40))
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                duration: 2000.ms,
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
              ),
          const SizedBox(height: 12),
          Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: color.withOpacity(0.3)),
          const SizedBox(height: 4),
          Text(
            unit,
            style: TextStyle(color: color.withOpacity(0.7), fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(24),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.flag, color: AppTheme.accentColor, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Monthly Goal',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${_controller.goalProgress.value.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: 20,
                        width:
                            MediaQuery.of(context).size.width *
                            (_controller.goalProgress.value / 100),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.successColor,
                              AppTheme.accentColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.successColor.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: 2000.ms,
                  color: AppTheme.accentColor.withOpacity(0.3),
                ),
            const SizedBox(height: 16),
            Text(
              '${_controller.carbonSavedToday.value.toStringAsFixed(2)} / ${_controller.monthlyGoal.value.toStringAsFixed(0)} kg CO₂',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildShimmerChart() {
    return Shimmer.fromColors(
      baseColor: AppTheme.cardColor,
      highlightColor: AppTheme.primaryColor.withOpacity(0.3),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  String _formatTimeLabel(DateTime timestamp) {
    switch (_controller.selectedPeriod.value) {
      case 'day':
        return '${timestamp.hour}h';
      case 'month':
        return '${timestamp.day}';
      case 'year':
        return 'W${((timestamp.day / 7).ceil())}';
      default:
        return '';
    }
  }
}
