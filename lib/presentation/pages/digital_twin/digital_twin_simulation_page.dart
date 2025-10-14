// filename: lib/presentation/pages/digital_twin/digital_twin_simulation_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/digital_twin_controller.dart';
import '../../../core/theme/app_theme.dart';

class DigitalTwinSimulationPage extends StatelessWidget {
  DigitalTwinSimulationPage({super.key});

  final DigitalTwinController _controller = Get.put(DigitalTwinController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
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
                    _buildAlertBanner(),
                    const SizedBox(height: 24),
                    _buildPlantSchematic(context),
                    const SizedBox(height: 32),
                    _buildControlPanel(context),
                    const SizedBox(height: 32),
                    _buildOutputMetrics(context),
                    const SizedBox(height: 32),
                    _buildPerformanceCharts(context),
                  ],
                ),
              ),
            ),
          ],
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
                Icon(Icons.account_tree, color: AppTheme.accentColor, size: 24)
                    .animate(onPlay: (controller) => controller.repeat())
                    .rotate(duration: 3000.ms),
                const SizedBox(width: 8),
                Text(
                  'Digital Twin',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Live Simulation',
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
          () => IconButton(
            icon: Icon(
              _controller.isSimulating.value
                  ? Icons.pause_circle
                  : Icons.play_circle,
              color: _controller.isSimulating.value
                  ? AppTheme.errorColor
                  : AppTheme.successColor,
              size: 32,
            ),
            onPressed: () {
              if (_controller.isSimulating.value) {
                _controller.stopSimulation();
              } else {
                _controller.startSimulation();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAlertBanner() {
    return Obx(() {
      if (_controller.currentAlert.value.isEmpty)
        return const SizedBox.shrink();

      Color alertColor;
      IconData alertIcon;

      switch (_controller.alertLevel.value) {
        case 'critical':
          alertColor = AppTheme.errorColor;
          alertIcon = Icons.error;
          break;
        case 'warning':
          alertColor = AppTheme.warningColor;
          alertIcon = Icons.warning;
          break;
        default:
          alertColor = AppTheme.successColor;
          alertIcon = Icons.check_circle;
      }

      return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: alertColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: alertColor, width: 2),
            ),
            child: Row(
              children: [
                Icon(alertIcon, color: alertColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _controller.currentAlert.value,
                    style: TextStyle(
                      color: alertColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          )
          .animate(onPlay: (controller) => controller.repeat())
          .fadeIn(duration: 1000.ms)
          .then()
          .fadeOut(duration: 1000.ms);
    });
  }

  Widget _buildPlantSchematic(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor.withOpacity(0.2), AppTheme.cardColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
              Text(
                'Plant Layout',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _controller.isSimulating.value
                        ? AppTheme.successColor.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _controller.isSimulating.value
                          ? AppTheme.successColor
                          : Colors.grey,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _controller.isSimulating.value
                                  ? AppTheme.successColor
                                  : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          )
                          .animate(
                            onPlay: (controller) =>
                                _controller.isSimulating.value
                                ? controller.repeat()
                                : null,
                          )
                          .fadeIn(duration: 1000.ms)
                          .then()
                          .fadeOut(duration: 1000.ms),
                      const SizedBox(width: 6),
                      Text(
                        _controller.isSimulating.value ? 'LIVE' : 'PAUSED',
                        style: TextStyle(
                          color: _controller.isSimulating.value
                              ? AppTheme.successColor
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildPlantFlow(),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildPlantFlow() {
    return Obx(
      () => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildComponent(
                'Feeder',
                Icons.input,
                _controller.feedRate.value,
                Colors.blue,
              ),
              _buildFlowArrow(),
              _buildComponent(
                'Crusher',
                Icons.settings,
                _controller.crusherLoad.value,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFlowArrowVertical(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildComponent(
                'Conveyor',
                Icons.compare_arrows,
                _controller.conveyorSpeed.value,
                Colors.teal,
              ),
              _buildFlowArrow(),
              _buildComponent(
                'Mill',
                Icons.refresh,
                _controller.millLoad.value,
                Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFlowArrowVertical(),
          const SizedBox(height: 20),
          _buildComponent(
            'Separator',
            Icons.filter_alt,
            _controller.separatorEfficiency.value,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildComponent(
    String name,
    IconData icon,
    double value,
    Color color,
  ) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _controller.isSimulating.value
                ? color
                : color.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: _controller.isSimulating.value
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40)
                .animate(
                  onPlay: (controller) => _controller.isSimulating.value
                      ? controller.repeat()
                      : null,
                )
                .rotate(duration: 2000.ms),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${value.toStringAsFixed(0)}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowArrow() {
    return Obx(
      () =>
          Icon(
                Icons.arrow_forward,
                color: _controller.isSimulating.value
                    ? AppTheme.accentColor
                    : Colors.white24,
                size: 32,
              )
              .animate(
                onPlay: (controller) =>
                    _controller.isSimulating.value ? controller.repeat() : null,
              )
              .fadeIn(duration: 500.ms)
              .then()
              .fadeOut(duration: 500.ms),
    );
  }

  Widget _buildFlowArrowVertical() {
    return Obx(
      () =>
          Icon(
                Icons.arrow_downward,
                color: _controller.isSimulating.value
                    ? AppTheme.accentColor
                    : Colors.white24,
                size: 32,
              )
              .animate(
                onPlay: (controller) =>
                    _controller.isSimulating.value ? controller.repeat() : null,
              )
              .fadeIn(duration: 500.ms)
              .then()
              .fadeOut(duration: 500.ms),
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
              Text(
                'Simulation Controls',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _controller.resetParameters,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Reset'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _controller.optimizeParameters,
                    icon: const Icon(Icons.auto_awesome, size: 18),
                    label: const Text('Optimize'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSlider(
            'Feed Rate',
            _controller.feedRate,
            0,
            200,
            't/h',
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildSlider(
            'Ore Hardness',
            _controller.oreHardness,
            0,
            100,
            '(soft→hard)',
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildSlider(
            'Crushing Pressure',
            _controller.crushingPressure,
            0,
            200,
            'bar',
            Colors.red,
          ),
          const SizedBox(height: 16),
          _buildSlider(
            'Mill Speed',
            _controller.millSpeed,
            0,
            100,
            'RPM',
            Colors.purple,
          ),
          const SizedBox(height: 24),
          _buildSimulateButton(),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildSlider(
    String label,
    RxDouble value,
    double min,
    double max,
    String unit,
    Color color,
  ) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${value.value.toStringAsFixed(0)} $unit',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.2),
              thumbColor: color,
              overlayColor: color.withOpacity(0.3),
              trackHeight: 6,
            ),
            child: Slider(
              value: value.value,
              min: min,
              max: max,
              onChanged: (newValue) {
                value.value = newValue;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulateButton() {
    return Obx(
      () =>
          SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    if (_controller.isSimulating.value) {
                      _controller.stopSimulation();
                    } else {
                      _controller.startSimulation();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _controller.isSimulating.value
                        ? AppTheme.errorColor
                        : AppTheme.successColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _controller.isSimulating.value
                            ? Icons.stop
                            : Icons.play_arrow,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _controller.isSimulating.value
                            ? 'Stop Simulation'
                            : 'Start Simulation',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .animate(
                onPlay: (controller) => !_controller.isSimulating.value
                    ? controller.repeat()
                    : null,
              )
              .scale(
                duration: 1500.ms,
                begin: const Offset(1, 1),
                end: const Offset(1.05, 1.05),
              )
              .then()
              .scale(
                duration: 1500.ms,
                begin: const Offset(1.05, 1.05),
                end: const Offset(1, 1),
              ),
    );
  }

  Widget _buildOutputMetrics(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Output Metrics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Efficiency',
                  _controller.outputEfficiency.value,
                  '%',
                  Icons.speed,
                  _getEfficiencyColor(_controller.outputEfficiency.value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Energy',
                  _controller.energyConsumption.value,
                  'kW',
                  Icons.bolt,
                  AppTheme.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Throughput',
                  _controller.throughput.value,
                  't/h',
                  Icons.trending_up,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Wear Rate',
                  _controller.wearRate.value,
                  '%',
                  Icons.engineering,
                  _controller.wearRate.value > 30
                      ? AppTheme.errorColor
                      : AppTheme.warningColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    double value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
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
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  color: color,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: color.withOpacity(0.3)),
          const SizedBox(height: 4),
          Text(
            unit,
            style: TextStyle(color: color.withOpacity(0.7), fontSize: 12),
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
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildPerformanceCharts(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Trends',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 16),
          _buildChart(
            'Output Efficiency',
            _controller.efficiencyHistory,
            AppTheme.successColor,
            '%',
          ),
          const SizedBox(height: 16),
          _buildChart(
            'Energy Consumption',
            _controller.energyHistory,
            AppTheme.accentColor,
            'kW',
          ),
        ],
      ),
    );
  }

  Widget _buildChart(
    String title,
    List<SimulationDataPoint> data,
    Color color,
    String unit,
  ) {
    if (data.isEmpty) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
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
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (data.length - 1).toDouble(),
                minY:
                    data.map((e) => e.value).reduce((a, b) => a < b ? a : b) *
                    0.9,
                maxY:
                    data.map((e) => e.value).reduce((a, b) => a > b ? a : b) *
                    1.1,
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.value);
                    }).toList(),
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.3),
                          color.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1, end: 0);
  }

  Color _getEfficiencyColor(double efficiency) {
    if (efficiency >= 80) return AppTheme.successColor;
    if (efficiency >= 60) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }
}
