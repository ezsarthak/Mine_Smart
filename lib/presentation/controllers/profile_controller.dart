// filename: lib/presentation/controllers/profile_controller.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/services/firestore_service.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final AuthController _authController = Get.find<AuthController>();

  final Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    try {
      isLoading.value = true;
      final user = _authController.user;

      if (user != null) {
        // Create profile from Firebase user
        userProfile.value = UserProfileModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? 'User',
          role: 'Mining Operations Supervisor',
          createdAt: user.metadata.creationTime ?? DateTime.now(),
          lastLogin: user.metadata.lastSignInTime ?? DateTime.now(),
          photoUrl: user.photoURL,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void refresh() {
    _loadUserProfile();
  }
}
