// filename: lib/presentation/controllers/predictive_maintenance_controller.dart
import 'package:get/get.dart';
import '../../data/models/equipment_model.dart';
import '../../data/models/sensor_reading_model.dart';
import '../../data/services/firestore_service.dart';
import '../../data/services/predictive_maintenance_service.dart';
import 'dashboard_controller.dart';

class PredictiveMaintenanceController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final PredictiveMaintenanceService _predictiveService = Get.put(
    PredictiveMaintenanceService(),
  );
  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  final RxList<EquipmentModel> equipmentList = <EquipmentModel>[].obs;
  final RxList<SensorReadingModel> historicalData = <SensorReadingModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedEquipmentId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
    _listenToSensorUpdates();
  }

  void _loadData() async {
    try {
      isLoading.value = true;

      // Get recent sensor readings
      final readings = await _firestoreService.getRecentSensorReadings(
        limit: 50,
      );
      historicalData.value = readings;

      // Generate equipment data based on readings
      equipmentList.value = _predictiveService.generateEquipmentData(readings);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load maintenance data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _listenToSensorUpdates() {
    // Update equipment status whenever sensor data changes
    ever(_dashboardController.recentReadings, (readings) {
      if (readings.isNotEmpty) {
        historicalData.value = readings;
        equipmentList.value = _predictiveService.generateEquipmentData(
          readings,
        );
      }
    });
  }

  void selectEquipment(String equipmentId) {
    selectedEquipmentId.value = equipmentId;
  }

  EquipmentModel? getSelectedEquipment() {
    if (selectedEquipmentId.value.isEmpty) return null;
    return equipmentList.firstWhereOrNull(
      (e) => e.id == selectedEquipmentId.value,
    );
  }

  List<EquipmentModel> getCriticalEquipment() {
    return equipmentList.where((e) => e.status == 'critical').toList();
  }

  List<EquipmentModel> getAtRiskEquipment() {
    return equipmentList.where((e) => e.status == 'at_risk').toList();
  }

  List<EquipmentModel> getHealthyEquipment() {
    return equipmentList.where((e) => e.status == 'healthy').toList();
  }

  int getTotalMaintenanceRequired() {
    return equipmentList
        .where((e) => _predictiveService.requiresImmediateMaintenance(e))
        .length;
  }

  List<double> getVibrationTrend() {
    return historicalData
        .take(20)
        .map((r) => r.vibration)
        .toList()
        .reversed
        .toList();
  }

  List<double> getTemperatureTrend() {
    return historicalData
        .take(20)
        .map((r) => r.temperature)
        .toList()
        .reversed
        .toList();
  }

  List<double> getEnergyTrend() {
    return historicalData
        .take(20)
        .map((r) => r.energy)
        .toList()
        .reversed
        .toList();
  }

  void refresh() {
    _loadData();
  }
}
