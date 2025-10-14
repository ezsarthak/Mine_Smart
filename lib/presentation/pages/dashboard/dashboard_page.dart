// filename: lib/presentation/pages/dashboard/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../routes/app_routes.dart';
import '../widgets/animated_sensor_card.dart';
import '../widgets/status_indicator.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final AuthController _authController = Get.find<AuthController>();
  final DashboardController _dashboardController = Get.put(
    DashboardController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _dashboardController.refresh();
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
                      _buildWelcomeSection(context),
                      const SizedBox(height: 24),
                      _buildQuickActions(context),
                      const SizedBox(height: 32),
                      _buildStatusOverview(),
                      const SizedBox(height: 32),
                      Text(
                            'Live Monitoring',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          )
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .slideX(begin: -0.1, end: 0),
                      const SizedBox(height: 20),
                      _buildSensorCards(),
                      const SizedBox(height: 32),
                      Text(
                            'Recent Activity',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          )
                          .animate()
                          .fadeIn(delay: 400.ms)
                          .slideX(begin: -0.1, end: 0),
                      const SizedBox(height: 20),
                      _buildRecentReadings(),
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
      expandedHeight: 80,
      floating: true,
      pinned: true,
      backgroundColor: AppTheme.cardColor,
      flexibleSpace: FlexibleSpaceBar(
        title:
            Text(
                  'MineSmart',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentColor,
                  ),
                )
                // Animate only the title
                .animate()
                .fadeIn(delay: 100.ms)
                .slideY(begin: -0.2, end: 0),
        centerTitle: true,
      ),
      actions: [
        // Animate the logout button separately
        IconButton(
          icon: const Icon(Icons.logout, color: AppTheme.accentColor),
          onPressed: () => _showLogoutDialog(context),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final user = _authController.user;
    final displayName = user?.displayName;
    final initial = "SV";
    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.8),
                AppTheme.cardColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.accentColor, width: 2),
                ),
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Supervisor Uday",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.wb_sunny,
                  color: AppTheme.accentColor,
                  size: 24,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 100.ms)
        .slideY(begin: 0.1, end: 0)
        .shimmer(
          delay: 600.ms,
          duration: 1500.ms,
          color: AppTheme.accentColor.withOpacity(0.1),
        );
  }

  // filename: lib/presentation/pages/dashboard/dashboard_page.dart
  // Add this to the _buildQuickActions method to include Alerts button

  // filename: lib/presentation/pages/dashboard/dashboard_page.dart
  // Update the Quick Actions section to include Analytics and Profile

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'label': 'Smart\nAlerts',
        'icon': Icons.notifications_active,
        'color': AppTheme.errorColor,
        'route': AppRoutes.alerts,
        'hasNotification': true,
      },
      {
        'label': 'Digital\nTwin',
        'icon': Icons.view_in_ar,
        'color': Colors.blue,
        'route': AppRoutes.digitalTwin,
      },
      {
        'label': 'Predictive\nMaint.',
        'icon': Icons.engineering,
        'color': AppTheme.accentColor,
        'route': AppRoutes.predictiveMaintenance,
      },
      {
        'label': 'Analytics',
        'icon': Icons.analytics,
        'color': Colors.purple,
        'route': AppRoutes.analytics,
      },
      {
        'label': 'Profile',
        'icon': Icons.person,
        'color': Colors.orange,
        'route': AppRoutes.profile,
      },
      {
        'label': 'Smart\nOptimizer',
        'icon': Icons.auto_awesome,
        'color': Colors.cyan,
        'route': AppRoutes.smartOptimizer,
      },
      {
        'label': 'Anomaly\nDetection',
        'icon': Icons.radar,
        'color': Colors.red,
        'route': AppRoutes.anomalyDetection,
      },
      {
        'label': 'Carbon\nFootprint',
        'icon': Icons.eco,
        'color': Colors.green,
        'route': AppRoutes.sustainability,
      },
      {
        'label': 'Digital Twin\nSimulation',
        'icon': Icons.device_hub,
        'color': Colors.cyan,
        'route': AppRoutes.digitalTwinSimulation,
      },
      {
        'label': 'Maintenance\nScheduler',
        'icon': Icons.build_circle,
        'color': Colors.amber,
        'route': AppRoutes.maintenanceScheduler,
      },
      {
        'label': 'Workload\nBalancer',
        'icon': Icons.balance,
        'color': Colors.deepPurple,
        'route': AppRoutes.workloadBalancer,
      },
      {
        'label': 'Ore Hardness\nAI',
        'icon': Icons.psychology,
        'color': Colors.indigo,
        'route': AppRoutes.oreHardness,
      },
      {
        'label': 'Safety\nDashboard',
        'icon': Icons.security,
        'color': Colors.red,
        'route': AppRoutes.safetyDashboard,
      },
      {
        'label': 'AI\nSummary',
        'icon': Icons.auto_awesome,
        'color': Colors.purple,
        'route': AppRoutes.aiSummary,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flash_on, color: AppTheme.accentColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Quick Actions',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return _buildActionButton(
                context,
                action['label'] as String,
                action['icon'] as IconData,
                action['color'] as Color,
                () => Get.toNamed(action['route'] as String),
                hasNotification: action['hasNotification'] as bool? ?? false,
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool hasNotification = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background icon pattern
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(icon, size: 60, color: color.withOpacity(0.08)),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon container
                  Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.18),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(icon, color: color, size: 24),
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .shimmer(
                        duration: 2000.ms,
                        color: color.withOpacity(0.4),
                      ),
                  const SizedBox(height: 10),
                  // Label
                  Text(
                    label,
                    textAlign: TextAlign.left,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            // Notification badge
            if (hasNotification)
              Positioned(
                top: 8,
                right: 8,
                child:
                    Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.errorColor,
                                AppTheme.errorColor.withOpacity(0.8),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.errorColor.withOpacity(0.6),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        )
                        .animate(onPlay: (controller) => controller.repeat())
                        .fadeIn(duration: 800.ms)
                        .then()
                        .fadeOut(duration: 800.ms),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOverview() {
    return Obx(() {
      final currentReading =
          _dashboardController.sensorController.currentReading.value;
      final status = currentReading?.status ?? 'normal';

      return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getStatusColor(status).withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _getStatusColor(status).withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusItem(
                  'Status',
                  status.toUpperCase(),
                  _getStatusIcon(status),
                  _getStatusColor(status),
                ),
                Container(width: 1, height: 40, color: Colors.white12),
                _buildStatusItem(
                  'Active',
                  'Online',
                  Icons.check_circle,
                  AppTheme.successColor,
                ),
                Container(width: 1, height: 40, color: Colors.white12),
                _buildStatusItem(
                  'Sensors',
                  '3/3',
                  Icons.sensors,
                  AppTheme.accentColor,
                ),
              ],
            ),
          )
          .animate()
          .fadeIn(delay: 150.ms)
          .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
    });
  }

  Widget _buildStatusItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fadeIn()
            .then()
            .shimmer(duration: 2000.ms, color: color.withOpacity(0.3)),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSensorCards() {
    return Obx(() {
      final currentReading =
          _dashboardController.sensorController.currentReading.value;

      if (currentReading == null) {
        return const Center(
          child: CircularProgressIndicator(color: AppTheme.accentColor),
        );
      }

      return Column(
        children: [
          AnimatedSensorCard(
            title: 'Energy Consumption',
            value: currentReading.energy,
            unit: 'kW',
            icon: Icons.bolt,
            color: _getEnergyColor(currentReading.energy),
            trendData: _dashboardController.getEnergyTrend(),
            warningThreshold: AppConstants.energyWarningThreshold,
            criticalThreshold: AppConstants.energyCriticalThreshold,
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2, end: 0),
          const SizedBox(height: 16),
          AnimatedSensorCard(
            title: 'Temperature',
            value: currentReading.temperature,
            unit: '°C',
            icon: Icons.thermostat,
            color: _getTemperatureColor(currentReading.temperature),
            trendData: _dashboardController.getTemperatureTrend(),
            warningThreshold: AppConstants.tempWarningThreshold,
            criticalThreshold: AppConstants.tempCriticalThreshold,
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2, end: 0),
          const SizedBox(height: 16),
          AnimatedSensorCard(
            title: 'Vibration',
            value: currentReading.vibration,
            unit: 'mm/s',
            icon: Icons.vibration,
            color: _getVibrationColor(currentReading.vibration),
            trendData: _dashboardController.getVibrationTrend(),
            warningThreshold: AppConstants.vibrationWarningThreshold,
            criticalThreshold: AppConstants.vibrationCriticalThreshold,
          ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2, end: 0),
        ],
      );
    });
  }

  Widget _buildRecentReadings() {
    return Obx(() {
      if (_dashboardController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppTheme.accentColor),
        );
      }

      if (_dashboardController.recentReadings.isEmpty) {
        return Center(
          child: Text(
            'No readings available',
            style: const TextStyle(color: Colors.white54),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _dashboardController.recentReadings.length.clamp(0, 5),
        itemBuilder: (context, index) {
          final reading = _dashboardController.recentReadings[index];
          return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getStatusColor(reading.status).withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getStatusColor(reading.status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getStatusIcon(reading.status),
                        color: _getStatusColor(reading.status),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              _buildReadingChip(
                                '${reading.energy.toStringAsFixed(1)} kW',
                                AppTheme.accentColor,
                              ),
                              _buildReadingChip(
                                '${reading.temperature.toStringAsFixed(1)}°C',
                                Colors.orange,
                              ),
                              _buildReadingChip(
                                '${reading.vibration.toStringAsFixed(1)} mm/s',
                                Colors.purple,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatTimestamp(reading.timestamp),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatusIndicator(status: reading.status),
                  ],
                ),
              )
              .animate()
              .fadeIn(delay: (500 + index * 50).ms)
              .slideX(begin: 0.1, end: 0);
        },
      );
    });
  }

  Widget _buildReadingChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getTemperatureColor(double value) {
    if (value >= AppConstants.tempCriticalThreshold) return AppTheme.errorColor;
    if (value >= AppConstants.tempWarningThreshold)
      return AppTheme.warningColor;
    return AppTheme.successColor;
  }

  Color _getVibrationColor(double value) {
    if (value >= AppConstants.vibrationCriticalThreshold)
      return AppTheme.errorColor;
    if (value >= AppConstants.vibrationWarningThreshold)
      return AppTheme.warningColor;
    return AppTheme.successColor;
  }

  Color _getEnergyColor(double value) {
    if (value >= AppConstants.energyCriticalThreshold)
      return AppTheme.errorColor;
    if (value >= AppConstants.energyWarningThreshold)
      return AppTheme.warningColor;
    return AppTheme.accentColor;
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

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'critical':
        return Icons.error;
      case 'warning':
        return Icons.warning;
      default:
        return Icons.check_circle;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _authController.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
