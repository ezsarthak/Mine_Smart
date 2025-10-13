// filename: lib/data/models/sensor_reading_model.dart
class SensorReadingModel {
  final String id;
  final double temperature;
  final double vibration;
  final double energy;
  final DateTime timestamp;
  final String status;

  SensorReadingModel({
    required this.id,
    required this.temperature,
    required this.vibration,
    required this.energy,
    required this.timestamp,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'temperature': temperature,
      'vibration': vibration,
      'energy': energy,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }

  factory SensorReadingModel.fromJson(Map<String, dynamic> json) {
    return SensorReadingModel(
      id: json['id'] ?? '',
      temperature: (json['temperature'] ?? 0).toDouble(),
      vibration: (json['vibration'] ?? 0).toDouble(),
      energy: (json['energy'] ?? 0).toDouble(),
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      status: json['status'] ?? 'normal',
    );
  }
}
