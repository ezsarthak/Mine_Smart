// filename: lib/presentation/widgets/energy_gauge.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

class EnergyGauge extends StatefulWidget {
  final double percentage;
  final double size;
  final bool isActive;

  const EnergyGauge({
    super.key,
    required this.percentage,
    this.size = 250,
    this.isActive = false,
  });

  @override
  State<EnergyGauge> createState() => _EnergyGaugeState();
}

class _EnergyGaugeState extends State<EnergyGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: widget.isActive
            ? [
                BoxShadow(
                  color: AppTheme.accentColor.withOpacity(0.5),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: AppTheme.successColor.withOpacity(0.3),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer metallic ring
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[800]!,
                  Colors.grey[700]!,
                  Colors.grey[600]!,
                  Colors.grey[700]!,
                ],
              ),
            ),
          ),
          // Inner background
          Container(
            width: widget.size - 20,
            height: widget.size - 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppTheme.backgroundColor, AppTheme.cardColor],
              ),
            ),
          ),
          // Animated gauge
          CustomPaint(
            size: Size(widget.size - 40, widget.size - 40),
            painter: GaugePainter(
              percentage: widget.percentage,
              isActive: widget.isActive,
            ),
          ),
          // Rotating glow effect when active
          if (widget.isActive)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animationController.value * 2 * math.pi,
                  child: Container(
                    width: widget.size - 30,
                    height: widget.size - 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          Colors.transparent,
                          AppTheme.accentColor.withOpacity(0.3),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                );
              },
            ),
          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                    '${widget.percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: widget.size * 0.15,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: widget.isActive
                              ? [AppTheme.accentColor, AppTheme.successColor]
                              : [Colors.white70, Colors.white38],
                        ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                    ),
                  )
                  .animate(
                    onPlay: (controller) =>
                        widget.isActive ? controller.repeat() : null,
                  )
                  .shimmer(
                    duration: 2000.ms,
                    color: AppTheme.accentColor.withOpacity(0.5),
                  ),
              const SizedBox(height: 8),
              Text(
                'Energy Saved',
                style: TextStyle(
                  fontSize: widget.size * 0.05,
                  color: widget.isActive
                      ? AppTheme.accentColor
                      : Colors.white54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Today',
                style: TextStyle(
                  fontSize: widget.size * 0.04,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double percentage;
  final bool isActive;

  GaugePainter({required this.percentage, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 25.0;

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi,
      false,
      bgPaint,
    );

    // Progress arc with gradient
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        colors: isActive
            ? [
                AppTheme.successColor,
                AppTheme.accentColor,
                AppTheme.primaryColor,
              ]
            : [Colors.grey[600]!, Colors.grey[500]!],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * (percentage / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Glow effect on progress arc when active
    if (isActive && percentage > 0) {
      final glowPaint = Paint()
        ..shader = SweepGradient(
          startAngle: -math.pi / 2,
          colors: [
            AppTheme.accentColor.withOpacity(0.3),
            AppTheme.successColor.withOpacity(0.3),
          ],
          transform: const GradientRotation(-math.pi / 2),
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 10
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(GaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.isActive != isActive;
  }
}
