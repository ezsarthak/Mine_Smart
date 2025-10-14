// filename: lib/presentation/controllers/maintenance_controller.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaintenanceController extends GetxController {
  final Random _random = Random();
  Timer? _countdownTimer;

  // Machine list
  final RxList<MachineMaintenanceInfo> machines =
      <MachineMaintenanceInfo>[].obs;

  // Calendar data
  final RxMap<DateTime, MaintenanceStatus> maintenanceCalendar =
      <DateTime, MaintenanceStatus>{}.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime> focusedMonth = DateTime.now().obs;

  // Statistics
  final RxInt totalMachines = 0.obs;
  final RxInt upcomingMaintenance = 0.obs;
  final RxInt urgentMaintenance = 0.obs;
  final RxInt completedThisMonth = 0.obs;

  // Heatmap data
  final RxList<HeatmapData> heatmapData = <HeatmapData>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeMachines();
    _generateCalendarData();
    _generateHeatmapData();
    _startCountdownTimer();
    _updateStatistics();
  }

  void _initializeMachines() {
    machines.value = [
      MachineMaintenanceInfo(
        id: '1',
        name: 'Crusher Unit A',
        type: 'Crusher',
        icon: '⚙️',
        lastMaintenance: DateTime.now().subtract(const Duration(days: 25)),
        nextMaintenance: DateTime.now().add(const Duration(days: 5)),
        maintenanceInterval: 30,
        priority: MaintenancePriority.high,
        status: MaintenanceStatus.upcoming,
        condition: 85,
      ),
      MachineMaintenanceInfo(
        id: '2',
        name: 'Mill Unit B',
        type: 'Mill',
        icon: '🔄',
        lastMaintenance: DateTime.now().subtract(const Duration(days: 44)),
        nextMaintenance: DateTime.now().add(const Duration(days: 1)),
        maintenanceInterval: 45,
        priority: MaintenancePriority.critical,
        status: MaintenanceStatus.urgent,
        condition: 62,
      ),
      MachineMaintenanceInfo(
        id: '3',
        name: 'Conveyor Belt C',
        type: 'Conveyor',
        icon: '↔️',
        lastMaintenance: DateTime.now().subtract(const Duration(days: 10)),
        nextMaintenance: DateTime.now().add(const Duration(days: 20)),
        maintenanceInterval: 30,
        priority: MaintenancePriority.normal,
        status: MaintenanceStatus.ok,
        condition: 92,
      ),
      MachineMaintenanceInfo(
        id: '4',
        name: 'Pump System D',
        type: 'Pump',
        icon: '💧',
        lastMaintenance: DateTime.now().subtract(const Duration(days: 35)),
        nextMaintenance: DateTime.now().add(const Duration(days: 10)),
        maintenanceInterval: 45,
        priority: MaintenancePriority.normal,
        status: MaintenanceStatus.upcoming,
        condition: 78,
      ),
      MachineMaintenanceInfo(
        id: '5',
        name: 'Separator E',
        type: 'Separator',
        icon: '🔬',
        lastMaintenance: DateTime.now().subtract(const Duration(days: 58)),
        nextMaintenance: DateTime.now().add(const Duration(days: 2)),
        maintenanceInterval: 60,
        priority: MaintenancePriority.high,
        status: MaintenanceStatus.urgent,
        condition: 68,
      ),
      MachineMaintenanceInfo(
        id: '6',
        name: 'Drilling Rig F',
        type: 'Drilling',
        icon: '🔧',
        lastMaintenance: DateTime.now().subtract(const Duration(days: 5)),
        nextMaintenance: DateTime.now().add(const Duration(days: 25)),
        maintenanceInterval: 30,
        priority: MaintenancePriority.low,
        status: MaintenanceStatus.ok,
        condition: 95,
      ),
    ];

    totalMachines.value = machines.length;
  }

  void _generateCalendarData() {
    maintenanceCalendar.clear();

    // Add maintenance dates for all machines
    for (var machine in machines) {
      final date = DateTime(
        machine.nextMaintenance.year,
        machine.nextMaintenance.month,
        machine.nextMaintenance.day,
      );

      if (!maintenanceCalendar.containsKey(date)) {
        maintenanceCalendar[date] = machine.status;
      } else {
        // If multiple maintenances, use the most critical status
        if (machine.status == MaintenanceStatus.urgent) {
          maintenanceCalendar[date] = MaintenanceStatus.urgent;
        } else if (machine.status == MaintenanceStatus.upcoming &&
            maintenanceCalendar[date] != MaintenanceStatus.urgent) {
          maintenanceCalendar[date] = MaintenanceStatus.upcoming;
        }
      }
    }
  }

  void _generateHeatmapData() {
    heatmapData.clear();

    final now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      final month = DateTime(now.year, i + 1);
      final maintenanceCount = _random.nextInt(15) + 5;
      heatmapData.add(
        HeatmapData(
          month: month,
          count: maintenanceCount,
          completed: _random.nextInt(maintenanceCount),
        ),
      );
    }
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Trigger UI updates for countdown
      machines.refresh();
    });
  }

  void _updateStatistics() {
    upcomingMaintenance.value = machines
        .where((m) => m.status == MaintenanceStatus.upcoming)
        .length;
    urgentMaintenance.value = machines
        .where((m) => m.status == MaintenanceStatus.urgent)
        .length;
    completedThisMonth.value = _random.nextInt(8) + 3;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void changeMonth(int monthOffset) {
    focusedMonth.value = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month + monthOffset,
    );
  }

  List<MachineMaintenanceInfo> getMachinesForDate(DateTime date) {
    return machines.where((machine) {
      final maintenanceDate = DateTime(
        machine.nextMaintenance.year,
        machine.nextMaintenance.month,
        machine.nextMaintenance.day,
      );
      final selectedDay = DateTime(date.year, date.month, date.day);
      return maintenanceDate.isAtSameMomentAs(selectedDay);
    }).toList();
  }

  String getTimeUntilMaintenance(MachineMaintenanceInfo machine) {
    final now = DateTime.now();
    final difference = machine.nextMaintenance.difference(now);

    if (difference.isNegative) {
      return 'OVERDUE';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours % 24}h';
    }

    if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m';
    }

    return '${difference.inMinutes}m ${difference.inSeconds % 60}s';
  }

  void scheduleMaintenance(MachineMaintenanceInfo machine, DateTime date) {
    final index = machines.indexWhere((m) => m.id == machine.id);
    if (index != -1) {
      machines[index] = machine.copyWith(
        nextMaintenance: date,
        status: _getMaintenanceStatus(date),
      );
      _generateCalendarData();
      _updateStatistics();

      Get.snackbar(
        'Maintenance Scheduled',
        'Maintenance for ${machine.name} scheduled for ${_formatDate(date)}',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void completeMaintenance(MachineMaintenanceInfo machine) {
    final index = machines.indexWhere((m) => m.id == machine.id);
    if (index != -1) {
      final now = DateTime.now();
      final nextDate = now.add(Duration(days: machine.maintenanceInterval));

      machines[index] = machine.copyWith(
        lastMaintenance: now,
        nextMaintenance: nextDate,
        status: MaintenanceStatus.ok,
        condition: 100,
      );
      _generateCalendarData();
      _updateStatistics();
      completedThisMonth.value++;

      Get.snackbar(
        'Maintenance Completed',
        '${machine.name} maintenance marked as complete',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  MaintenanceStatus _getMaintenanceStatus(DateTime maintenanceDate) {
    final now = DateTime.now();
    final daysUntil = maintenanceDate.difference(now).inDays;

    if (daysUntil <= 2) {
      return MaintenanceStatus.urgent;
    } else if (daysUntil <= 7) {
      return MaintenanceStatus.upcoming;
    }
    return MaintenanceStatus.ok;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }
}

enum MaintenanceStatus { ok, upcoming, urgent }

enum MaintenancePriority { low, normal, high, critical }

class MachineMaintenanceInfo {
  final String id;
  final String name;
  final String type;
  final String icon;
  final DateTime lastMaintenance;
  final DateTime nextMaintenance;
  final int maintenanceInterval;
  final MaintenancePriority priority;
  final MaintenanceStatus status;
  final double condition;

  MachineMaintenanceInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.lastMaintenance,
    required this.nextMaintenance,
    required this.maintenanceInterval,
    required this.priority,
    required this.status,
    required this.condition,
  });

  MachineMaintenanceInfo copyWith({
    String? id,
    String? name,
    String? type,
    String? icon,
    DateTime? lastMaintenance,
    DateTime? nextMaintenance,
    int? maintenanceInterval,
    MaintenancePriority? priority,
    MaintenanceStatus? status,
    double? condition,
  }) {
    return MachineMaintenanceInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      lastMaintenance: lastMaintenance ?? this.lastMaintenance,
      nextMaintenance: nextMaintenance ?? this.nextMaintenance,
      maintenanceInterval: maintenanceInterval ?? this.maintenanceInterval,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      condition: condition ?? this.condition,
    );
  }
}

class HeatmapData {
  final DateTime month;
  final int count;
  final int completed;

  HeatmapData({
    required this.month,
    required this.count,
    required this.completed,
  });
}
