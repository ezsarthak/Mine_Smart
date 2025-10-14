// filename: lib/presentation/pages/optimizer/smart_optimizer_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../controllers/smart_optimizer_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/enery_gauge.dart';

class SmartOptimizerPage extends StatelessWidget {
  SmartOptimizerPage({super.key});

  final SmartOptimizerController _controller = Get.put(
    SmartOptimizerController(),
  );

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
                      _buildEnergyGaugeSection(context),
                      const SizedBox(height: 32),
                      _buildToggleButton(context),
                      const SizedBox(height: 32),
                      _buildSavingsCard(context),
                      const SizedBox(height: 32),
                      _buildIoTReadings(context),
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
            Text(
              'Smart Optimizer',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.auto_awesome, color: AppTheme.accentColor, size: 14),
                const SizedBox(width: 4),
                Text(
                  'AI-Powered Energy Optimization',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppTheme.accentColor),
                ),
              ],
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
              color: _controller.isOptimizationEnabled.value
                  ? AppTheme.successColor.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _controller.isOptimizationEnabled.value
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
                        color: _controller.isOptimizationEnabled.value
                            ? AppTheme.successColor
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    )
                    .animate(
                      onPlay: (controller) =>
                          _controller.isOptimizationEnabled.value
                          ? controller.repeat()
                          : null,
                    )
                    .fadeIn(duration: 1000.ms)
                    .then()
                    .fadeOut(duration: 1000.ms),
                const SizedBox(width: 6),
                Text(
                  _controller.isOptimizationEnabled.value ? 'ACTIVE' : 'IDLE',
                  style: TextStyle(
                    color: _controller.isOptimizationEnabled.value
                        ? AppTheme.successColor
                        : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnergyGaugeSection(BuildContext context) {
    return Obx(
      () => Center(
        child: EnergyGauge(
          percentage: _controller.energySavedPercentage.value,
          size: 280,
          isActive: _controller.isOptimizationEnabled.value,
        ).animate().fadeIn(delay: 100.ms).scale(),
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context) {
    return Obx(() {
      final isEnabled = _controller.isOptimizationEnabled.value;

      return GestureDetector(
        onTap: _controller.toggleOptimization,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isEnabled
                  ? [AppTheme.successColor, AppTheme.accentColor]
                  : [Colors.grey[700]!, Colors.grey[800]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: AppTheme.successColor.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: AppTheme.accentColor.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                    isEnabled ? Icons.power_settings_new : Icons.power_off,
                    color: Colors.white,
                    size: 32,
                  )
                  .animate(
                    onPlay: (controller) =>
                        isEnabled ? controller.repeat() : null,
                  )
                  .rotate(duration: 2000.ms, begin: 0, end: 1),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auto Optimization',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isEnabled ? 'AI Agent Active' : 'Manual Control',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 60,
                height: 32,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? Colors.white.withOpacity(0.3)
                      : Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: isEnabled
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: isEnabled
                              ? AppTheme.accentColor.withOpacity(0.5)
                              : Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
    });
  }

  Widget _buildSavingsCard(BuildContext context) {
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
              children: [
                Icon(Icons.savings, color: AppTheme.accentColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Today\'s Savings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                  child: _buildSavingBox(
                    'Energy Saved',
                    '${_controller.getTotalEnergySavedKwh().toStringAsFixed(1)} kWh',
                    Icons.bolt,
                    AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSavingBox(
                    'Cost Savings',
                    '\$${_controller.getCostSavings().toStringAsFixed(2)}',
                    Icons.attach_money,
                    AppTheme.successColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildSavingBox(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
                value,
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
            style: TextStyle(color: color.withOpacity(0.7), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildIoTReadings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Equipment Metrics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
        const SizedBox(height: 16),
        Obx(
          () => Column(
            children: [
              _buildMetricCard(
                'Crusher Speed',
                _controller.crusherSpeed.value,
                'RPM',
                Icons.settings,
                Colors.orange,
                850.0,
                780.0,
              ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              _buildMetricCard(
                'Feed Rate',
                _controller.feedRate.value,
                't/h',
                Icons.input,
                Colors.blue,
                120.0,
                105.0,
              ).animate().fadeIn(delay: 350.ms).slideX(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              _buildMetricCard(
                'Mill Rotation',
                _controller.millRotation.value,
                'RPM',
                Icons.refresh,
                Colors.purple,
                18.5,
                16.8,
              ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              _buildMetricCard(
                'Belt Speed',
                _controller.beltSpeed.value,
                'm/s',
                Icons.compare_arrows,
                Colors.teal,
                2.5,
                2.2,
              ).animate().fadeIn(delay: 450.ms).slideX(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              _buildMetricCard(
                'Power Consumption',
                _controller.powerConsumption.value,
                'kW',
                Icons.power,
                AppTheme.accentColor,
                425.0,
                310.0,
              ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              _buildMetricCard(
                'Vibration Level',
                _controller.vibrationLevel.value,
                'mm/s',
                Icons.vibration,
                Colors.red,
                4.2,
                2.8,
              ).animate().fadeIn(delay: 550.ms).slideX(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              _buildMetricCard(
                'Temperature',
                _controller.temperature.value,
                '°C',
                Icons.thermostat,
                Colors.deepOrange,
                68.0,
                58.0,
              ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              _buildMetricCard(
                'Efficiency',
                _controller.efficiency.value,
                '%',
                Icons.speed,
                AppTheme.successColor,
                72.0,
                88.0,
              ).animate().fadeIn(delay: 650.ms).slideX(begin: 0.2, end: 0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String label,
    double value,
    String unit,
    IconData icon,
    Color color,
    double normalValue,
    double optimizedValue,
  ) {
    final isOptimized = _controller.isOptimizationEnabled.value;
    final progress = isOptimized
        ? ((value - normalValue) / (optimizedValue - normalValue)).abs().clamp(
            0.0,
            1.0,
          )
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), AppTheme.cardColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: isOptimized
            ? [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                          value.toStringAsFixed(1),
                          style: TextStyle(
                            color: color,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(
                          duration: 2000.ms,
                          color: color.withOpacity(0.3),
                        ),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        unit,
                        style: TextStyle(
                          color: color.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: 6,
                        width:
                            MediaQuery.of(Get.context!).size.width *
                            progress *
                            0.6,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.5)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isOptimized && progress > 0.7)
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
                        Icons.check_circle,
                        color: AppTheme.successColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Optimized',
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
    );
  }
}
