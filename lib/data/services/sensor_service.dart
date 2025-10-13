// filename: lib/data/services/sensor_service.dart
import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../models/sensor_reading_model.dart';
import '../../core/constants/app_constants.dart';
import 'firestore_service.dart';
import 'alert_service.dart';

class SensorService extends GetxService {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final AlertService _alertService = Get.put(AlertService());
  final Random _random = Random();
  Timer? _timer;

  final Rx<SensorReadingModel?> currentReading = Rx<SensorReadingModel?>(null);

  void startSensorSimulation() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: AppConstants.sensorUpdateInterval),
      (_) => _generateAndSaveReading(),
    );
    _generateAndSaveReading();
  }

  void stopSensorSimulation() {
    _timer?.cancel();
  }

  void _generateAndSaveReading() async {
    final reading = _generateFakeReading();
    currentReading.value = reading;
    await _firestoreService.saveSensorReading(reading);

    // Check and create alerts if thresholds are crossed
    await _alertService.checkAndCreateAlert(reading);
  }

  SensorReadingModel _generateFakeReading() {
    final temperature = _randomInRange(
      AppConstants.minTemperature,
      AppConstants.maxTemperature,
    );
    final vibration = _randomInRange(
      AppConstants.minVibration,
      AppConstants.maxVibration,
    );
    final energy = _randomInRange(
      AppConstants.minEnergy,
      AppConstants.maxEnergy,
    );

    final status = _determineStatus(temperature, vibration, energy);

    return SensorReadingModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      temperature: temperature,
      vibration: vibration,
      energy: energy,
      timestamp: DateTime.now(),
      status: status,
    );
  }

  double _randomInRange(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  String _determineStatus(double temp, double vib, double energy) {
    if (temp >= AppConstants.tempCriticalThreshold ||
        vib >= AppConstants.vibrationCriticalThreshold ||
        energy >= AppConstants.energyCriticalThreshold) {
      return 'critical';
    } else if (temp >= AppConstants.tempWarningThreshold ||
        vib >= AppConstants.vibrationWarningThreshold ||
        energy >= AppConstants.energyWarningThreshold) {
      return 'warning';
    }
    return 'normal';
  }

  @override
  void onClose() {
    stopSensorSimulation();
    super.onClose();
  }
}
