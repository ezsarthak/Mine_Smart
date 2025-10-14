// filename: lib/presentation/pages/splash/splash_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToMain();
  }

  void _navigateToMain() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.MAIN);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.backgroundColor,
              AppTheme.primaryColor.withOpacity(0.2),
              AppTheme.backgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppTheme.accentColor, AppTheme.primaryColor],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentColor.withOpacity(0.5),
                          blurRadius: 40,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.diamond,
                      color: Colors.white,
                      size: 80,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(delay: 200.ms, duration: 600.ms)
                  .then()
                  .shimmer(
                    duration: 1500.ms,
                    color: Colors.white.withOpacity(0.3),
                  ),
              const SizedBox(height: 40),
              Text(
                'MineOpt AI',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [AppTheme.accentColor, Colors.white],
                    ).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
              const SizedBox(height: 12),
              Text(
                'Smart Mining Intelligence Platform',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.accentColor.withOpacity(0.8),
                  letterSpacing: 1.2,
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0),
              const SizedBox(height: 60),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.accentColor,
                  ),
                  minHeight: 3,
                ),
              ).animate().fadeIn(delay: 800.ms),
              const SizedBox(height: 20),
              Text(
                    'Initializing AI Systems...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .fadeIn(duration: 1000.ms)
                  .then()
                  .fadeOut(duration: 1000.ms),
            ],
          ),
        ),
      ),
    );
  }
}
