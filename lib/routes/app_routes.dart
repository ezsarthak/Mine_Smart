// filename: lib/routes/app_routes.dart
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import '../presentation/controllers/main_navigation_controller.dart';
import '../presentation/pages/ai_summary/ai_summary_page.dart';
import '../presentation/pages/anomaly/anomaly_detection_page.dart';
import '../presentation/pages/decision_hub/decision_hub_page.dart';
import '../presentation/pages/digital_twin/digital_twin_page.dart';
import '../presentation/pages/digital_twin/digital_twin_simulation_page.dart';
import '../presentation/pages/main_navigation/main_navigation_page.dart';
import '../presentation/pages/maintenance/maintenance_scheduler_page.dart';
import '../presentation/pages/notifications/notifications_page.dart';
import '../presentation/pages/ore_hardness/ore_hardness_page.dart';
import '../presentation/pages/safety/safety_dashboard_page.dart';
import '../presentation/pages/settings/settings_page.dart';
import '../presentation/pages/splash/splash_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/dashboard/dashboard_page.dart';
import '../presentation/pages/maintenance/predictive_maintenance_page.dart';
import '../presentation/pages/alerts/alerts_page.dart';
import '../presentation/pages/profile/profile_page.dart';
import '../presentation/pages/analytics/analytics_page.dart';
import '../presentation/pages/optimizer/smart_optimizer_page.dart';
import '../presentation/pages/sustainability/sustainability_page.dart';
import '../presentation/pages/workload/workload_balancer_page.dart';

class AppRoutes {
  // Main Navigation
  static const MAIN = '/main';
  static const SPLASH = '/';

  // Dashboard & Core
  static const DASHBOARD = '/dashboard';

  // Feature Modules
  static const SMART_OPTIMIZER = '/smart-optimizer';
  static const ANOMALY_DETECTION = '/anomaly-detection';
  static const SUSTAINABILITY = '/sustainability';
  static const DIGITAL_TWIN = '/digital-twin';
  static const MAINTENANCE = '/maintenance';
  static const WORKLOAD_BALANCER = '/workload-balancer';
  static const ORE_HARDNESS = '/ore-hardness';
  static const SAFETY_DASHBOARD = '/safety-dashboard';
  static const AI_SUMMARY = '/ai-summary';
  static const DECISION_HUB = '/decision-hub';

  // Additional Pages
  static const SETTINGS = '/settings';
  static const PROFILE = '/profile';
  static const NOTIFICATIONS = '/notifications';
  static const ANALYTICS = '/analytics';
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String predictiveMaintenance = '/predictive-maintenance';
  static const String digitalTwin = '/digital-twin';
  static const String alerts = '/alerts';
  static const String profile = '/profile';
  static const String analytics = '/analytics';
  static const String smartOptimizer = '/smart-optimizer';
  static const String anomalyDetection = '/anomaly-detection';
  static const String sustainability = '/sustainability';
  static const String digitalTwinSimulation = '/digital-twin-simulation';
  static const String maintenanceScheduler = '/maintenance-scheduler';
  static const String workloadBalancer = '/workload-balancer';
  static const String oreHardness = '/ore-hardness';
  static const String safetyDashboard = '/safety-dashboard';
  static const String aiSummary = '/ai-summary';

  static final routes = [
    // Splash Screen
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashPage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    // Main Navigation Shell
    GetPage(
      name: AppRoutes.MAIN,
      page: () => MainNavigationPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MainNavigationController());
      }),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Dashboard (Home)
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => DashboardPage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Smart Optimizer
    GetPage(
      name: AppRoutes.SMART_OPTIMIZER,
      page: () => SmartOptimizerPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // Anomaly Detection
    GetPage(
      name: AppRoutes.ANOMALY_DETECTION,
      page: () => AnomalyDetectionPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // Sustainability
    GetPage(
      name: AppRoutes.SUSTAINABILITY,
      page: () => SustainabilityPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // Digital Twin
    GetPage(
      name: AppRoutes.DIGITAL_TWIN,
      page: () => DigitalTwinSimulationPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // Maintenance Scheduler
    GetPage(
      name: AppRoutes.MAINTENANCE,
      page: () => MaintenanceSchedulerPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // Workload Balancer
    GetPage(
      name: AppRoutes.WORKLOAD_BALANCER,
      page: () => WorkloadBalancerPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // Ore Hardness
    GetPage(
      name: AppRoutes.ORE_HARDNESS,
      page: () => OreHardnessPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // Safety Dashboard
    GetPage(
      name: AppRoutes.SAFETY_DASHBOARD,
      page: () => SafetyDashboardPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // AI Summary
    GetPage(
      name: AppRoutes.AI_SUMMARY,
      page: () => AISummaryPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // Decision Hub
    GetPage(
      name: AppRoutes.DECISION_HUB,
      page: () => DecisionHubPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // Settings
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => SettingsPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // Profile
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => ProfilePage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // Notifications
    GetPage(
      name: AppRoutes.NOTIFICATIONS,
      page: () => NotificationsPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),

    // Analytics
    GetPage(
      name: AppRoutes.ANALYTICS,
      page: () => AnalyticsPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: splash,
      page: () => const SplashPage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: login,
      page: () => LoginPage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: register,
      page: () => RegisterPage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: dashboard,
      page: () => DashboardPage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: predictiveMaintenance,
      page: () => PredictiveMaintenancePage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: digitalTwin,
      page: () => DigitalTwinPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: alerts,
      page: () => AlertsPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: profile,
      page: () => ProfilePage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: analytics,
      page: () => AnalyticsPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: smartOptimizer,
      page: () => SmartOptimizerPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: anomalyDetection,
      page: () => AnomalyDetectionPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: sustainability,
      page: () => SustainabilityPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: digitalTwinSimulation,
      page: () => DigitalTwinSimulationPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: maintenanceScheduler,
      page: () => MaintenanceSchedulerPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: workloadBalancer,
      page: () => WorkloadBalancerPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: oreHardness,
      page: () => OreHardnessPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: safetyDashboard,
      page: () => SafetyDashboardPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: aiSummary,
      page: () => AISummaryPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}
