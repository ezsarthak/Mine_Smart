// filename: lib/presentation/controllers/sensor_controller.dart
import 'package:get/get.dart';
import '../../data/models/sensor_reading_model.dart';
import '../../data/services/sensor_service.dart';

class SensorController extends GetxController {
  final SensorService _sensorService = Get.put(SensorService());

  Rx<SensorReadingModel?> get currentReading => _sensorService.currentReading;

  @override
  void onInit() {
    super.onInit();
    _sensorService.startSensorSimulation();
  }

  @override
  void onClose() {
    _sensorService.stopSensorSimulation();
    super.onClose();
  }
}
