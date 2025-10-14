// filename: lib/presentation/pages/digital_twin/digital_twin_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_routes.dart';

class DigitalTwinPage extends StatelessWidget {
  const DigitalTwinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroSection(context),
                    const SizedBox(height: 32),
                    _buildFeatureGrid(context),
                    const SizedBox(height: 32),
                    _buildQuickStats(context),
                    const SizedBox(height: 32),
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: AppTheme.cardColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.accentColor),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.device_hub, color: AppTheme.accentColor, size: 24)
                    .animate(onPlay: (controller) => controller.repeat())
                    .rotate(duration: 3000.ms),
                const SizedBox(width: 8),
                Text(
                  'Digital Twin',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Virtual Plant Overview',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.accentColor),
            ),
          ],
        ),
        titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor.withOpacity(0.3),
            AppTheme.primaryColor.withOpacity(0.2),
            AppTheme.cardColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
                Icons.precision_manufacturing,
                size: 80,
                color: AppTheme.accentColor,
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                duration: 2000.ms,
                color: AppTheme.accentColor.withOpacity(0.5),
              ),
          const SizedBox(height: 20),
          Text(
            'Virtual Plant Replica',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Real-time simulation and predictive analytics for your mining operations',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.successColor,
                  AppTheme.successColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.successColor.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .fadeIn(duration: 1000.ms)
                    .then()
                    .fadeOut(duration: 1000.ms),
                const SizedBox(width: 8),
                const Text(
                  'SYSTEM ACTIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).scale();
  }

  Widget _buildFeatureGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Features',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildFeatureCard(
              'Real-Time Monitoring',
              Icons.monitor_heart,
              'Live equipment status',
              Colors.blue,
              0,
            ),
            _buildFeatureCard(
              'Predictive Analysis',
              Icons.psychology,
              'AI-powered forecasting',
              Colors.purple,
              1,
            ),
            _buildFeatureCard(
              'What-If Scenarios',
              Icons.science,
              'Test configurations',
              Colors.orange,
              2,
            ),
            _buildFeatureCard(
              'Performance Tuning',
              Icons.tune,
              'Optimize operations',
              Colors.green,
              3,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    String title,
    IconData icon,
    String description,
    Color color,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), AppTheme.cardColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (200 + index * 100).ms).scale();
  }

  Widget _buildQuickStats(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: AppTheme.accentColor, size: 24),
              const SizedBox(width: 12),
              Text(
                'Quick Stats',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Accuracy',
                  '98.5%',
                  Icons.verified,
                  AppTheme.successColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Simulations',
                  '1,247',
                  Icons.play_circle,
                  AppTheme.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Uptime',
                  '99.2%',
                  Icons.schedule,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Predictions',
                  '342',
                  Icons.insights,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: color.withOpacity(0.3)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child:
              ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(AppRoutes.DIGITAL_TWIN);
                    },
                    icon: const Icon(Icons.play_arrow, size: 28),
                    label: const Text(
                      'Launch Simulation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: AppTheme.accentColor.withOpacity(0.5),
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    duration: 1500.ms,
                    begin: const Offset(1, 1),
                    end: const Offset(1.05, 1.05),
                  )
                  .then()
                  .scale(
                    duration: 1500.ms,
                    begin: const Offset(1.05, 1.05),
                    end: const Offset(1, 1),
                  ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    'Historical Data',
                    'Viewing past simulations and predictions',
                    backgroundColor: AppTheme.cardColor,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  );
                },
                icon: const Icon(Icons.history, size: 20),
                label: const Text('History'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.accentColor,
                  side: BorderSide(color: AppTheme.accentColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    'Documentation',
                    'Opening user guide and tutorials',
                    backgroundColor: AppTheme.cardColor,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  );
                },
                icon: const Icon(Icons.help_outline, size: 20),
                label: const Text('Guide'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.accentColor,
                  side: BorderSide(color: AppTheme.accentColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
