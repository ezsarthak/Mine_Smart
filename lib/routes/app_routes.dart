// filename: lib/routes/app_routes.dart
import 'package:get/get.dart';
import '../presentation/pages/splash/splash_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/dashboard/dashboard_page.dart';
import '../presentation/pages/maintenance/predictive_maintenance_page.dart';
import '../presentation/pages/digital_twin/digital_twin_page.dart';
import '../presentation/pages/alerts/alerts_page.dart';
import '../presentation/pages/profile/profile_page.dart';
import '../presentation/pages/analytics/analytics_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String predictiveMaintenance = '/predictive-maintenance';
  static const String digitalTwin = '/digital-twin';
  static const String alerts = '/alerts';
  static const String profile = '/profile';
  static const String analytics = '/analytics';

  static final routes = [
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
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: digitalTwin,
      page: () => DigitalTwinPage(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: alerts,
      page: () => AlertsPage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: profile,
      page: () => ProfilePage(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: analytics,
      page: () => AnalyticsPage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}
