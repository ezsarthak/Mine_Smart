// filename: lib/data/services/predictive_maintenance_service.dart
import 'dart:math';
import 'package:get/get.dart';
import '../models/equipment_model.dart';
import '../models/sensor_reading_model.dart';
import '../../core/constants/app_constants.dart';

class PredictiveMaintenanceService extends GetxService {
  final Random _random = Random();

  List<EquipmentModel> generateEquipmentData(
    List<SensorReadingModel> recentReadings,
  ) {
    final equipmentList = [
      'Excavator Unit A',
      'Crusher Machine B',
      'Conveyor Belt C',
      'Drilling Rig D',
      'Haul Truck E',
    ];

    return equipmentList.asMap().entries.map((entry) {
      final index = entry.key;
      final name = entry.value;

      // Get average readings from recent data
      final avgVibration = recentReadings.isNotEmpty
          ? recentReadings
                    .take(5)
                    .map((r) => r.vibration)
                    .reduce((a, b) => a + b) /
                5
          : _random.nextDouble() * 10;

      final avgTemperature = recentReadings.isNotEmpty
          ? recentReadings
                    .take(5)
                    .map((r) => r.temperature)
                    .reduce((a, b) => a + b) /
                5
          : 20 + _random.nextDouble() * 65;

      final avgEnergy = recentReadings.isNotEmpty
          ? recentReadings
                    .take(5)
                    .map((r) => r.energy)
                    .reduce((a, b) => a + b) /
                5
          : 50 + _random.nextDouble() * 450;

      // Determine status based on thresholds
      final status = _predictStatus(avgVibration, avgTemperature);

      // Calculate maintenance dates
      final lastMaintenance = DateTime.now().subtract(
        Duration(days: 15 + index * 10),
      );
      final daysUntilService = _calculateDaysUntilService(
        status,
        avgVibration,
        avgTemperature,
      );
      final predictedNextService = DateTime.now().add(
        Duration(days: daysUntilService),
      );

      return EquipmentModel(
        id: 'eq_$index',
        name: name,
        type: _getEquipmentType(name),
        lastMaintenance: lastMaintenance,
        predictedNextService: predictedNextService,
        status: status,
        currentVibration: avgVibration,
        currentTemperature: avgTemperature,
        avgEnergyConsumption: avgEnergy,
      );
    }).toList();
  }

  String _predictStatus(double vibration, double temperature) {
    // Critical: Both metrics are in danger zone
    if (vibration >= AppConstants.vibrationCriticalThreshold ||
        temperature >= AppConstants.tempCriticalThreshold) {
      return 'critical';
    }

    // At Risk: One or both metrics approaching threshold
    if (vibration >= AppConstants.vibrationWarningThreshold ||
        temperature >= AppConstants.tempWarningThreshold) {
      return 'at_risk';
    }

    return 'healthy';
  }

  int _calculateDaysUntilService(
    String status,
    double vibration,
    double temperature,
  ) {
    switch (status) {
      case 'critical':
        return 1 + _random.nextInt(3); // 1-3 days
      case 'at_risk':
        return 5 + _random.nextInt(10); // 5-14 days
      default:
        return 20 + _random.nextInt(40); // 20-60 days
    }
  }

  String _getEquipmentType(String name) {
    if (name.contains('Excavator')) return 'Heavy Machinery';
    if (name.contains('Crusher')) return 'Processing';
    if (name.contains('Conveyor')) return 'Transport';
    if (name.contains('Drilling')) return 'Drilling';
    if (name.contains('Truck')) return 'Transport';
    return 'General';
  }

  bool requiresImmediateMaintenance(EquipmentModel equipment) {
    return equipment.status == 'critical' ||
        (equipment.status == 'at_risk' &&
            equipment.predictedNextService.difference(DateTime.now()).inDays <=
                3);
  }

  String getMaintenanceRecommendation(EquipmentModel equipment) {
    if (equipment.status == 'critical') {
      return 'URGENT: Schedule maintenance immediately. High vibration or temperature detected.';
    } else if (equipment.status == 'at_risk') {
      return 'CAUTION: Monitor closely. Readings approaching threshold levels.';
    }
    return 'Equipment operating normally. Continue regular monitoring.';
  }
}
