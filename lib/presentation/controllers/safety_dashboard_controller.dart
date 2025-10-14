// filename: lib/presentation/controllers/safety_dashboard_controller.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SafetyDashboardController extends GetxController {
  final Random _random = Random();
  Timer? _updateTimer;

  // Safety metrics
  final RxDouble safetyScore = 85.0.obs;
  final RxInt activeAlerts = 1.obs;
  final RxInt safeDays = 127.obs;
  final RxInt inspectionsToday = 8.obs;

  // Machines list
  final RxList<SafetyMachine> machines = <SafetyMachine>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeMachines();
    _startMonitoring();
  }

  void _initializeMachines() {
    machines.value = [
      SafetyMachine(
        id: '1',
        name: 'Crusher A',
        location: 'Section 1',
        status: 'operational',
        temperature: 65,
        icon: Icons.settings,
      ),
      SafetyMachine(
        id: '2',
        name: 'Crusher B',
        location: 'Section 2',
        status: 'warning',
        temperature: 85,
        icon: Icons.settings,
      ),
      SafetyMachine(
        id: '3',
        name: 'Mill Unit A',
        location: 'Section 3',
        status: 'operational',
        temperature: 58,
        icon: Icons.refresh,
      ),
      SafetyMachine(
        id: '4',
        name: 'Conveyor 1',
        location: 'Section 1',
        status: 'operational',
        temperature: 45,
        icon: Icons.compare_arrows,
      ),
      SafetyMachine(
        id: '5',
        name: 'Pump System',
        location: 'Section 4',
        status: 'operational',
        temperature: 52,
        icon: Icons.water_drop,
      ),
      SafetyMachine(
        id: '6',
        name: 'Separator',
        location: 'Section 3',
        status: 'operational',
        temperature: 48,
        icon: Icons.filter_alt,
      ),
    ];
  }

  void _startMonitoring() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _updateMetrics();
    });
  }

  void _updateMetrics() {
    // Random updates to simulate real-time monitoring
    safetyScore.value = (safetyScore.value + _random.nextDouble() * 4 - 2)
        .clamp(70.0, 95.0);

    // Randomly update machine temperatures
    for (var machine in machines) {
      machine.temperature = (machine.temperature + _random.nextDouble() * 6 - 3)
          .clamp(40, 90)
          .toInt();

      // Update status based on temperature
      if (machine.temperature > 80) {
        machine.status = 'critical';
      } else if (machine.temperature > 70) {
        machine.status = 'warning';
      } else {
        machine.status = 'operational';
      }
    }

    machines.refresh();
  }

  @override
  void onClose() {
    _updateTimer?.cancel();
    super.onClose();
  }
}

class SafetyMachine {
  final String id;
  final String name;
  final String location;
  String status;
  int temperature;
  final IconData icon;

  SafetyMachine({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.temperature,
    required this.icon,
  });
}
