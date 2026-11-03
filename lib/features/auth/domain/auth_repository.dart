import 'user_entity.dart';

abstract class AuthRepository {
  Future<bool> isOnboardingCompleted();
  Future<void> setOnboardingCompleted();
  Future<UserEntity?> getCurrentUser();
  Future<void> sendOtp(String phoneNumber);
  Future<UserEntity> verifyOtp(String phoneNumber, String otp);
  Future<UserEntity> signInWithGoogle();
  Future<UserEntity> updateProfile({required String name, String? email});
  Future<UserEntity> switchRole(UserRole newRole);
  Future<UserEntity> signInAsRole(UserRole role);
  Future<void> signOut();
}
