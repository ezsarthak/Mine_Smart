// filename: lib/presentation/controllers/alert_controller.dart
import 'package:get/get.dart';
import '../../data/models/alert_model.dart';
import '../../data/services/alert_service.dart';
import '../../data/services/notification_service.dart';
import 'package:flutter/material.dart';

class AlertController extends GetxController {
  final AlertService _alertService = Get.put(AlertService());
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  final RxList<AlertModel> allAlerts = <AlertModel>[].obs;
  final RxList<AlertModel> unresolvedAlerts = <AlertModel>[].obs;
  final RxList<AlertModel> resolvedAlerts = <AlertModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt unresolvedCount = 0.obs;
  final RxString selectedFilter = 'all'.obs; // all, unresolved, resolved

  @override
  void onInit() {
    super.onInit();
    _loadAlerts();
    _listenToAlerts();
  }

  void _loadAlerts() async {
    try {
      isLoading.value = true;
      final alerts = await _alertService.getAlerts();
      allAlerts.value = alerts;
      _updateFilteredLists();
      unresolvedCount.value = await _alertService.getUnresolvedAlertsCount();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load alerts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _listenToAlerts() {
    _alertService.getAlertsStream().listen((alerts) {
      final previousUnresolved = unresolvedAlerts.length;
      allAlerts.value = alerts;
      _updateFilteredLists();

      // Check for new alerts and send notifications
      if (unresolvedAlerts.length > previousUnresolved) {
        final newAlerts = unresolvedAlerts.take(
          unresolvedAlerts.length - previousUnresolved,
        );
        for (var alert in newAlerts) {
          _notificationService.sendAlertNotification(alert);
        }
      }
    });
  }

  void _updateFilteredLists() {
    unresolvedAlerts.value = allAlerts.where((a) => !a.resolved).toList();
    resolvedAlerts.value = allAlerts.where((a) => a.resolved).toList();
    unresolvedCount.value = unresolvedAlerts.length;
  }

  List<AlertModel> get displayedAlerts {
    switch (selectedFilter.value) {
      case 'unresolved':
        return unresolvedAlerts;
      case 'resolved':
        return resolvedAlerts;
      default:
        return allAlerts;
    }
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  Future<void> resolveAlert(AlertModel alert) async {
    try {
      await _alertService.resolveAlert(alert.id);
      Get.snackbar(
        'Success',
        'Alert marked as resolved',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to resolve alert: $e');
    }
  }

  Future<void> deleteAlert(AlertModel alert) async {
    try {
      await _alertService.deleteAlert(alert.id);
      Get.snackbar(
        'Success',
        'Alert deleted',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete alert: $e');
    }
  }

  void refresh() {
    _loadAlerts();
  }
}
