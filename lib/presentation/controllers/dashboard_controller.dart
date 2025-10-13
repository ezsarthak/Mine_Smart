// filename: lib/presentation/controllers/dashboard_controller.dart
import 'package:get/get.dart';
import '../../data/models/sensor_reading_model.dart';
import '../../data/services/firestore_service.dart';
import 'sensor_controller.dart';

class DashboardController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final SensorController sensorController = Get.put(SensorController());

  final RxList<SensorReadingModel> recentReadings = <SensorReadingModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRecentReadings();
    _listenToReadings();
  }

  void _loadRecentReadings() async {
    try {
      isLoading.value = true;
      final readings = await _firestoreService.getRecentSensorReadings(
        limit: 20,
      );
      recentReadings.value = readings;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load readings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _listenToReadings() {
    _firestoreService.getSensorReadingsStream(limit: 20).listen((readings) {
      recentReadings.value = readings;
    });
  }

  void refresh() {
    _loadRecentReadings();
  }

  List<double> getTemperatureTrend() {
    return recentReadings
        .take(10)
        .map((r) => r.temperature)
        .toList()
        .reversed
        .toList();
  }

  List<double> getVibrationTrend() {
    return recentReadings
        .take(10)
        .map((r) => r.vibration)
        .toList()
        .reversed
        .toList();
  }

  List<double> getEnergyTrend() {
    return recentReadings
        .take(10)
        .map((r) => r.energy)
        .toList()
        .reversed
        .toList();
  }
}
