// filename: lib/presentation/widgets/animated_equipment.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AnimatedEquipment extends StatefulWidget {
  final double rotationSpeed;
  final double glowIntensity;
  final double temperature;
  final double vibration;

  const AnimatedEquipment({
    super.key,
    required this.rotationSpeed,
    required this.glowIntensity,
    required this.temperature,
    required this.vibration,
  });

  @override
  State<AnimatedEquipment> createState() => _AnimatedEquipmentState();
}

class _AnimatedEquipmentState extends State<AnimatedEquipment>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void didUpdateWidget(AnimatedEquipment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rotationSpeed != widget.rotationSpeed) {
      _animationController.duration = Duration(
        milliseconds: (1000 / widget.rotationSpeed).round(),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getGlowColor() {
    if (widget.temperature >= 80) {
      return AppTheme.errorColor;
    } else if (widget.temperature >= 70) {
      return AppTheme.warningColor;
    } else if (widget.temperature >= 50) {
      return Colors.orange;
    }
    return AppTheme.accentColor;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final vibrationOffset = widget.vibration > 7
            ? Offset(
                math.sin(_animationController.value * math.pi * 20) * 2,
                math.cos(_animationController.value * math.pi * 20) * 2,
              )
            : Offset.zero;

        return Transform.translate(
          offset: vibrationOffset,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getGlowColor().withOpacity(
                    widget.glowIntensity * 0.5,
                  ),
                  blurRadius: 60 * widget.glowIntensity,
                  spreadRadius: 20 * widget.glowIntensity,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getGlowColor().withOpacity(0.5),
                      width: 3,
                    ),
                    gradient: RadialGradient(
                      colors: [
                        Colors.transparent,
                        _getGlowColor().withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                // Rotating blades
                Transform.rotate(
                  angle: _animationController.value * 2 * math.pi,
                  child: CustomPaint(
                    size: const Size(250, 250),
                    painter: CrusherBladePainter(
                      color: _getGlowColor(),
                      glowIntensity: widget.glowIntensity,
                    ),
                  ),
                ),
                // Center hub
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.cardColor,
                        _getGlowColor().withOpacity(0.3),
                      ],
                    ),
                    border: Border.all(color: _getGlowColor(), width: 4),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.settings,
                      color: _getGlowColor(),
                      size: 40,
                    ),
                  ),
                ),

                /// Energy particles
                // TODO:
                // ...List.generate(
                //   (widget.energy / 50).round().clamp(0, 12),
                //   (index) => _buildEnergyParticle(index),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnergyParticle(int index) {
    final angle = (index / 12) * 2 * math.pi;
    final distance = 140.0;
    final offset = Offset(
      math.cos(angle + _animationController.value * 2 * math.pi) * distance,
      math.sin(angle + _animationController.value * 2 * math.pi) * distance,
    );

    return Positioned(
      left: 150 + offset.dx,
      top: 150 + offset.dy,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.accentColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentColor.withOpacity(0.8),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class CrusherBladePainter extends CustomPainter {
  final Color color;
  final double glowIntensity;

  CrusherBladePainter({required this.color, required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = color.withOpacity(glowIntensity * 0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 * glowIntensity);

    final center = Offset(size.width / 2, size.height / 2);
    final bladeCount = 6;

    for (int i = 0; i < bladeCount; i++) {
      final angle = (i / bladeCount) * 2 * math.pi;
      final path = Path();

      // Create blade shape
      final bladeStart = Offset(
        center.dx + math.cos(angle) * 50,
        center.dy + math.sin(angle) * 50,
      );
      final bladeEnd = Offset(
        center.dx + math.cos(angle) * 120,
        center.dy + math.sin(angle) * 120,
      );
      final bladeLeft = Offset(
        center.dx + math.cos(angle - 0.3) * 100,
        center.dy + math.sin(angle - 0.3) * 100,
      );
      final bladeRight = Offset(
        center.dx + math.cos(angle + 0.3) * 100,
        center.dy + math.sin(angle + 0.3) * 100,
      );

      path.moveTo(bladeStart.dx, bladeStart.dy);
      path.lineTo(bladeLeft.dx, bladeLeft.dy);
      path.lineTo(bladeEnd.dx, bladeEnd.dy);
      path.lineTo(bladeRight.dx, bladeRight.dy);
      path.close();

      // Draw glow
      canvas.drawPath(path, glowPaint);
      // Draw blade
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CrusherBladePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.glowIntensity != glowIntensity;
  }
}
