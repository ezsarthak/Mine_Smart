// filename: lib/presentation/widgets/alert_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/alert_model.dart';

class AlertCard extends StatelessWidget {
  final AlertModel alert;
  final VoidCallback onResolve;
  final VoidCallback onDelete;

  const AlertCard({
    super.key,
    required this.alert,
    required this.onResolve,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final isCritical = alert.severity == 'critical';

    return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.15), AppTheme.cardColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: alert.resolved ? color.withOpacity(0.3) : color,
              width: alert.resolved ? 1 : 3,
            ),
            boxShadow: alert.resolved
                ? null
                : [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(_getIcon(), color: color, size: 28),
                        )
                        .animate(
                          onPlay: (controller) => !alert.resolved && isCritical
                              ? controller.repeat()
                              : null,
                        )
                        .shake(duration: 1000.ms)
                        .then()
                        .shimmer(
                          duration: 1000.ms,
                          color: color.withOpacity(0.5),
                        ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert.sensorName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: color),
                                ),
                                child: Text(
                                  alert.severity.toUpperCase(),
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getTypeColor().withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  alert.type.toUpperCase(),
                                  style: TextStyle(
                                    color: _getTypeColor(),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (alert.resolved)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppTheme.successColor,
                          size: 20,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.white70, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          alert.message,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.white54),
                    const SizedBox(width: 6),
                    Text(
                      _formatTimestamp(alert.timestamp),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    if (!alert.resolved)
                      TextButton.icon(
                        onPressed: onResolve,
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text('Resolve'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.successColor,
                        ),
                      ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline),
                      color: AppTheme.errorColor,
                      iconSize: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .animate(
          onPlay: (controller) =>
              !alert.resolved && isCritical ? controller.repeat() : null,
        )
        .fadeIn(duration: 1000.ms)
        .then()
        .fadeOut(duration: 1000.ms);
  }

  Color _getColor() {
    if (alert.resolved) return AppTheme.successColor;
    return alert.severity == 'critical'
        ? AppTheme.errorColor
        : AppTheme.warningColor;
  }

  Color _getTypeColor() {
    switch (alert.type) {
      case 'temperature':
        return Colors.orange;
      case 'vibration':
        return Colors.purple;
      case 'energy':
        return AppTheme.accentColor;
      default:
        return Colors.blue;
    }
  }

  IconData _getIcon() {
    switch (alert.type) {
      case 'temperature':
        return Icons.thermostat;
      case 'vibration':
        return Icons.vibration;
      case 'energy':
        return Icons.bolt;
      default:
        return Icons.sensors;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
