// filename: lib/presentation/controllers/anomaly_detection_controller.dart
import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';

class AnomalyDetectionController extends GetxController {
  final Random _random = Random();
  Timer? _updateTimer;

  // Equipment being monitored
  final RxList<EquipmentHealth> equipmentList = <EquipmentHealth>[].obs;
  final RxInt criticalAnomalies = 0.obs;
  final RxInt warningAnomalies = 0.obs;
  final RxInt totalAnomaliesDetected = 0.obs;
  final RxDouble systemHealthScore = 85.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeEquipment();
    _startAnomalyDetection();
  }

  void _initializeEquipment() {
    equipmentList.value = [
      EquipmentHealth(
        id: '1',
        name: 'Crusher Unit A',
        type: 'Crusher',
        icon: '⚙️',
        parameters: [
          HealthParameter('Vibration', 85, 'mm/s'),
          HealthParameter('Temperature', 92, '°C'),
          HealthParameter('Pressure', 78, 'bar'),
          HealthParameter('Load', 88, '%'),
          HealthParameter('Efficiency', 91, '%'),
        ],
      ),
      EquipmentHealth(
        id: '2',
        name: 'Mill Unit B',
        type: 'Mill',
        icon: '🔄',
        parameters: [
          HealthParameter('Vibration', 75, 'mm/s'),
          HealthParameter('Temperature', 82, '°C'),
          HealthParameter('Rotation', 88, 'RPM'),
          HealthParameter('Feed Rate', 90, 't/h'),
          HealthParameter('Power', 85, 'kW'),
        ],
      ),
      EquipmentHealth(
        id: '3',
        name: 'Conveyor Belt C',
        type: 'Conveyor',
        icon: '↔️',
        parameters: [
          HealthParameter('Speed', 95, 'm/s'),
          HealthParameter('Temperature', 88, '°C'),
          HealthParameter('Tension', 80, 'N'),
          HealthParameter('Alignment', 92, '%'),
          HealthParameter('Wear', 85, '%'),
        ],
      ),
      EquipmentHealth(
        id: '4',
        name: 'Pump System D',
        type: 'Pump',
        icon: '💧',
        parameters: [
          HealthParameter('Pressure', 90, 'bar'),
          HealthParameter('Flow Rate', 87, 'L/min'),
          HealthParameter('Temperature', 85, '°C'),
          HealthParameter('Vibration', 82, 'mm/s'),
          HealthParameter('Cavitation', 88, '%'),
        ],
      ),
      EquipmentHealth(
        id: '5',
        name: 'Separator E',
        type: 'Separator',
        icon: '🔬',
        parameters: [
          HealthParameter('Efficiency', 89, '%'),
          HealthParameter('Temperature', 86, '°C'),
          HealthParameter('Vibration', 91, 'mm/s'),
          HealthParameter('Air Flow', 84, 'm³/h'),
          HealthParameter('Pressure', 87, 'bar'),
        ],
      ),
    ];
    _updateAnomalyCounts();
  }

  void _startAnomalyDetection() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _simulateAnomalies();
      _updateAnomalyCounts();
      _updateSystemHealth();
    });
  }

  void _simulateAnomalies() {
    for (var equipment in equipmentList) {
      for (var parameter in equipment.parameters) {
        // Random fluctuation
        final fluctuation = _random.nextDouble() * 10 - 5;
        parameter.healthScore = (parameter.healthScore + fluctuation).clamp(
          0.0,
          100.0,
        );

        // Occasionally introduce anomalies
        if (_random.nextDouble() < 0.05) {
          // 5% chance of anomaly
          parameter.healthScore =
              (_random.nextDouble() * 40 + 30); // Drop to 30-70 range
        }

        // Very rare critical anomaly
        if (_random.nextDouble() < 0.01) {
          // 1% chance
          parameter.healthScore =
              (_random.nextDouble() * 30); // Critical: 0-30 range
        }
      }
      equipment.updateOverallHealth();
    }
  }

  void _updateAnomalyCounts() {
    int critical = 0;
    int warning = 0;
    int total = 0;

    for (var equipment in equipmentList) {
      for (var parameter in equipment.parameters) {
        if (parameter.healthScore < 30) {
          critical++;
          total++;
        } else if (parameter.healthScore < 60) {
          warning++;
          total++;
        }
      }
    }

    criticalAnomalies.value = critical;
    warningAnomalies.value = warning;
    totalAnomaliesDetected.value = total;
  }

  void _updateSystemHealth() {
    double totalHealth = 0;
    for (var equipment in equipmentList) {
      totalHealth += equipment.overallHealth;
    }
    systemHealthScore.value = totalHealth / equipmentList.length;
  }

  AnomalyAnalysis analyzeAnomaly(
    EquipmentHealth equipment,
    HealthParameter parameter,
  ) {
    final riskLevel = _getRiskLevel(parameter.healthScore);
    final possibleCauses = _generatePossibleCauses(
      equipment.type,
      parameter.name,
      riskLevel,
    );
    final confidence = _random.nextDouble() * 30 + 65; // 65-95% confidence
    final recommendations = _generateRecommendations(parameter.name, riskLevel);

    return AnomalyAnalysis(
      equipmentName: equipment.name,
      parameterName: parameter.name,
      currentValue: parameter.healthScore,
      riskLevel: riskLevel,
      primaryCause: possibleCauses.first,
      confidence: confidence,
      allCauses: possibleCauses,
      recommendations: recommendations,
      detectedAt: DateTime.now(),
    );
  }

  String _getRiskLevel(double healthScore) {
    if (healthScore >= 80) return 'Normal';
    if (healthScore >= 60) return 'Warning';
    return 'Critical';
  }

  List<String> _generatePossibleCauses(
    String equipmentType,
    String parameter,
    String riskLevel,
  ) {
    final causes = <String>[];

    if (parameter.toLowerCase().contains('vibration')) {
      causes.addAll([
        'Bearing wear detected',
        'Misalignment in rotating components',
        'Loose mounting bolts',
        'Unbalanced rotor',
        'Foundation degradation',
      ]);
    } else if (parameter.toLowerCase().contains('temperature')) {
      causes.addAll([
        'Insufficient cooling system',
        'Bearing lubrication failure',
        'Overload conditions',
        'Blocked ventilation',
        'Thermal sensor drift',
      ]);
    } else if (parameter.toLowerCase().contains('pressure')) {
      causes.addAll([
        'Seal leakage detected',
        'Pump wear or cavitation',
        'Clogged filters',
        'Pressure relief valve fault',
        'Pipeline restriction',
      ]);
    } else if (parameter.toLowerCase().contains('efficiency')) {
      causes.addAll([
        'Component wear and tear',
        'Suboptimal operating parameters',
        'Material buildup',
        'Calibration drift',
        'Process variable changes',
      ]);
    } else {
      causes.addAll([
        'Component degradation',
        'Abnormal operating conditions',
        'Sensor calibration error',
        'Environmental factors',
        'Material quality variation',
      ]);
    }

    causes.shuffle();
    return causes.take(3).toList();
  }

  List<String> _generateRecommendations(String parameter, String riskLevel) {
    final recommendations = <String>[];

    if (riskLevel == 'Critical') {
      recommendations.addAll([
        'URGENT: Stop equipment immediately',
        'Conduct emergency inspection',
        'Replace affected components',
        'Verify all safety systems',
      ]);
    } else if (riskLevel == 'Warning') {
      recommendations.addAll([
        'Schedule preventive maintenance',
        'Increase monitoring frequency',
        'Check related subsystems',
        'Review operating procedures',
      ]);
    } else {
      recommendations.addAll([
        'Continue normal operations',
        'Maintain regular monitoring',
        'Document current readings',
      ]);
    }

    return recommendations;
  }

  void refresh() {
    _initializeEquipment();
  }

  @override
  void onClose() {
    _updateTimer?.cancel();
    super.onClose();
  }
}

class EquipmentHealth {
  final String id;
  final String name;
  final String type;
  final String icon;
  final List<HealthParameter> parameters;
  double overallHealth = 0;

  EquipmentHealth({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.parameters,
  }) {
    updateOverallHealth();
  }

  void updateOverallHealth() {
    double total = 0;
    for (var param in parameters) {
      total += param.healthScore;
    }
    overallHealth = total / parameters.length;
  }

  String getRiskLevel() {
    if (overallHealth >= 80) return 'normal';
    if (overallHealth >= 60) return 'warning';
    return 'critical';
  }
}

class HealthParameter {
  final String name;
  double healthScore;
  final String unit;

  HealthParameter(this.name, this.healthScore, this.unit);
}

class AnomalyAnalysis {
  final String equipmentName;
  final String parameterName;
  final double currentValue;
  final String riskLevel;
  final String primaryCause;
  final double confidence;
  final List<String> allCauses;
  final List<String> recommendations;
  final DateTime detectedAt;

  AnomalyAnalysis({
    required this.equipmentName,
    required this.parameterName,
    required this.currentValue,
    required this.riskLevel,
    required this.primaryCause,
    required this.confidence,
    required this.allCauses,
    required this.recommendations,
    required this.detectedAt,
  });
}
