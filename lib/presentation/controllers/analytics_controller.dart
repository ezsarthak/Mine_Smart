// filename: lib/presentation/controllers/analytics_controller.dart
import 'package:get/get.dart';
import '../../data/services/analytics_service.dart';

class AnalyticsController extends GetxController {
  final AnalyticsService _analyticsService = Get.put(AnalyticsService());

  final RxString selectedPeriod = 'week'.obs;
  final RxMap<String, dynamic> energyTrends = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> alertAnalytics = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> maintenanceAnalytics = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> hourlyData = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAnalytics();
  }

  void loadAnalytics() async {
    try {
      isLoading.value = true;

      // Load all analytics data
      energyTrends.value = await _analyticsService.getEnergyConsumptionTrends(
        selectedPeriod.value,
      );
      alertAnalytics.value = await _analyticsService.getAlertAnalytics();
      maintenanceAnalytics.value = await _analyticsService
          .getMaintenanceAnalytics();
      hourlyData.value = await _analyticsService.getHourlyEnergyData();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load analytics: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    loadAnalytics();
  }

  void refresh() {
    loadAnalytics();
  }
}
