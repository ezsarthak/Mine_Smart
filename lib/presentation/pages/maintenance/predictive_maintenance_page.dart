// filename: lib/presentation/pages/maintenance/predictive_maintenance_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../controllers/predictive_maintenance_controller.dart';
import '../widgets/equipment_card.dart';
import '../widgets/trend_chart.dart';
import '../widgets/maintenance_stats_card.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/predictive_maintenance_service.dart';

class PredictiveMaintenancePage extends StatelessWidget {
  PredictiveMaintenancePage({super.key});

  final PredictiveMaintenanceController _controller = Get.put(
    PredictiveMaintenanceController(),
  );
  final PredictiveMaintenanceService _service =
      Get.find<PredictiveMaintenanceService>();

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
                      _buildStatsOverview(),
                      const SizedBox(height: 32),
                      _buildTrendSection(context),
                      const SizedBox(height: 32),
                      _buildEquipmentSection(context),
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
              'Predictive Maintenance',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'AI-Powered Equipment Monitoring',
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
          final maintenanceRequired = _controller.getTotalMaintenanceRequired();
          if (maintenanceRequired > 0) {
            return Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.errorColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: AppTheme.errorColor, size: 16)
                      .animate(onPlay: (controller) => controller.repeat())
                      .fadeIn(duration: 500.ms)
                      .then()
                      .fadeOut(duration: 500.ms),
                  const SizedBox(width: 6),
                  Text(
                    '$maintenanceRequired Alert${maintenanceRequired > 1 ? 's' : ''}',
                    style: TextStyle(
                      color: AppTheme.errorColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildStatsOverview() {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppTheme.accentColor),
        );
      }

      final critical = _controller.getCriticalEquipment().length;
      final atRisk = _controller.getAtRiskEquipment().length;
      final healthy = _controller.getHealthyEquipment().length;

      return Row(
        children: [
          Expanded(
            child: MaintenanceStatsCard(
              title: 'Critical',
              count: critical,
              icon: Icons.error,
              color: AppTheme.errorColor,
            ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2, end: 0),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: MaintenanceStatsCard(
              title: 'At Risk',
              count: atRisk,
              icon: Icons.warning,
              color: AppTheme.warningColor,
            ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2, end: 0),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: MaintenanceStatsCard(
              title: 'Healthy',
              count: healthy,
              icon: Icons.check_circle,
              color: AppTheme.successColor,
            ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2, end: 0),
          ),
        ],
      );
    });
  }

  Widget _buildTrendSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Historical Trends',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
        const SizedBox(height: 16),
        Obx(() {
          if (_controller.historicalData.isEmpty) {
            return Center(
              child: Text(
                'No historical data available',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          return Column(
            children: [
              TrendChart(
                title: 'Vibration History',
                data: _controller.getVibrationTrend(),
                unit: 'mm/s',
                color: Colors.purple,
                warningThreshold: 7.0,
                criticalThreshold: 9.0,
              ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2, end: 0),
              const SizedBox(height: 16),
              TrendChart(
                title: 'Temperature History',
                data: _controller.getTemperatureTrend(),
                unit: '°C',
                color: Colors.orange,
                warningThreshold: 70.0,
                criticalThreshold: 80.0,
              ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.2, end: 0),
              const SizedBox(height: 16),
              TrendChart(
                title: 'Energy Consumption',
                data: _controller.getEnergyTrend(),
                unit: 'kW',
                color: AppTheme.accentColor,
                warningThreshold: 400.0,
                criticalThreshold: 450.0,
              ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2, end: 0),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildEquipmentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Equipment Status',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
        const SizedBox(height: 16),
        Obx(() {
          if (_controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.accentColor),
            );
          }

          if (_controller.equipmentList.isEmpty) {
            return Center(
              child: Text(
                'No equipment data available',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _controller.equipmentList.length,
            itemBuilder: (context, index) {
              final equipment = _controller.equipmentList[index];
              final recommendation = _service.getMaintenanceRecommendation(
                equipment,
              );

              return EquipmentCard(
                    equipment: equipment,
                    recommendation: recommendation,
                    onTap: () => _showEquipmentDetails(context, equipment),
                  )
                  .animate()
                  .fadeIn(delay: (200 + index * 100).ms)
                  .slideX(begin: 0.1, end: 0);
            },
          );
        }),
      ],
    );
  }

  void _showEquipmentDetails(BuildContext context, dynamic equipment) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            equipment.status,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          _getEquipmentIcon(equipment.type),
                          color: _getStatusColor(equipment.status),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              equipment.name,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              equipment.type,
                              style: TextStyle(
                                color: AppTheme.accentColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            equipment.status,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(equipment.status),
                          ),
                        ),
                        child: Text(
                          equipment.status.toUpperCase().replaceAll('_', ' '),
                          style: TextStyle(
                            color: _getStatusColor(equipment.status),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildDetailRow(
                    context,
                    'Vibration Level',
                    '${equipment.currentVibration.toStringAsFixed(2)} mm/s',
                    Icons.vibration,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    context,
                    'Temperature',
                    '${equipment.currentTemperature.toStringAsFixed(1)} °C',
                    Icons.thermostat,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    context,
                    'Energy Consumption',
                    '${equipment.avgEnergyConsumption.toStringAsFixed(1)} kW',
                    Icons.bolt,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    context,
                    'Last Maintenance',
                    _formatDate(equipment.lastMaintenance),
                    Icons.build,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    context,
                    'Next Service',
                    _formatDate(equipment.predictedNextService),
                    Icons.schedule,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getStatusColor(equipment.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _getStatusColor(
                          equipment.status,
                        ).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: _getStatusColor(equipment.status),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _service.getMaintenanceRecommendation(equipment),
                            style: TextStyle(
                              color: _getStatusColor(equipment.status),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        Get.snackbar(
                          'Maintenance Scheduled',
                          'Maintenance for ${equipment.name} has been scheduled.',
                          backgroundColor: AppTheme.successColor,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.calendar_month),
                      label: const Text(
                        'Schedule Maintenance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().slideY(
            begin: 1,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOut,
          ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.accentColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
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
      case 'at_risk':
        return AppTheme.warningColor;
      default:
        return AppTheme.successColor;
    }
  }

  IconData _getEquipmentIcon(String type) {
    switch (type) {
      case 'Heavy Machinery':
        return Icons.construction;
      case 'Processing':
        return Icons.settings;
      case 'Transport':
        return Icons.local_shipping;
      case 'Drilling':
        return Icons.handyman;
      default:
        return Icons.precision_manufacturing;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays == -1) {
      return 'Yesterday';
    } else if (difference.inDays > 0 && difference.inDays < 7) {
      return 'In ${difference.inDays} days';
    } else if (difference.inDays < 0 && difference.inDays > -7) {
      return '${-difference.inDays} days ago';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}
