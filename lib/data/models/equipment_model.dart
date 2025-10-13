// filename: lib/data/models/equipment_model.dart
class EquipmentModel {
  final String id;
  final String name;
  final String type;
  final DateTime lastMaintenance;
  final DateTime predictedNextService;
  final String status; // healthy, at_risk, critical
  final double currentVibration;
  final double currentTemperature;
  final double avgEnergyConsumption;

  EquipmentModel({
    required this.id,
    required this.name,
    required this.type,
    required this.lastMaintenance,
    required this.predictedNextService,
    required this.status,
    required this.currentVibration,
    required this.currentTemperature,
    required this.avgEnergyConsumption,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'lastMaintenance': lastMaintenance.toIso8601String(),
      'predictedNextService': predictedNextService.toIso8601String(),
      'status': status,
      'currentVibration': currentVibration,
      'currentTemperature': currentTemperature,
      'avgEnergyConsumption': avgEnergyConsumption,
    };
  }

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      lastMaintenance: DateTime.parse(
        json['lastMaintenance'] ?? DateTime.now().toIso8601String(),
      ),
      predictedNextService: DateTime.parse(
        json['predictedNextService'] ?? DateTime.now().toIso8601String(),
      ),
      status: json['status'] ?? 'healthy',
      currentVibration: (json['currentVibration'] ?? 0).toDouble(),
      currentTemperature: (json['currentTemperature'] ?? 0).toDouble(),
      avgEnergyConsumption: (json['avgEnergyConsumption'] ?? 0).toDouble(),
    );
  }

  EquipmentModel copyWith({
    String? id,
    String? name,
    String? type,
    DateTime? lastMaintenance,
    DateTime? predictedNextService,
    String? status,
    double? currentVibration,
    double? currentTemperature,
    double? avgEnergyConsumption,
  }) {
    return EquipmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      lastMaintenance: lastMaintenance ?? this.lastMaintenance,
      predictedNextService: predictedNextService ?? this.predictedNextService,
      status: status ?? this.status,
      currentVibration: currentVibration ?? this.currentVibration,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      avgEnergyConsumption: avgEnergyConsumption ?? this.avgEnergyConsumption,
    );
  }
}
