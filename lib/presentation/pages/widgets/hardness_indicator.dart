// filename: lib/presentation/widgets/hardness_indicator.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/ore_hardness_controller.dart';

class HardnessIndicator extends StatefulWidget {
  final double hardness;
  final HardnessLevel level;
  final double size;

  const HardnessIndicator({
    super.key,
    required this.hardness,
    required this.level,
    this.size = 200,
  });

  @override
  State<HardnessIndicator> createState() => _HardnessIndicatorState();
}

class _HardnessIndicatorState extends State<HardnessIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getHardnessColor(widget.level);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating background gradient
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animationController.value * 2 * math.pi,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        Colors.transparent,
                        color.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Outer ring
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
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
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
          // Hardness gauge
          CustomPaint(
            size: Size(widget.size - 40, widget.size - 40),
            painter: HardnessGaugePainter(
              hardness: widget.hardness,
              color: color,
            ),
          ),
          // Floating icon
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final offset =
                  math.sin(_animationController.value * 2 * math.pi) * 10;
              return Transform.translate(
                offset: Offset(0, offset),
                child: Icon(
                  _getHardnessIcon(widget.level),
                  size: widget.size * 0.25,
                  color: color,
                ),
              );
            },
          ),
          // Value and label
          Positioned(
            bottom: widget.size * 0.15,
            child: Column(
              children: [
                Text(
                      widget.hardness.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: widget.size * 0.15,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader =
                              LinearGradient(
                                colors: [color, color.withOpacity(0.5)],
                              ).createShader(
                                Rect.fromLTWH(0, 0, widget.size, widget.size),
                              ),
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: 2000.ms, color: color.withOpacity(0.3)),
                const SizedBox(height: 4),
                Text(
                  _getHardnessLabel(widget.level),
                  style: TextStyle(
                    fontSize: widget.size * 0.06,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getHardnessColor(HardnessLevel level) {
    switch (level) {
      case HardnessLevel.soft:
        return const Color(0xFF4CAF50); // Green
      case HardnessLevel.medium:
        return const Color(0xFFFFC107); // Amber
      case HardnessLevel.hard:
        return const Color(0xFFF44336); // Red
    }
  }

  IconData _getHardnessIcon(HardnessLevel level) {
    switch (level) {
      case HardnessLevel.soft:
        return Icons.bubble_chart;
      case HardnessLevel.medium:
        return Icons.grain;
      case HardnessLevel.hard:
        return Icons.diamond;
    }
  }

  String _getHardnessLabel(HardnessLevel level) {
    switch (level) {
      case HardnessLevel.soft:
        return 'SOFT';
      case HardnessLevel.medium:
        return 'MEDIUM';
      case HardnessLevel.hard:
        return 'HARD';
    }
  }
}

class HardnessGaugePainter extends CustomPainter {
  final double hardness;
  final Color color;

  HardnessGaugePainter({required this.hardness, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 20.0;

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 1.5,
      false,
      bgPaint,
    );

    // Progress arc with gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -math.pi * 0.75,
      endAngle: math.pi * 0.75,
      colors: [
        const Color(0xFF4CAF50), // Soft - Green
        const Color(0xFFFFC107), // Medium - Amber
        const Color(0xFFF44336), // Hard - Red
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (hardness / 100) * (math.pi * 1.5);

    canvas.drawArc(rect, -math.pi * 0.75, sweepAngle, false, progressPaint);

    // Glow effect
    final glowPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 10
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawArc(rect, -math.pi * 0.75, sweepAngle, false, glowPaint);
  }

  @override
  bool shouldRepaint(HardnessGaugePainter oldDelegate) {
    return oldDelegate.hardness != hardness || oldDelegate.color != color;
  }
}
