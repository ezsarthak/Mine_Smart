// filename: lib/presentation/widgets/carbon_meter.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

class CarbonMeter extends StatefulWidget {
  final double intensity; // 0.0 to 1.0
  final double size;

  const CarbonMeter({super.key, required this.intensity, this.size = 280});

  @override
  State<CarbonMeter> createState() => _CarbonMeterState();
}

class _CarbonMeterState extends State<CarbonMeter>
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
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _getMeterColor(widget.intensity).withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating gradient background
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
                        _getMeterColor(widget.intensity).withOpacity(0.2),
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
            ),
          ),
          // Inner meter
          Container(
            width: widget.size - 20,
            height: widget.size - 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.backgroundColor,
            ),
          ),
          // Gradient arc
          CustomPaint(
            size: Size(widget.size - 40, widget.size - 40),
            painter: CarbonArcPainter(intensity: widget.intensity),
          ),
          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                    _getImpactIcon(widget.intensity),
                    size: widget.size * 0.2,
                    color: _getMeterColor(widget.intensity),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    duration: 2000.ms,
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                  ),
              const SizedBox(height: 16),
              Text(
                    '${(widget.intensity * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: widget.size * 0.12,
                      fontWeight: FontWeight.bold,
                      color: _getMeterColor(widget.intensity),
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    duration: 2000.ms,
                    color: _getMeterColor(widget.intensity).withOpacity(0.5),
                  ),
              const SizedBox(height: 8),
              Text(
                _getImpactLabel(widget.intensity),
                style: TextStyle(
                  fontSize: widget.size * 0.05,
                  color: _getMeterColor(widget.intensity).withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getMeterColor(double intensity) {
    if (intensity < 0.3) return const Color(0xFF4CAF50); // Green
    if (intensity < 0.6) return const Color(0xFFFFC107); // Yellow
    if (intensity < 0.8) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFF44336); // Red
  }

  IconData _getImpactIcon(double intensity) {
    if (intensity < 0.3) return Icons.eco;
    if (intensity < 0.6) return Icons.tips_and_updates;
    if (intensity < 0.8) return Icons.warning_amber;
    return Icons.error;
  }

  String _getImpactLabel(double intensity) {
    if (intensity < 0.3) return 'Excellent';
    if (intensity < 0.6) return 'Good';
    if (intensity < 0.8) return 'Moderate';
    return 'High Impact';
  }
}

class CarbonArcPainter extends CustomPainter {
  final double intensity;

  CarbonArcPainter({required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 30.0;

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi,
      math.pi * 2,
      false,
      bgPaint,
    );

    // Gradient arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -math.pi,
      endAngle: math.pi,
      colors: [
        const Color(0xFF4CAF50), // Green
        const Color(0xFF8BC34A),
        const Color(0xFFCDDC39),
        const Color(0xFFFFC107), // Yellow
        const Color(0xFFFF9800),
        const Color(0xFFFF5722),
        const Color(0xFFF44336), // Red
      ],
      stops: const [0.0, 0.15, 0.3, 0.5, 0.7, 0.85, 1.0],
    );

    final gradientPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = math.pi * 2 * intensity;

    canvas.drawArc(rect, -math.pi, sweepAngle, false, gradientPaint);

    // Glow effect
    final glowPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 15
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawArc(rect, -math.pi, sweepAngle, false, glowPaint);
  }

  @override
  bool shouldRepaint(CarbonArcPainter oldDelegate) {
    return oldDelegate.intensity != intensity;
  }
}
