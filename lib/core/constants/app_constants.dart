// filename: lib/core/constants/app_constants.dart
class AppConstants {
  // App Info
  static const String appName = 'MineSmart';
  static const String appVersion = '1.0.0';

  // Sensor Constants
  static const int sensorUpdateInterval = 3; // seconds
  static const double minTemperature = 20.0;
  static const double maxTemperature = 85.0;
  static const double minVibration = 0.0;
  static const double maxVibration = 10.0;
  static const double minEnergy = 50.0;
  static const double maxEnergy = 500.0;

  // Threshold values
  static const double tempWarningThreshold = 70.0;
  static const double tempCriticalThreshold = 80.0;
  static const double vibrationWarningThreshold = 7.0;
  static const double vibrationCriticalThreshold = 9.0;
  static const double energyWarningThreshold = 400.0;
  static const double energyCriticalThreshold = 450.0;

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String sensorsCollection = 'sensor_readings';

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 300);
  static const Duration normalAnimation = Duration(milliseconds: 500);
  static const Duration slowAnimation = Duration(milliseconds: 800);
}
