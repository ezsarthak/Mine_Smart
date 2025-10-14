// filename: lib/presentation/widgets/animated_flow_arrow.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedFlowArrow extends StatefulWidget {
  final double flowRate;
  final double intensity;
  final bool isActive;
  final Color color;
  final bool isHorizontal;

  const AnimatedFlowArrow({
    super.key,
    required this.flowRate,
    required this.intensity,
    required this.isActive,
    required this.color,
    this.isHorizontal = true,
  });

  @override
  State<AnimatedFlowArrow> createState() => _AnimatedFlowArrowState();
}

class _AnimatedFlowArrowState extends State<AnimatedFlowArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (2000 / (widget.intensity + 0.5)).round(),
      ),
    )..repeat();
  }

  @override
  void didUpdateWidget(AnimatedFlowArrow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.intensity != widget.intensity) {
      _animationController.duration = Duration(
        milliseconds: (2000 / (widget.intensity + 0.5)).round(),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return Container(
        width: widget.isHorizontal ? 80 : 40,
        height: widget.isHorizontal ? 40 : 80,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: widget.isHorizontal ? _getArrowLength() : _getArrowWidth(),
      height: widget.isHorizontal ? _getArrowWidth() : _getArrowLength(),
      child: Stack(
        children: [
          // Background glow
          if (widget.intensity > 0.7)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(
                          0.3 * _animationController.value,
                        ),
                        blurRadius: 20 * _animationController.value,
                        spreadRadius: 10 * _animationController.value,
                      ),
                    ],
                  ),
                );
              },
            ),
          // Main arrow
          CustomPaint(
            painter: FlowArrowPainter(
              color: widget.color,
              intensity: widget.intensity,
              isHorizontal: widget.isHorizontal,
            ),
          ),
          // Animated particles
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: FlowParticlesPainter(
                  color: widget.color,
                  progress: _animationController.value,
                  intensity: widget.intensity,
                  isHorizontal: widget.isHorizontal,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  double _getArrowLength() {
    return 60 + (widget.intensity * 60);
  }

  double _getArrowWidth() {
    return 20 + (widget.intensity * 20);
  }
}

class FlowArrowPainter extends CustomPainter {
  final Color color;
  final double intensity;
  final bool isHorizontal;

  FlowArrowPainter({
    required this.color,
    required this.intensity,
    required this.isHorizontal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.3), color, color.withOpacity(0.3)],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isHorizontal) {
      // Horizontal arrow
      final bodyWidth = size.width * 0.7;
      final arrowWidth = size.width * 0.3;
      final height = size.height;

      path.moveTo(0, height * 0.3);
      path.lineTo(bodyWidth, height * 0.3);
      path.lineTo(bodyWidth, 0);
      path.lineTo(size.width, height / 2);
      path.lineTo(bodyWidth, height);
      path.lineTo(bodyWidth, height * 0.7);
      path.lineTo(0, height * 0.7);
      path.close();
    } else {
      // Vertical arrow
      final bodyHeight = size.height * 0.7;
      final arrowHeight = size.height * 0.3;
      final width = size.width;

      path.moveTo(width * 0.3, 0);
      path.lineTo(width * 0.3, bodyHeight);
      path.lineTo(0, bodyHeight);
      path.lineTo(width / 2, size.height);
      path.lineTo(width, bodyHeight);
      path.lineTo(width * 0.7, bodyHeight);
      path.lineTo(width * 0.7, 0);
      path.close();
    }

    canvas.drawPath(path, paint);

    // Draw outline
    final outlinePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(FlowArrowPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.intensity != intensity ||
        oldDelegate.isHorizontal != isHorizontal;
  }
}

class FlowParticlesPainter extends CustomPainter {
  final Color color;
  final double progress;
  final double intensity;
  final bool isHorizontal;

  FlowParticlesPainter({
    required this.color,
    required this.progress,
    required this.intensity,
    required this.isHorizontal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final particleCount = (3 * intensity).round().clamp(1, 5);

    for (int i = 0; i < particleCount; i++) {
      final offset = (i / particleCount);
      final particleProgress = (progress + offset) % 1.0;

      double x, y;
      if (isHorizontal) {
        x = size.width * particleProgress;
        y = size.height / 2;
      } else {
        x = size.width / 2;
        y = size.height * particleProgress;
      }

      final opacity = (math.sin(particleProgress * math.pi) * 0.8).clamp(
        0.0,
        1.0,
      );
      paint.color = color.withOpacity(opacity);

      final radius = 3.0 + (intensity * 2);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(FlowParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.intensity != intensity;
  }
}
