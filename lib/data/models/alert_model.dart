// filename: lib/data/models/alert_model.dart
class AlertModel {
  final String id;
  final String sensorName;
  final DateTime timestamp;
  final double value;
  final String type; // temp, vibration, energy
  final String severity; // warning, critical
  final bool resolved;
  final String message;

  AlertModel({
    required this.id,
    required this.sensorName,
    required this.timestamp,
    required this.value,
    required this.type,
    required this.severity,
    required this.resolved,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sensorName': sensorName,
      'timestamp': timestamp.toIso8601String(),
      'value': value,
      'type': type,
      'severity': severity,
      'resolved': resolved,
      'message': message,
    };
  }

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] ?? '',
      sensorName: json['sensorName'] ?? '',
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      value: (json['value'] ?? 0).toDouble(),
      type: json['type'] ?? '',
      severity: json['severity'] ?? 'warning',
      resolved: json['resolved'] ?? false,
      message: json['message'] ?? '',
    );
  }

  AlertModel copyWith({
    String? id,
    String? sensorName,
    DateTime? timestamp,
    double? value,
    String? type,
    String? severity,
    bool? resolved,
    String? message,
  }) {
    return AlertModel(
      id: id ?? this.id,
      sensorName: sensorName ?? this.sensorName,
      timestamp: timestamp ?? this.timestamp,
      value: value ?? this.value,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      resolved: resolved ?? this.resolved,
      message: message ?? this.message,
    );
  }
}
