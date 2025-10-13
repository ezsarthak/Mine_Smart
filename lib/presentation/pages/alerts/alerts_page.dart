// filename: lib/presentation/pages/alerts/alerts_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../controllers/alert_controller.dart';
import '../widgets/alert_card.dart';
import '../../../core/theme/app_theme.dart';

class AlertsPage extends StatelessWidget {
  AlertsPage({super.key});

  final AlertController _controller = Get.put(AlertController());

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
                      const SizedBox(height: 24),
                      _buildFilterTabs(context),
                      const SizedBox(height: 24),
                      _buildAlertsList(context),
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
              'Smart Alerts',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Real-Time Monitoring & Notifications',
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
          final count = _controller.unresolvedCount.value;
          if (count > 0) {
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
                      Icon(
                            Icons.notifications_active,
                            color: Colors.white,
                            size: 16,
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .shake(duration: 1000.ms),
                      const SizedBox(width: 6),
                      Text(
                        '$count Active',
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
          }
          return const SizedBox.shrink();
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
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'Total',
                _controller.allAlerts.length,
                Icons.list_alt,
                AppTheme.accentColor,
              ),
            ),
            Container(width: 1, height: 50, color: Colors.white12),
            Expanded(
              child: _buildStatItem(
                'Active',
                _controller.unresolvedAlerts.length,
                Icons.warning,
                AppTheme.errorColor,
              ),
            ),
            Container(width: 1, height: 50, color: Colors.white12),
            Expanded(
              child: _buildStatItem(
                'Resolved',
                _controller.resolvedAlerts.length,
                Icons.check_circle,
                AppTheme.successColor,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatItem(String label, int count, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              duration: 1000.ms,
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
            ),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: TextStyle(
            color: color,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFilterTabs(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(child: _buildFilterTab('All', 'all', Icons.list)),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFilterTab('Active', 'unresolved', Icons.warning),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFilterTab('Resolved', 'resolved', Icons.check_circle),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildFilterTab(String label, String value, IconData icon) {
    final isSelected = _controller.selectedFilter.value == value;
    final color = value == 'unresolved'
        ? AppTheme.errorColor
        : value == 'resolved'
        ? AppTheme.successColor
        : AppTheme.accentColor;

    return GestureDetector(
      onTap: () => _controller.setFilter(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [color, color.withOpacity(0.7)])
              : null,
          color: isSelected ? null : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsList(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return _buildShimmerLoading();
      }

      final alerts = _controller.displayedAlerts;

      if (alerts.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return AlertCard(
                alert: alert,
                onResolve: () => _controller.resolveAlert(alert),
                onDelete: () => _showDeleteDialog(alert),
              )
              .animate()
              .fadeIn(delay: (200 + index * 50).ms)
              .slideX(begin: 0.2, end: 0);
        },
      );
    });
  }

  Widget _buildShimmerLoading() {
    return Column(
      children: List.generate(
        5,
        (index) => Shimmer.fromColors(
          baseColor: AppTheme.cardColor,
          highlightColor: AppTheme.primaryColor.withOpacity(0.3),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.white24,
          ).animate().fadeIn().scale(),
          const SizedBox(height: 24),
          Text(
            'No Alerts',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          Text(
            'All systems operating normally',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  void _showDeleteDialog(dynamic alert) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Alert',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this alert?',
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
              _controller.deleteAlert(alert);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
