// filename: lib/data/services/analytics_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/sensor_reading_model.dart';
import '../models/alert_model.dart';

class AnalyticsService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getEnergyConsumptionTrends(String period) async {
    DateTime startDate;

    switch (period) {
      case 'day':
        startDate = DateTime.now().subtract(const Duration(days: 1));
        break;
      case 'week':
        startDate = DateTime.now().subtract(const Duration(days: 7));
        break;
      case 'month':
        startDate = DateTime.now().subtract(const Duration(days: 30));
        break;
      default:
        startDate = DateTime.now().subtract(const Duration(days: 7));
    }

    final snapshot = await _firestore
        .collection('sensor_readings')
        .where('timestamp', isGreaterThan: startDate.toIso8601String())
        .orderBy('timestamp')
        .get();

    final readings = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return SensorReadingModel.fromJson(data);
    }).toList();

    // Calculate analytics
    final energyData = readings.map((r) => r.energy).toList();
    final tempData = readings.map((r) => r.temperature).toList();
    final vibrationData = readings.map((r) => r.vibration).toList();

    return {
      'readings': readings,
      'avgEnergy': energyData.isEmpty
          ? 0
          : energyData.reduce((a, b) => a + b) / energyData.length,
      'maxEnergy': energyData.isEmpty
          ? 0
          : energyData.reduce((a, b) => a > b ? a : b),
      'minEnergy': energyData.isEmpty
          ? 0
          : energyData.reduce((a, b) => a < b ? a : b),
      'avgTemp': tempData.isEmpty
          ? 0
          : tempData.reduce((a, b) => a + b) / tempData.length,
      'avgVibration': vibrationData.isEmpty
          ? 0
          : vibrationData.reduce((a, b) => a + b) / vibrationData.length,
      'totalReadings': readings.length,
    };
  }

  Future<Map<String, dynamic>> getAlertAnalytics() async {
    final snapshot = await _firestore
        .collection('alerts')
        .orderBy('timestamp', descending: true)
        .limit(100)
        .get();

    final alerts = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return AlertModel.fromJson(data);
    }).toList();

    final totalAlerts = alerts.length;
    final criticalAlerts = alerts.where((a) => a.severity == 'critical').length;
    final warningAlerts = alerts.where((a) => a.severity == 'warning').length;
    final resolvedAlerts = alerts.where((a) => a.resolved).length;

    // Count by type
    final tempAlerts = alerts.where((a) => a.type == 'temperature').length;
    final vibrationAlerts = alerts.where((a) => a.type == 'vibration').length;
    final energyAlerts = alerts.where((a) => a.type == 'energy').length;

    return {
      'total': totalAlerts,
      'critical': criticalAlerts,
      'warning': warningAlerts,
      'resolved': resolvedAlerts,
      'unresolved': totalAlerts - resolvedAlerts,
      'byType': {
        'temperature': tempAlerts,
        'vibration': vibrationAlerts,
        'energy': energyAlerts,
      },
      'alerts': alerts,
    };
  }

  Future<Map<String, dynamic>> getMaintenanceAnalytics() async {
    // Since we don't have a maintenance collection, we'll derive from alerts
    final alertAnalytics = await getAlertAnalytics();
    final alerts = alertAnalytics['alerts'] as List<AlertModel>;

    final last7Days = DateTime.now().subtract(const Duration(days: 7));
    final recentAlerts = alerts
        .where((a) => a.timestamp.isAfter(last7Days))
        .length;

    return {
      'totalMaintenanceAlerts': alertAnalytics['total'],
      'recentAlerts': recentAlerts,
      'resolvedPercentage': alertAnalytics['total'] > 0
          ? (alertAnalytics['resolved'] / alertAnalytics['total'] * 100)
                .toStringAsFixed(1)
          : '0',
      'criticalCount': alertAnalytics['critical'],
    };
  }

  Future<List<Map<String, dynamic>>> getHourlyEnergyData() async {
    final yesterday = DateTime.now().subtract(const Duration(hours: 24));

    final snapshot = await _firestore
        .collection('sensor_readings')
        .where('timestamp', isGreaterThan: yesterday.toIso8601String())
        .orderBy('timestamp')
        .get();

    final readings = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return SensorReadingModel.fromJson(data);
    }).toList();

    // Group by hour
    final hourlyData = <int, List<double>>{};

    for (var reading in readings) {
      final hour = reading.timestamp.hour;
      if (!hourlyData.containsKey(hour)) {
        hourlyData[hour] = [];
      }
      hourlyData[hour]!.add(reading.energy);
    }

    // Calculate averages
    final result = <Map<String, dynamic>>[];
    for (var hour in hourlyData.keys) {
      final values = hourlyData[hour]!;
      final avg = values.reduce((a, b) => a + b) / values.length;
      result.add({'hour': hour, 'value': avg});
    }

    result.sort((a, b) => a['hour'].compareTo(b['hour']));
    return result;
  }
}
