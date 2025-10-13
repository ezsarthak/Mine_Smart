// filename: lib/data/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/sensor_reading_model.dart';
import '../../core/constants/app_constants.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set(user.toJson());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();

    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> saveSensorReading(SensorReadingModel reading) async {
    await _firestore
        .collection(AppConstants.sensorsCollection)
        .add(reading.toJson());
  }

  Stream<List<SensorReadingModel>> getSensorReadingsStream({int limit = 20}) {
    return _firestore
        .collection(AppConstants.sensorsCollection)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return SensorReadingModel.fromJson(data);
          }).toList();
        });
  }

  Future<List<SensorReadingModel>> getRecentSensorReadings({
    int limit = 10,
  }) async {
    final snapshot = await _firestore
        .collection(AppConstants.sensorsCollection)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return SensorReadingModel.fromJson(data);
    }).toList();
  }
}
