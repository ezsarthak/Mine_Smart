// filename: lib/presentation/pages/maintenance/maintenance_scheduler_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../controllers/maintenance_controller.dart';
import '../widgets/maintenance_calendar.dart';
import '../../../core/theme/app_theme.dart';

class MaintenanceSchedulerPage extends StatelessWidget {
  MaintenanceSchedulerPage({super.key});

  final MaintenanceController _controller = Get.put(MaintenanceController());

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
                      _buildStatistics(context),
                      const SizedBox(height: 24),
                      _buildMaintenanceHeatmap(context),
                      const SizedBox(height: 32),
                      const MaintenanceCalendar(),
                      const SizedBox(height: 32),
                      _buildMachineList(context),
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
                Icon(Icons.build_circle, color: AppTheme.accentColor, size: 24)
                    .animate(onPlay: (controller) => controller.repeat())
                    .rotate(duration: 3000.ms),
                const SizedBox(width: 8),
                Text(
                  'Maintenance',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Predictive Scheduler',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.accentColor),
            ),
          ],
        ),
        titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
      ),
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
                  'Overview',
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
                    'Total Machines',
                    _controller.totalMachines.value.toString(),
                    Icons.precision_manufacturing,
                    AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Upcoming',
                    _controller.upcomingMaintenance.value.toString(),
                    Icons.schedule,
                    AppTheme.warningColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Urgent',
                    _controller.urgentMaintenance.value.toString(),
                    Icons.warning,
                    AppTheme.errorColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Completed',
                    _controller.completedThisMonth.value.toString(),
                    Icons.check_circle,
                    AppTheme.successColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceHeatmap(BuildContext context) {
    return Obx(
      () => Container(
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
              children: [
                Icon(Icons.grid_on, color: AppTheme.accentColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Maintenance Heatmap',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _controller.heatmapData.length,
                itemBuilder: (context, index) {
                  final data = _controller.heatmapData[index];
                  final intensity = (data.count / 20).clamp(0.0, 1.0);
                  final color = _getHeatmapColor(intensity);

                  return Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        Expanded(
                          child:
                              AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [color, color.withOpacity(0.5)],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: color,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: color.withOpacity(0.3),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        data.count.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(delay: (100 * index).ms)
                                  .slideY(begin: 0.3, end: 0),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getMonthName(data.month.month).substring(0, 3),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
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
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildMachineList(BuildContext context) {
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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

  Widget _buildMachineCard(MachineMaintenanceInfo machine, int index) {
    final statusColor = _getStatusColor(machine.status);
    final timeUntil = _controller.getTimeUntilMaintenance(machine);

    return GestureDetector(
      onTap: () => _showMachineDetails(machine),
      child:
          Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [statusColor.withOpacity(0.15), AppTheme.cardColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: machine.status == MaintenanceStatus.urgent
                        ? statusColor
                        : statusColor.withOpacity(0.3),
                    width: machine.status == MaintenanceStatus.urgent ? 3 : 2,
                  ),
                  boxShadow: machine.status == MaintenanceStatus.urgent
                      ? [
                          BoxShadow(
                            color: statusColor.withOpacity(0.3),
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
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            machine.icon,
                            style: const TextStyle(fontSize: 32),
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                machine.type,
                                style: TextStyle(
                                  color: AppTheme.accentColor,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: machine.condition / 100,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                color: statusColor,
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
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
                                _getStatusLabel(machine.status),
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                                  timeUntil,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                .animate(
                                  onPlay: (controller) => controller.repeat(),
                                )
                                .shimmer(
                                  duration: 2000.ms,
                                  color: statusColor.withOpacity(0.3),
                                ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Condition: ${machine.condition.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Next: ${_formatDate(machine.nextMaintenance)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .animate(
                onPlay: (controller) =>
                    machine.status == MaintenanceStatus.urgent
                    ? controller.repeat()
                    : null,
              )
              .fadeIn(duration: 1000.ms)
              .then()
              .fadeOut(duration: 1000.ms),
    ).animate().fadeIn(delay: (200 + index * 100).ms).slideX(begin: 0.2, end: 0);
  }

  void _showMachineDetails(MachineMaintenanceInfo machine) {
    Get.dialog(
      Dialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(machine.icon, style: const TextStyle(fontSize: 40)),
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
                _buildDetailRow(
                  'Last Maintenance',
                  _formatDate(machine.lastMaintenance),
                ),
                _buildDetailRow(
                  'Next Maintenance',
                  _formatDate(machine.nextMaintenance),
                ),
                _buildDetailRow(
                  'Interval',
                  '${machine.maintenanceInterval} days',
                ),
                _buildDetailRow(
                  'Priority',
                  _getPriorityLabel(machine.priority),
                ),
                _buildDetailRow(
                  'Condition',
                  '${machine.condition.toStringAsFixed(0)}%',
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.back();
                          _controller.completeMaintenance(machine);
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Complete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.successColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.back();
                          _showReschedulePicker(machine);
                        },
                        icon: const Icon(Icons.calendar_month),
                        label: const Text('Reschedule'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ).animate().scale(duration: 300.ms, curve: Curves.easeOut),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showReschedulePicker(MachineMaintenanceInfo machine) {
    DateTime selectedDate = machine.nextMaintenance;

    Get.dialog(
      Dialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Reschedule Maintenance',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CalendarDatePicker(
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChanged: (date) {
                  selectedDate = date;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        _controller.scheduleMaintenance(machine, selectedDate);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                      ),
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(MaintenanceStatus status) {
    switch (status) {
      case MaintenanceStatus.ok:
        return AppTheme.successColor;
      case MaintenanceStatus.upcoming:
        return AppTheme.warningColor;
      case MaintenanceStatus.urgent:
        return AppTheme.errorColor;
    }
  }

  String _getStatusLabel(MaintenanceStatus status) {
    switch (status) {
      case MaintenanceStatus.ok:
        return 'OK';
      case MaintenanceStatus.upcoming:
        return 'UPCOMING';
      case MaintenanceStatus.urgent:
        return 'URGENT';
    }
  }

  String _getPriorityLabel(MaintenancePriority priority) {
    switch (priority) {
      case MaintenancePriority.low:
        return 'Low';
      case MaintenancePriority.normal:
        return 'Normal';
      case MaintenancePriority.high:
        return 'High';
      case MaintenancePriority.critical:
        return 'Critical';
    }
  }

  Color _getHeatmapColor(double intensity) {
    if (intensity < 0.3) return AppTheme.successColor;
    if (intensity < 0.6) return AppTheme.warningColor;
    if (intensity < 0.8) return Colors.orange;
    return AppTheme.errorColor;
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
