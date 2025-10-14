// filename: lib/presentation/controllers/main_navigation_controller.dart

import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class MainNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxBool isDrawerOpen = false.obs;

  // Bottom navigation tabs
  final List<NavigationTab> tabs = [
    NavigationTab(
      label: 'Home',
      icon: 'assets/icons/home.svg',
      activeIcon: 'assets/icons/home_filled.svg',
      route: AppRoutes.DASHBOARD,
    ),
    NavigationTab(
      label: 'Operations',
      icon: 'assets/icons/operations.svg',
      activeIcon: 'assets/icons/operations_filled.svg',
      route: AppRoutes.SMART_OPTIMIZER,
    ),
    NavigationTab(
      label: 'Monitor',
      icon: 'assets/icons/monitor.svg',
      activeIcon: 'assets/icons/monitor_filled.svg',
      route: AppRoutes.ANOMALY_DETECTION,
    ),
    NavigationTab(
      label: 'Safety',
      icon: 'assets/icons/safety.svg',
      activeIcon: 'assets/icons/safety_filled.svg',
      route: AppRoutes.SAFETY_DASHBOARD,
    ),
    NavigationTab(
      label: 'Insights',
      icon: 'assets/icons/insights.svg',
      activeIcon: 'assets/icons/insights_filled.svg',
      route: AppRoutes.AI_SUMMARY,
    ),
  ];

  void changeTab(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
    }
  }

  void toggleDrawer() {
    isDrawerOpen.value = !isDrawerOpen.value;
  }

  String getCurrentRoute() {
    return tabs[currentIndex.value].route;
  }
}

class NavigationTab {
  final String label;
  final String icon;
  final String activeIcon;
  final String route;

  NavigationTab({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}
