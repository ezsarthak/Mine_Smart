// filename: lib/data/services/alert_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/alert_model.dart';
import '../models/sensor_reading_model.dart';
import '../../core/constants/app_constants.dart';

class AlertService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String alertsCollection = 'alerts';

  Future<void> checkAndCreateAlert(SensorReadingModel reading) async {
    final alerts = <AlertModel>[];

    // Check temperature
    if (reading.temperature >= AppConstants.tempCriticalThreshold) {
      alerts.add(
        _createAlert(
          'Temperature Sensor',
          reading.temperature,
          'temperature',
          'critical',
          'Critical temperature level detected: ${reading.temperature.toStringAsFixed(1)}°C',
        ),
      );
    } else if (reading.temperature >= AppConstants.tempWarningThreshold) {
      alerts.add(
        _createAlert(
          'Temperature Sensor',
          reading.temperature,
          'temperature',
          'warning',
          'High temperature detected: ${reading.temperature.toStringAsFixed(1)}°C',
        ),
      );
    }

    // Check vibration
    if (reading.vibration >= AppConstants.vibrationCriticalThreshold) {
      alerts.add(
        _createAlert(
          'Vibration Sensor',
          reading.vibration,
          'vibration',
          'critical',
          'Critical vibration level detected: ${reading.vibration.toStringAsFixed(1)} mm/s',
        ),
      );
    } else if (reading.vibration >= AppConstants.vibrationWarningThreshold) {
      alerts.add(
        _createAlert(
          'Vibration Sensor',
          reading.vibration,
          'vibration',
          'warning',
          'High vibration detected: ${reading.vibration.toStringAsFixed(1)} mm/s',
        ),
      );
    }

    // Check energy
    if (reading.energy >= AppConstants.energyCriticalThreshold) {
      alerts.add(
        _createAlert(
          'Energy Monitor',
          reading.energy,
          'energy',
          'critical',
          'Critical energy consumption: ${reading.energy.toStringAsFixed(1)} kW',
        ),
      );
    } else if (reading.energy >= AppConstants.energyWarningThreshold) {
      alerts.add(
        _createAlert(
          'Energy Monitor',
          reading.energy,
          'energy',
          'warning',
          'High energy consumption: ${reading.energy.toStringAsFixed(1)} kW',
        ),
      );
    }

    // Save alerts to Firestore
    for (var alert in alerts) {
      await saveAlert(alert);
    }
  }

  AlertModel _createAlert(
    String sensorName,
    double value,
    String type,
    String severity,
    String message,
  ) {
    return AlertModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sensorName: sensorName,
      timestamp: DateTime.now(),
      value: value,
      type: type,
      severity: severity,
      resolved: false,
      message: message,
    );
  }

  Future<void> saveAlert(AlertModel alert) async {
    try {
      await _firestore.collection(alertsCollection).add(alert.toJson());
    } catch (e) {
      print('Error saving alert: $e');
    }
  }

  Stream<List<AlertModel>> getAlertsStream({bool? resolved}) {
    Query query = _firestore
        .collection(alertsCollection)
        .orderBy('timestamp', descending: true);

    if (resolved != null) {
      query = query.where('resolved', isEqualTo: resolved);
    }

    return query.limit(50).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return AlertModel.fromJson(data);
      }).toList();
    });
  }

  Future<List<AlertModel>> getAlerts({bool? resolved, int limit = 50}) async {
    Query query = _firestore
        .collection(alertsCollection)
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (resolved != null) {
      query = query.where('resolved', isEqualTo: resolved);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return AlertModel.fromJson(data);
    }).toList();
  }

  Future<void> resolveAlert(String alertId) async {
    try {
      await _firestore.collection(alertsCollection).doc(alertId).update({
        'resolved': true,
      });
    } catch (e) {
      print('Error resolving alert: $e');
    }
  }

  Future<void> deleteAlert(String alertId) async {
    try {
      await _firestore.collection(alertsCollection).doc(alertId).delete();
    } catch (e) {
      print('Error deleting alert: $e');
    }
  }

  Future<int> getUnresolvedAlertsCount() async {
    final snapshot = await _firestore
        .collection(alertsCollection)
        .where('resolved', isEqualTo: false)
        .get();
    return snapshot.docs.length;
  }
}
