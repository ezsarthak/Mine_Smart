// filename: lib/presentation/widgets/health_radar_chart.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

class HealthRadarChart extends StatefulWidget {
  final List<RadarDataPoint> dataPoints;
  final double size;
  final VoidCallback? onTap;
  final Function(int index)? onSegmentTap;

  const HealthRadarChart({
    super.key,
    required this.dataPoints,
    this.size = 300,
    this.onTap,
    this.onSegmentTap,
  });

  @override
  State<HealthRadarChart> createState() => _HealthRadarChartState();
}

class _HealthRadarChartState extends State<HealthRadarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int? _hoveredIndex;

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
    return GestureDetector(
      onTapUp: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.globalPosition);
        final center = Offset(widget.size / 2, widget.size / 2);
        final dx = localPosition.dx - center.dx;
        final dy = localPosition.dy - center.dy;

        // Calculate angle
        var angle = math.atan2(dy, dx);
        if (angle < 0) angle += 2 * math.pi;

        // Determine which segment was tapped
        final segmentAngle = 2 * math.pi / widget.dataPoints.length;
        final adjustedAngle = angle + segmentAngle / 2;
        final segmentIndex =
            (adjustedAngle / segmentAngle).floor() % widget.dataPoints.length;

        widget.onSegmentTap?.call(segmentIndex);
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing glow for critical zones
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final hasCritical = widget.dataPoints.any((p) => p.value < 30);
                if (!hasCritical) return const SizedBox.shrink();

                return Container(
                  width: widget.size + 40 * _animationController.value,
                  height: widget.size + 40 * _animationController.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.red.withOpacity(
                          0.3 * (1 - _animationController.value),
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
            // Radar chart
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: RadarChartPainter(
                dataPoints: widget.dataPoints,
                hoveredIndex: _hoveredIndex,
              ),
            ),
            // Center risk indicator
            _buildCenterIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterIndicator() {
    final avgHealth =
        widget.dataPoints.map((p) => p.value).reduce((a, b) => a + b) /
        widget.dataPoints.length;

    final color = _getHealthColor(avgHealth);
    final riskLevel = _getHealthLevel(avgHealth);

    return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
            ),
            border: Border.all(color: color, width: 3),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${avgHealth.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                riskLevel,
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 2000.ms, color: color.withOpacity(0.3));
  }

  Color _getHealthColor(double value) {
    if (value >= 80) return AppTheme.successColor;
    if (value >= 60) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }

  String _getHealthLevel(double value) {
    if (value >= 80) return 'HEALTHY';
    if (value >= 60) return 'WARNING';
    return 'CRITICAL';
  }
}

class RadarChartPainter extends CustomPainter {
  final List<RadarDataPoint> dataPoints;
  final int? hoveredIndex;

  RadarChartPainter({required this.dataPoints, this.hoveredIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 40;

    // Draw background circles (risk zones)
    _drawRiskZones(canvas, center, radius);

    // Draw grid lines
    _drawGridLines(canvas, center, radius);

    // Draw data polygon
    _drawDataPolygon(canvas, center, radius);

    // Draw data points
    _drawDataPoints(canvas, center, radius);

    // Draw labels
    _drawLabels(canvas, center, radius);
  }

  void _drawRiskZones(Canvas canvas, Offset center, double radius) {
    // Critical zone (0-30%)
    final criticalPaint = Paint()
      ..color = AppTheme.errorColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.3, criticalPaint);

    // Warning zone (30-60%)
    final warningPaint = Paint()
      ..color = AppTheme.warningColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.6, warningPaint);

    // Normal zone (60-100%)
    final normalPaint = Paint()
      ..color = AppTheme.successColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, normalPaint);
  }

  void _drawGridLines(Canvas canvas, Offset center, double radius) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw concentric circles
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(center, radius * (i / 5), gridPaint);
    }

    // Draw radial lines
    final angleStep = 2 * math.pi / dataPoints.length;
    for (int i = 0; i < dataPoints.length; i++) {
      final angle = i * angleStep - math.pi / 2;
      final endX = center.dx + radius * math.cos(angle);
      final endY = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(endX, endY), gridPaint);
    }
  }

  void _drawDataPolygon(Canvas canvas, Offset center, double radius) {
    if (dataPoints.isEmpty) return;

    final path = Path();
    final angleStep = 2 * math.pi / dataPoints.length;

    for (int i = 0; i < dataPoints.length; i++) {
      final angle = i * angleStep - math.pi / 2;
      final value = dataPoints[i].value / 100;
      final x = center.dx + radius * value * math.cos(angle);
      final y = center.dy + radius * value * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // Fill
    final fillPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppTheme.accentColor.withOpacity(0.5),
          AppTheme.primaryColor.withOpacity(0.3),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Stroke
    final strokePaint = Paint()
      ..color = AppTheme.accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(path, strokePaint);
  }

  void _drawDataPoints(Canvas canvas, Offset center, double radius) {
    final angleStep = 2 * math.pi / dataPoints.length;

    for (int i = 0; i < dataPoints.length; i++) {
      final angle = i * angleStep - math.pi / 2;
      final value = dataPoints[i].value / 100;
      final x = center.dx + radius * value * math.cos(angle);
      final y = center.dy + radius * value * math.sin(angle);

      final color = _getHealthColor(dataPoints[i].value);
      final isHovered = hoveredIndex == i;

      // Glow effect
      final glowPaint = Paint()
        ..color = color.withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(Offset(x, y), isHovered ? 12 : 8, glowPaint);

      // Point
      final pointPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), isHovered ? 8 : 6, pointPaint);

      // Border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(x, y), isHovered ? 8 : 6, borderPaint);
    }
  }

  void _drawLabels(Canvas canvas, Offset center, double radius) {
    final angleStep = 2 * math.pi / dataPoints.length;

    for (int i = 0; i < dataPoints.length; i++) {
      final angle = i * angleStep - math.pi / 2;
      final labelRadius = radius + 25;
      final x = center.dx + labelRadius * math.cos(angle);
      final y = center.dy + labelRadius * math.sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: dataPoints[i].label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  Color _getHealthColor(double value) {
    if (value >= 80) return AppTheme.successColor;
    if (value >= 60) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints ||
        oldDelegate.hoveredIndex != hoveredIndex;
  }
}

class RadarDataPoint {
  final String label;
  final double value;

  RadarDataPoint({required this.label, required this.value});
}
