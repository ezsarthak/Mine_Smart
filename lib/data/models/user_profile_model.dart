// filename: lib/data/models/user_profile_model.dart
class UserProfileModel {
  final String uid;
  final String email;
  final String displayName;
  final String role;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String? photoUrl;
  final Map<String, dynamic>? preferences;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    required this.createdAt,
    required this.lastLogin,
    this.photoUrl,
    this.preferences,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'photoUrl': photoUrl,
      'preferences': preferences,
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      role: json['role'] ?? 'Operator',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      lastLogin: DateTime.parse(
        json['lastLogin'] ?? DateTime.now().toIso8601String(),
      ),
      photoUrl: json['photoUrl'],
      preferences: json['preferences'],
    );
  }

  UserProfileModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? role,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? photoUrl,
    Map<String, dynamic>? preferences,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      photoUrl: photoUrl ?? this.photoUrl,
      preferences: preferences ?? this.preferences,
    );
  }
}
