// filename: lib/presentation/widgets/maintenance_calendar.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/maintenance_controller.dart';

class MaintenanceCalendar extends StatelessWidget {
  const MaintenanceCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MaintenanceController>();

    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.accentColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(controller),
            const SizedBox(height: 20),
            _buildWeekdayHeaders(),
            const SizedBox(height: 12),
            _buildCalendarGrid(controller),
            const SizedBox(height: 20),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(MaintenanceController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: AppTheme.accentColor),
          onPressed: () => controller.changeMonth(-1),
        ),
        Text(
          _getMonthYearString(controller.focusedMonth.value),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn().slideX(begin: 0.1, end: 0),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: AppTheme.accentColor),
          onPressed: () => controller.changeMonth(1),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid(MaintenanceController controller) {
    final month = controller.focusedMonth.value;
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday;

    List<Widget> dayWidgets = [];

    // Add empty cells for days before the month starts
    for (int i = 1; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      dayWidgets.add(_buildDayCell(controller, date, day));
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(
    MaintenanceController controller,
    DateTime date,
    int day,
  ) {
    final isToday = _isSameDay(date, DateTime.now());
    final isSelected = _isSameDay(date, controller.selectedDate.value);
    final status = controller.maintenanceCalendar[date];
    final machines = controller.getMachinesForDate(date);

    Color cellColor = AppTheme.cardColor;
    Color borderColor = Colors.transparent;

    if (status != null) {
      switch (status) {
        case MaintenanceStatus.ok:
          cellColor = AppTheme.successColor.withOpacity(0.2);
          borderColor = AppTheme.successColor;
          break;
        case MaintenanceStatus.upcoming:
          cellColor = AppTheme.warningColor.withOpacity(0.2);
          borderColor = AppTheme.warningColor;
          break;
        case MaintenanceStatus.urgent:
          cellColor = AppTheme.errorColor.withOpacity(0.2);
          borderColor = AppTheme.errorColor;
          break;
      }
    }

    if (isSelected) {
      borderColor = AppTheme.accentColor;
    }

    return GestureDetector(
      onTap: () {
        controller.selectDate(date);
        if (machines.isNotEmpty) {
          _showMaintenanceDetails(machines);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          boxShadow: status == MaintenanceStatus.urgent
              ? [
                  BoxShadow(
                    color: AppTheme.errorColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  color: isToday ? AppTheme.accentColor : Colors.white,
                  fontSize: 14,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (machines.isNotEmpty)
              Positioned(
                top: 4,
                right: 4,
                child:
                    Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: borderColor,
                            shape: BoxShape.circle,
                          ),
                        )
                        .animate(onPlay: (controller) => controller.repeat())
                        .fadeIn(duration: 1000.ms)
                        .then()
                        .fadeOut(duration: 1000.ms),
              ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(
      duration: const Duration(milliseconds: 200),
      begin: const Offset(0.95, 0.95),
      end: const Offset(1, 1),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('OK', AppTheme.successColor),
        _buildLegendItem('Upcoming', AppTheme.warningColor),
        _buildLegendItem('Urgent', AppTheme.errorColor),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getMonthYearString(DateTime date) {
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
    return '${months[date.month - 1]} ${date.year}';
  }

  void _showMaintenanceDetails(List<MachineMaintenanceInfo> machines) {
    Get.dialog(
      Dialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppTheme.accentColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Scheduled Maintenance',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...machines.map(
                (machine) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getStatusColor(machine.status).withOpacity(0.2),
                        AppTheme.backgroundColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(machine.status).withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(machine.icon, style: const TextStyle(fontSize: 32)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              machine.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            machine.status,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(machine.status),
                          ),
                        ),
                        child: Text(
                          _getStatusLabel(machine.status),
                          style: TextStyle(
                            color: _getStatusColor(machine.status),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
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
      ).animate().scale(duration: 300.ms, curve: Curves.easeOut),
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
}
