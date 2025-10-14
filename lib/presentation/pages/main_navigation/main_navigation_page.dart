// filename: lib/presentation/pages/main_navigation/main_navigation_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../controllers/main_navigation_controller.dart';
import '../dashboard/dashboard_page.dart';
import '../optimizer/smart_optimizer_page.dart';
import '../anomaly/anomaly_detection_page.dart';
import '../safety/safety_dashboard_page.dart';
import '../ai_summary/ai_summary_page.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_routes.dart';

class MainNavigationPage extends GetView<MainNavigationController> {
  MainNavigationPage({super.key});

  final List<Widget> _pages = [
    DashboardPage(),
    SmartOptimizerPage(),
    AnomalyDetectionPage(),
    SafetyDashboardPage(),
    AISummaryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      drawer: _buildDrawer(context),
      body: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Container(
            key: ValueKey<int>(controller.currentIndex.value),
            child: _pages[controller.currentIndex.value],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.cardColor, AppTheme.cardColor.withOpacity(0.95)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                controller.tabs.length,
                (index) =>
                    _buildNavItem(context, index, controller.tabs[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, NavigationTab tab) {
    final isSelected = controller.currentIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppTheme.accentColor.withOpacity(0.3),
                    AppTheme.primaryColor.withOpacity(0.2),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(
                  color: AppTheme.accentColor.withOpacity(0.5),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    _getIconData(index),
                    color: isSelected ? AppTheme.accentColor : Colors.white54,
                    size: isSelected ? 28 : 24,
                  ),
                )
                .animate(target: isSelected ? 1 : 0)
                .scale(
                  duration: 300.ms,
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected ? AppTheme.accentColor : Colors.white54,
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              child: Text(tab.label),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(int index) {
    switch (index) {
      case 0:
        return Icons.dashboard_rounded;
      case 1:
        return Icons.settings_suggest_rounded;
      case 2:
        return Icons.radar_rounded;
      case 3:
        return Icons.security_rounded;
      case 4:
        return Icons.psychology_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.cardColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentColor.withOpacity(0.3),
                    AppTheme.primaryColor.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.accentColor,
                              AppTheme.primaryColor,
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentColor.withOpacity(0.5),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.diamond,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MineOpt AI',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Smart Mining Platform',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.accentColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.2, end: 0),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _buildDrawerSection(context, '🎯 Core Features', [
                    DrawerMenuItem(
                      icon: Icons.eco,
                      title: 'Sustainability',
                      subtitle: 'Carbon tracking',
                      route: AppRoutes.SUSTAINABILITY,
                    ),
                    DrawerMenuItem(
                      icon: Icons.device_hub,
                      title: 'Digital Twin',
                      subtitle: 'Simulation',
                      route: AppRoutes.DIGITAL_TWIN,
                    ),
                    DrawerMenuItem(
                      icon: Icons.build_circle,
                      title: 'Maintenance',
                      subtitle: 'Schedule',
                      route: AppRoutes.MAINTENANCE,
                    ),
                    DrawerMenuItem(
                      icon: Icons.balance,
                      title: 'Workload',
                      subtitle: 'Balancer',
                      route: AppRoutes.WORKLOAD_BALANCER,
                    ),
                    DrawerMenuItem(
                      icon: Icons.science,
                      title: 'Ore Hardness',
                      subtitle: 'AI prediction',
                      route: AppRoutes.ORE_HARDNESS,
                    ),
                  ]),
                  const Divider(color: Colors.white12, height: 32),
                  _buildDrawerSection(context, '⚙️ System', [
                    DrawerMenuItem(
                      icon: Icons.analytics,
                      title: 'Analytics',
                      subtitle: 'Reports',
                      route: AppRoutes.ANALYTICS,
                    ),
                    DrawerMenuItem(
                      icon: Icons.notifications_active,
                      title: 'Notifications',
                      subtitle: 'Alerts',
                      route: AppRoutes.NOTIFICATIONS,
                    ),
                    DrawerMenuItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      subtitle: 'Configuration',
                      route: AppRoutes.SETTINGS,
                    ),
                    DrawerMenuItem(
                      icon: Icons.person,
                      title: 'Profile',
                      subtitle: 'Account',
                      route: AppRoutes.PROFILE,
                    ),
                  ]),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.successColor.withOpacity(0.2),
                          AppTheme.accentColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.successColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                              Icons.auto_awesome,
                              color: AppTheme.successColor,
                              size: 20,
                            )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .rotate(duration: 3000.ms),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Active',
                                style: TextStyle(
                                  color: AppTheme.successColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'All systems optimal',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Version 1.0.0 • Build 2025',
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerSection(
    BuildContext context,
    String title,
    List<DrawerMenuItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              color: AppTheme.accentColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items.map((item) => _buildDrawerItem(context, item)),
      ],
    );
  }

  Widget _buildDrawerItem(BuildContext context, DrawerMenuItem item) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(item.icon, color: AppTheme.accentColor, size: 20),
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.white38,
        size: 20,
      ),
      onTap: () {
        Get.back(); // Close drawer
        Get.toNamed(item.route);
      },
    ).animate().fadeIn().slideX(begin: -0.1, end: 0);
  }
}

class DrawerMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}
