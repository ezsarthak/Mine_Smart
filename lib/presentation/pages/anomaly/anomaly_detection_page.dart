// filename: lib/presentation/pages/anomaly/anomaly_detection_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../controllers/anomaly_detection_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/health_radar_chart.dart';

class AnomalyDetectionPage extends StatelessWidget {
  AnomalyDetectionPage({super.key});

  final AnomalyDetectionController _controller = Get.put(
    AnomalyDetectionController(),
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
                      _buildStatsOverview(context),
                      const SizedBox(height: 32),
                      _buildEquipmentGrid(context),
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
              'Anomaly Detection',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.shield, color: AppTheme.accentColor, size: 14),
                const SizedBox(width: 4),
                Text(
                  'AI-Powered Health Monitoring',
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
        Obx(() {
          final hasCritical = _controller.criticalAnomalies.value > 0;
          if (!hasCritical) return const SizedBox.shrink();

          return Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.errorColor,
                      AppTheme.errorColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.errorColor.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white, size: 16)
                        .animate(onPlay: (controller) => controller.repeat())
                        .shake(duration: 1000.ms),
                    const SizedBox(width: 6),
                    Text(
                      '${_controller.criticalAnomalies.value} Critical',
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
              .fadeIn(duration: 1000.ms)
              .then()
              .fadeOut(duration: 1000.ms);
        }),
      ],
    );
  }

  Widget _buildStatsOverview(BuildContext context) {
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
                Icon(Icons.analytics, color: AppTheme.accentColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  'System Overview',
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
                  child: _buildStatBox(
                    'System Health',
                    '${_controller.systemHealthScore.value.toStringAsFixed(1)}%',
                    Icons.favorite,
                    _getHealthColor(_controller.systemHealthScore.value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'Critical',
                    _controller.criticalAnomalies.value.toString(),
                    Icons.error,
                    AppTheme.errorColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    'Warnings',
                    _controller.warningAnomalies.value.toString(),
                    Icons.warning,
                    AppTheme.warningColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'Total Detected',
                    _controller.totalAnomaliesDetected.value.toString(),
                    Icons.find_in_page,
                    AppTheme.accentColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color color) {
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
                value,
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
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: color.withOpacity(0.7), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentGrid(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Equipment Health',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _controller.equipmentList.length,
            itemBuilder: (context, index) {
              final equipment = _controller.equipmentList[index];
              return _buildEquipmentCard(context, equipment, index)
                  .animate()
                  .fadeIn(delay: (200 + index * 100).ms)
                  .slideX(begin: 0.2, end: 0);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentCard(
    BuildContext context,
    EquipmentHealth equipment,
    int index,
  ) {
    final riskLevel = equipment.getRiskLevel();
    final color = _getRiskColor(riskLevel);

    return GestureDetector(
      onTap: () => _showEquipmentDetails(context, equipment),
      child:
          Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.15), AppTheme.cardColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: riskLevel == 'critical'
                        ? color
                        : color.withOpacity(0.3),
                    width: riskLevel == 'critical' ? 3 : 2,
                  ),
                  boxShadow: riskLevel == 'critical'
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            equipment.icon,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                equipment.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${equipment.overallHealth.toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: color,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: color),
                              ),
                              child: Text(
                                riskLevel.toUpperCase(),
                                style: TextStyle(
                                  color: color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    HealthRadarChart(
                      dataPoints: equipment.parameters
                          .map(
                            (p) => RadarDataPoint(
                              label: p.name,
                              value: p.healthScore,
                            ),
                          )
                          .toList(),
                      size: 250,
                      onSegmentTap: (segmentIndex) {
                        _showAnomalyAnalysis(
                          context,
                          equipment,
                          equipment.parameters[segmentIndex],
                        );
                      },
                    ),
                  ],
                ),
              )
              .animate(
                onPlay: (controller) =>
                    riskLevel == 'critical' ? controller.repeat() : null,
              )
              .fadeIn(duration: 1000.ms)
              .then()
              .fadeOut(duration: 1000.ms),
    );
  }

  void _showEquipmentDetails(BuildContext context, EquipmentHealth equipment) {
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
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            equipment.icon,
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  equipment.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  equipment.type,
                                  style: TextStyle(
                                    color: AppTheme.accentColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Parameter Health Status',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: equipment.parameters.length,
                          itemBuilder: (context, index) {
                            final param = equipment.parameters[index];
                            final color = _getHealthColor(param.healthScore);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: color.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          param.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        LinearProgressIndicator(
                                          value: param.healthScore / 100,
                                          backgroundColor: Colors.white
                                              .withOpacity(0.1),
                                          color: color,
                                          minHeight: 6,
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    '${param.healthScore.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().slideY(
            begin: 1,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOut,
          ),
    );
  }

  void _showAnomalyAnalysis(
    BuildContext context,
    EquipmentHealth equipment,
    HealthParameter parameter,
  ) {
    final analysis = _controller.analyzeAnomaly(equipment, parameter);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(
              Icons.search,
              color: _getRiskColor(analysis.riskLevel.toLowerCase()),
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Anomaly Analysis',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getRiskColor(
                        analysis.riskLevel.toLowerCase(),
                      ).withOpacity(0.3),
                      AppTheme.backgroundColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          equipment.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getRiskColor(
                              analysis.riskLevel.toLowerCase(),
                            ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getRiskColor(
                                analysis.riskLevel.toLowerCase(),
                              ),
                            ),
                          ),
                          child: Text(
                            analysis.riskLevel.toUpperCase(),
                            style: TextStyle(
                              color: _getRiskColor(
                                analysis.riskLevel.toLowerCase(),
                              ),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      parameter.name,
                      style: TextStyle(
                        color: AppTheme.accentColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Possible Cause',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.errorColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, color: AppTheme.errorColor, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        analysis.primaryCause,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.verified, color: AppTheme.successColor, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Confidence: ${analysis.confidence.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: AppTheme.successColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Recommendations',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...analysis.recommendations.map(
                (rec) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: AppTheme.accentColor,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          rec,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Alert Created',
                'Maintenance team has been notified',
                backgroundColor: AppTheme.successColor,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
            ),
            child: const Text('Create Alert'),
          ),
        ],
      ).animate().scale(duration: 300.ms, curve: Curves.easeOut),
    );
  }

  Color _getHealthColor(double value) {
    if (value >= 80) return AppTheme.successColor;
    if (value >= 60) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }

  Color _getRiskColor(String level) {
    switch (level.toLowerCase()) {
      case 'critical':
        return AppTheme.errorColor;
      case 'warning':
        return AppTheme.warningColor;
      default:
        return AppTheme.successColor;
    }
  }
}
