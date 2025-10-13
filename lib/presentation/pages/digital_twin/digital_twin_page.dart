// filename: lib/presentation/pages/digital_twin/digital_twin_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../controllers/digital_twin_controller.dart';
import '../widgets/animated_equipment.dart';
import '../widgets/twin_metric_card.dart';
import '../../../core/theme/app_theme.dart';

class DigitalTwinPage extends StatelessWidget {
  DigitalTwinPage({super.key});

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
                    _buildEquipmentInfo(context),
                    const SizedBox(height: 24),
                    _buildEquipmentVisualization(context),
                    const SizedBox(height: 32),
                    _buildControlPanel(context),
                    const SizedBox(height: 32),
                    _buildMetricsGrid(context),
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
            Text(
              'Digital Twin',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Real-Time Equipment Simulation',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.accentColor),
            ),
          ],
        ),
        titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
      ),
      actions: [
        Obx(() {
          final status = _controller.equipmentStatus.value;
          return Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getStatusColor(status)),
            ),
            child: Row(
              children: [
                Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        shape: BoxShape.circle,
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .fadeIn(duration: 1000.ms)
                    .then()
                    .fadeOut(duration: 1000.ms),
                const SizedBox(width: 6),
                Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEquipmentInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor.withOpacity(0.3), AppTheme.cardColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.precision_manufacturing,
              color: AppTheme.accentColor,
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Industrial Crusher Unit',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Model: HC-2000X',
                  style: TextStyle(color: AppTheme.accentColor, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.white54),
                    const SizedBox(width: 4),
                    Text(
                      'Sector A, Bay 3',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildEquipmentVisualization(BuildContext context) {
    return Container(
          height: 400,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.2),
                AppTheme.backgroundColor,
              ],
              center: Alignment.center,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.accentColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Background grid
                CustomPaint(painter: GridPainter(), size: Size.infinite),
                // Equipment animation
                Center(
                  child: Obx(
                    () => AnimatedEquipment(
                      rotationSpeed: _controller.rotationSpeed.value,
                      glowIntensity: _controller.glowIntensity.value,
                      temperature: _controller.temperature.value,
                      vibration: _controller.vibration.value,
                    ),
                  ),
                ),
                // Status overlay
                Positioned(
                  top: 16,
                  left: 16,
                  child: Obx(() {
                    if (_controller.isStressTesting.value) {
                      return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.errorColor.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                      Icons.warning,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(),
                                    )
                                    .shake(duration: 500.ms),
                                const SizedBox(width: 8),
                                Text(
                                  'STRESS TEST: ${_controller.stressTestCountdown.value}s',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .fadeIn(duration: 500.ms)
                          .then()
                          .fadeOut(duration: 500.ms);
                    }
                    return const SizedBox.shrink();
                  }),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 200.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  Widget _buildControlPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Simulation Controls',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
        const SizedBox(height: 16),
        Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _controller.isStressTesting.value
                    ? null
                    : () => _controller.startStressTest(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _controller.isStressTesting.value
                      ? Colors.grey
                      : AppTheme.errorColor,
                  disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: _controller.isStressTesting.value ? 0 : 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _controller.isStressTesting.value
                          ? Icons.hourglass_empty
                          : Icons.speed,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _controller.isStressTesting.value
                          ? 'Test in Progress...'
                          : 'Start Stress Test',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 12),
        Text(
          'Simulates high-load conditions for 10 seconds',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Metrics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
        const SizedBox(height: 16),
        Obx(
          () => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child:
                        TwinMetricCard(
                              title: 'Temperature',
                              value: _controller.temperature.value,
                              unit: '°C',
                              icon: Icons.thermostat,
                              color: _getTemperatureColor(
                                _controller.temperature.value,
                              ),
                              maxValue: 100,
                            )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideX(begin: -0.2, end: 0),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child:
                        TwinMetricCard(
                              title: 'Vibration',
                              value: _controller.vibration.value,
                              unit: 'mm/s',
                              icon: Icons.vibration,
                              color: _getVibrationColor(
                                _controller.vibration.value,
                              ),
                              maxValue: 15,
                            )
                            .animate()
                            .fadeIn(delay: 250.ms)
                            .slideX(begin: -0.2, end: 0),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child:
                        TwinMetricCard(
                              title: 'Energy',
                              value: _controller.energy.value,
                              unit: 'kW',
                              icon: Icons.bolt,
                              color: AppTheme.accentColor,
                              maxValue: 600,
                            )
                            .animate()
                            .fadeIn(delay: 300.ms)
                            .slideX(begin: -0.2, end: 0),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child:
                        TwinMetricCard(
                              title: 'RPM',
                              value: _controller.rotationSpeed.value * 60,
                              unit: 'rpm',
                              icon: Icons.rotate_right,
                              color: Colors.purple,
                              maxValue: 360,
                            )
                            .animate()
                            .fadeIn(delay: 350.ms)
                            .slideX(begin: -0.2, end: 0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'critical':
        return AppTheme.errorColor;
      case 'warning':
        return AppTheme.warningColor;
      default:
        return AppTheme.successColor;
    }
  }

  Color _getTemperatureColor(double value) {
    if (value >= 80) return AppTheme.errorColor;
    if (value >= 70) return AppTheme.warningColor;
    return AppTheme.successColor;
  }

  Color _getVibrationColor(double value) {
    if (value >= 9) return AppTheme.errorColor;
    if (value >= 7) return AppTheme.warningColor;
    return AppTheme.successColor;
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentColor.withOpacity(0.1)
      ..strokeWidth = 1;

    const spacing = 30.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
