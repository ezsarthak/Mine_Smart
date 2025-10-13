// filename: lib/presentation/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../../data/models/user_model.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.put(AuthService());
  final FirestoreService _firestoreService = Get.put(FirestoreService());

  final Rx<User?> _firebaseUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  User? get user => _firebaseUser.value;
  bool get isAuthenticated => _firebaseUser.value != null;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(_authService.authStateChanges);
    ever(_firebaseUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) {
    if (user == null) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      Get.offAllNamed(AppRoutes.dashboard);
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      await _authService.signInWithEmailAndPassword(email, password);
      Get.snackbar(
        'Success',
        'Logged in successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      isLoading.value = true;
      final credential = await _authService.createUserWithEmailAndPassword(
        email,
        password,
      );

      if (credential?.user != null) {
        await _authService.updateDisplayName(displayName);

        final userModel = UserModel(
          uid: credential!.user!.uid,
          email: email,
          displayName: displayName,
          createdAt: DateTime.now(),
        );

        await _firestoreService.createUser(userModel);

        Get.snackbar(
          'Success',
          'Account created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      Get.snackbar(
        'Success',
        'Logged out successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}
