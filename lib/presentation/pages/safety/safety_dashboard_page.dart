// filename: lib/presentation/pages/safety/safety_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../controllers/safety_dashboard_controller.dart';
import '../../../core/theme/app_theme.dart';

class SafetyDashboardPage extends StatelessWidget {
  SafetyDashboardPage({super.key});

  final SafetyDashboardController _controller = Get.put(
    SafetyDashboardController(),
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
                      _buildStatisticsOverview(context),
                      const SizedBox(height: 32),
                      _buildAIMonitoringStatus(context),
                      const SizedBox(height: 32),
                      _buildMachineGrid(context),
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
                Icon(Icons.security, color: AppTheme.accentColor, size: 24)
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: 2000.ms,
                      color: AppTheme.accentColor.withOpacity(0.5),
                    ),
                const SizedBox(width: 8),
                Text(
                  'Safety Dashboard',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'AI Risk Prediction',
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
          final hasCritical = _controller.criticalAlerts.value > 0;
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
                      '${_controller.criticalAlerts.value} Critical',
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
              .fadeIn(duration: 500.ms)
              .then()
              .fadeOut(duration: 500.ms);
        }),
      ],
    );
  }

  Widget _buildStatisticsOverview(BuildContext context) {
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
                  'Safety Overview',
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
                  child: _buildStatCard(
                    'Safety Score',
                    '${_controller.overallSafetyScore.value.toStringAsFixed(0)}%',
                    Icons.shield_outlined,
                    _getSafetyScoreColor(_controller.overallSafetyScore.value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Total Machines',
                    _controller.totalMachines.value.toString(),
                    Icons.precision_manufacturing,
                    AppTheme.accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Low Risk',
                    _controller.lowRiskCount.value.toString(),
                    Icons.check_circle,
                    AppTheme.successColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Medium Risk',
                    _controller.mediumRiskCount.value.toString(),
                    Icons.warning_amber,
                    AppTheme.warningColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              'High Risk',
              _controller.highRiskCount.value.toString(),
              Icons.error,
              AppTheme.errorColor,
              fullWidth: true,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color, {
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
                value,
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
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAIMonitoringStatus(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.successColor.withOpacity(0.2),
              AppTheme.cardColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                          Icons.psychology,
                          color: AppTheme.successColor,
                          size: 28,
                        )
                        .animate(onPlay: (controller) => controller.repeat())
                        .rotate(duration: 3000.ms),
                    const SizedBox(width: 12),
                    Text(
                      'AI Monitoring',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _controller.isMonitoring.value,
                  onChanged: (_) => _controller.toggleMonitoring(),
                  activeColor: AppTheme.successColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAIMetric(
                    'Accuracy',
                    '${_controller.aiAccuracy.value.toStringAsFixed(1)}%',
                    Icons.verified,
                    AppTheme.successColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAIMetric(
                    'Predictions',
                    _controller.predictionsMade.value.toString(),
                    Icons.auto_graph,
                    AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAIMetric(
                    'Prevented',
                    _controller.incidentsPrevented.value.toString(),
                    Icons.block,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildAIMetric(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildMachineGrid(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Machine Status',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _controller.machines.length,
            itemBuilder: (context, index) {
              final machine = _controller.machines[index];
              return _buildMachineCard(machine, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMachineCard(MachineSafety machine, int index) {
    final riskColor = _getRiskColor(machine.riskLevel);
    final isHighRisk = machine.riskLevel == RiskLevel.high;

    return GestureDetector(
      onTap: () => _showMachineDetails(machine),
      child:
          AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [riskColor.withOpacity(0.2), AppTheme.cardColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isHighRisk ? riskColor : riskColor.withOpacity(0.3),
                    width: isHighRisk ? 3 : 2,
                  ),
                  boxShadow: isHighRisk
                      ? [
                          BoxShadow(
                            color: riskColor.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: riskColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            machine.icon,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                        if (isHighRisk)
                          Icon(Icons.warning, color: riskColor, size: 32)
                              .animate(
                                onPlay: (controller) => controller.repeat(),
                              )
                              .shake(duration: 1000.ms)
                              .fadeIn(duration: 500.ms)
                              .then()
                              .fadeOut(duration: 500.ms),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      machine.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      machine.type,
                      style: TextStyle(
                        color: AppTheme.accentColor,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: riskColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: riskColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getRiskIcon(machine.riskLevel),
                            color: riskColor,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getRiskLabel(machine.riskLevel),
                            style: TextStyle(
                              color: riskColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: machine.riskScore / 100,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      color: riskColor,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Risk: ${machine.riskScore.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: riskColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
              .animate(
                onPlay: (controller) => isHighRisk ? controller.repeat() : null,
              )
              .fadeIn(duration: 1000.ms)
              .then()
              .fadeOut(duration: 1000.ms)
              .then()
              .fadeIn(duration: 1000.ms)
              .animate()
              .fadeIn(delay: (200 + index * 100).ms)
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
    );
  }

  void _showMachineDetails(MachineSafety machine) {
    Get.dialog(
      Dialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _getRiskColor(
                            machine.riskLevel,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          machine.icon,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              machine.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              machine.type,
                              style: TextStyle(
                                color: AppTheme.accentColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getRiskColor(machine.riskLevel).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getRiskColor(
                          machine.riskLevel,
                        ).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Risk Level: ${_getRiskLabel(machine.riskLevel)}',
                              style: TextStyle(
                                color: _getRiskColor(machine.riskLevel),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${machine.riskScore.toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: _getRiskColor(machine.riskLevel),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: machine.riskScore / 100,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          color: _getRiskColor(machine.riskLevel),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Risk Factors',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...machine.riskFactors.map(
                    (factor) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getSeverityColor(
                          factor.severity,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getSeverityColor(
                            factor.severity,
                          ).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                factor.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getSeverityColor(
                                    factor.severity,
                                  ).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  factor.severity,
                                  style: TextStyle(
                                    color: _getSeverityColor(factor.severity),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            factor.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: (factor.value / factor.threshold)
                                      .clamp(0.0, 1.0),
                                  backgroundColor: Colors.white.withOpacity(
                                    0.1,
                                  ),
                                  color: _getSeverityColor(factor.severity),
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${factor.value.toStringAsFixed(1)}/${factor.threshold.toStringAsFixed(1)}',
                                style: TextStyle(
                                  color: _getSeverityColor(factor.severity),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Prevention Tips',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...machine.preventionTips.map(
                    (tip) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: AppTheme.successColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              tip,
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
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        _controller.acknowledgeMachine(machine.id);
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Acknowledge & Inspect'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate().scale(duration: 300.ms, curve: Curves.easeOut),
    );
  }

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return AppTheme.successColor;
      case RiskLevel.medium:
        return AppTheme.warningColor;
      case RiskLevel.high:
        return AppTheme.errorColor;
    }
  }

  IconData _getRiskIcon(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return Icons.check_circle;
      case RiskLevel.medium:
        return Icons.warning_amber;
      case RiskLevel.high:
        return Icons.error;
    }
  }

  String _getRiskLabel(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return 'LOW RISK';
      case RiskLevel.medium:
        return 'MEDIUM RISK';
      case RiskLevel.high:
        return 'HIGH RISK';
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return AppTheme.successColor;
      case 'medium':
        return AppTheme.warningColor;
      case 'high':
      case 'critical':
        return AppTheme.errorColor;
      default:
        return AppTheme.accentColor;
    }
  }

  Color _getSafetyScoreColor(double score) {
    if (score >= 80) return AppTheme.successColor;
    if (score >= 60) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }
}
