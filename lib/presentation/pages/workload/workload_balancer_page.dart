// filename: lib/presentation/pages/workload/workload_balancer_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../controllers/workload_balancer_controller.dart';
import '../widgets/animated_flow_arrow.dart';
import '../../../core/theme/app_theme.dart';

class WorkloadBalancerPage extends StatelessWidget {
  WorkloadBalancerPage({super.key});

  final WorkloadBalancerController _controller = Get.put(
    WorkloadBalancerController(),
  );

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
                    _buildStatistics(context),
                    const SizedBox(height: 32),
                    _buildControlPanel(context),
                    const SizedBox(height: 32),
                    _buildFlowDiagram(context),
                    const SizedBox(height: 32),
                    _buildMachineCards(context),
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
                Icon(Icons.balance, color: AppTheme.accentColor, size: 24)
                    .animate(onPlay: (controller) => controller.repeat())
                    .rotate(duration: 3000.ms),
                const SizedBox(width: 8),
                Text(
                  'Workload Balancer',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Adaptive Distribution',
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
              color: _controller.isAutoBalancing.value
                  ? AppTheme.successColor.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _controller.isAutoBalancing.value
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
                        color: _controller.isAutoBalancing.value
                            ? AppTheme.successColor
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    )
                    .animate(
                      onPlay: (controller) => _controller.isAutoBalancing.value
                          ? controller.repeat()
                          : null,
                    )
                    .fadeIn(duration: 1000.ms)
                    .then()
                    .fadeOut(duration: 1000.ms),
                const SizedBox(width: 6),
                Text(
                  _controller.isAutoBalancing.value ? 'AUTO' : 'MANUAL',
                  style: TextStyle(
                    color: _controller.isAutoBalancing.value
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
                  child: _buildStatCard(
                    'Efficiency',
                    '${_controller.systemEfficiency.value.toStringAsFixed(1)}%',
                    Icons.trending_up,
                    AppTheme.successColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Throughput',
                    '${_controller.totalThroughput.value.toStringAsFixed(0)} t/h',
                    Icons.speed,
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
                    'Imbalance',
                    _controller.loadImbalance.value.toStringAsFixed(1),
                    Icons.warning_amber,
                    _controller.loadImbalance.value > 30
                        ? AppTheme.errorColor
                        : AppTheme.warningColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Optimizations',
                    _controller.optimizationCount.value.toString(),
                    Icons.auto_awesome,
                    Colors.purple,
                  ),
                ),
              ],
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
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
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
            textAlign: TextAlign.center,
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel(BuildContext context) {
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
                  onPressed: _controller.toggleAutoBalancing,
                  icon: Obx(
                    () => Icon(
                      _controller.isAutoBalancing.value
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                  label: Obx(
                    () => Text(
                      _controller.isAutoBalancing.value
                          ? 'Disable Auto'
                          : 'Enable Auto',
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
                  onPressed: _controller.manualBalance,
                  icon: const Icon(Icons.tune),
                  label: const Text('Balance Now'),
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
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildFlowDiagram(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor.withOpacity(0.2), AppTheme.cardColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
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
            children: [
              Icon(Icons.account_tree, color: AppTheme.accentColor, size: 24),
              const SizedBox(width: 12),
              Text(
                'Flow Distribution',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildFlowLayout(),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildFlowLayout() {
    return Obx(
      () => Column(
        children: [
          // Source
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildSourceNode()],
          ),
          const SizedBox(height: 20),
          // Vertical connector
          Center(
            child:
                Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.accentColor,
                            AppTheme.accentColor.withOpacity(0.3),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: 2000.ms,
                      color: AppTheme.accentColor.withOpacity(0.5),
                    ),
          ),
          const SizedBox(height: 20),
          // Distribution to crushers
          ...List.generate(_controller.crushers.length, (index) {
            final crusher = _controller.crushers[index];
            final flow = _controller.flows[crusher.id];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (flow != null)
                          AnimatedFlowArrow(
                            flowRate: flow.flowRate,
                            intensity: flow.intensity,
                            isActive: flow.isActive,
                            color: Color(crusher.color),
                            isHorizontal: true,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(flex: 3, child: _buildMiniCrusherNode(crusher)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSourceNode() {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.accentColor.withOpacity(0.3),
              AppTheme.primaryColor,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.accentColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentColor.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.source, color: AppTheme.accentColor, size: 40),
            const SizedBox(height: 12),
            Text(
              'Ore Feed',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
                  '${_controller.totalOreFeed.value.toStringAsFixed(0)} t/h',
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: 2000.ms,
                  color: AppTheme.accentColor.withOpacity(0.5),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniCrusherNode(CrusherMachine crusher) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(crusher.color).withOpacity(0.2), AppTheme.cardColor],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(crusher.color), width: 2),
      ),
      child: Row(
        children: [
          Text(crusher.icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crusher.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${crusher.currentLoad.toStringAsFixed(0)} t/h',
                  style: TextStyle(
                    color: Color(crusher.color),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMachineCards(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Machine Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _controller.crushers.length,
            itemBuilder: (context, index) {
              final crusher = _controller.crushers[index];
              return _buildMachineCard(crusher, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMachineCard(CrusherMachine crusher, int index) {
    final statusColor = _getStatusColor(crusher.status);

    return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(crusher.color).withOpacity(0.2),
                AppTheme.cardColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(crusher.color).withOpacity(0.5),
              width: 2,
            ),
            boxShadow: crusher.status == MachineStatus.critical
                ? [
                    BoxShadow(
                      color: AppTheme.errorColor.withOpacity(0.3),
                      blurRadius: 15,
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
                      color: Color(crusher.color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      crusher.icon,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          crusher.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Capacity: ${crusher.maxCapacity.toStringAsFixed(0)} t/h',
                          style: TextStyle(
                            color: AppTheme.accentColor,
                            fontSize: 12,
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
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      _getStatusLabel(crusher.status),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Load',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${crusher.loadPercentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: Color(crusher.color),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Stack(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width:
                                    MediaQuery.of(Get.context!).size.width *
                                    (crusher.loadPercentage / 100) *
                                    0.4,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(crusher.color),
                                      Color(crusher.color).withOpacity(0.5),
                                    ],
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
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Efficiency',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${crusher.efficiency.toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: _getEfficiencyColor(crusher.efficiency),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Stack(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width:
                                    MediaQuery.of(Get.context!).size.width *
                                    (crusher.efficiency / 100) *
                                    0.4,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _getEfficiencyColor(crusher.efficiency),
                                      _getEfficiencyColor(
                                        crusher.efficiency,
                                      ).withOpacity(0.5),
                                    ],
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
                ],
              ),
            ],
          ),
        )
        .animate(
          onPlay: (controller) => crusher.status == MachineStatus.critical
              ? controller.repeat()
              : null,
        )
        .fadeIn(duration: 1000.ms)
        .then()
        .fadeOut(duration: 1000.ms)
        .animate()
        .fadeIn(delay: (250 + index * 100).ms)
        .slideX(begin: 0.2, end: 0);
  }

  Color _getStatusColor(MachineStatus status) {
    switch (status) {
      case MachineStatus.low:
        return Colors.blue;
      case MachineStatus.optimal:
        return AppTheme.successColor;
      case MachineStatus.high:
        return AppTheme.warningColor;
      case MachineStatus.critical:
        return AppTheme.errorColor;
    }
  }

  String _getStatusLabel(MachineStatus status) {
    switch (status) {
      case MachineStatus.low:
        return 'LOW';
      case MachineStatus.optimal:
        return 'OPTIMAL';
      case MachineStatus.high:
        return 'HIGH';
      case MachineStatus.critical:
        return 'CRITICAL';
    }
  }

  Color _getEfficiencyColor(double efficiency) {
    if (efficiency >= 85) return AppTheme.successColor;
    if (efficiency >= 70) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }
}
