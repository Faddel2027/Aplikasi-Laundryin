import '../../../core/errors/failures.dart';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';

class FakeAuthRepository implements AuthRepository {
  bool _onboardingCompleted = false;
  UserEntity? _currentUser;

  @override
  Future<bool> isOnboardingCompleted() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _onboardingCompleted;
  }

  @override
  Future<void> setOnboardingCompleted() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _onboardingCompleted = true;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _currentUser;
  }

  @override
  Future<void> sendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9) {
      throw const ValidationFailure('Nomor telepon minimal 9 digit');
    }
  }

  @override
  Future<UserEntity> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (otp != '123456') {
      throw const ValidationFailure(
        'Kode OTP salah. Masukkan 123456 untuk pengujian.',
      );
    }

    final user = UserEntity(
      uid: 'user-001',
      name: 'Barup',
      phoneNumber: phoneNumber.startsWith('+62')
          ? phoneNumber
          : '+62$phoneNumber',
      role: UserRole.customer,
    );
    _currentUser = user;
    return user;
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = const UserEntity(
      uid: 'user-google-001',
      name: 'Barup Google',
      phoneNumber: '+6281234567890',
      email: 'barup@example.com',
      role: UserRole.customer,
    );
    _currentUser = user;
    return user;
  }

  @override
  Future<UserEntity> updateProfile({required String name, String? email}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_currentUser == null) {
      _currentUser = UserEntity(
        uid: 'user-001',
        name: name,
        phoneNumber: '+6281234567890',
        email: email,
        role: UserRole.customer,
      );
    } else {
      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email ?? _currentUser!.email,
      );
    }
    return _currentUser!;
  }

  @override
  Future<UserEntity> switchRole(UserRole newRole) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (_currentUser == null) {
      _currentUser = UserEntity(
        uid: 'user-001',
        name: 'Barup',
        phoneNumber: '+6281234567890',
        role: newRole,
      );
    } else {
      _currentUser = _currentUser!.copyWith(role: newRole);
    }
    return _currentUser!;
  }

  @override
  Future<UserEntity> signInAsRole(UserRole role) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final UserEntity user;
    switch (role) {
      case UserRole.customer:
        user = const UserEntity(
          uid: 'user-001',
          name: 'Barup',
          phoneNumber: '+6281234567890',
          email: 'barup@laundryin.id',
          role: UserRole.customer,
        );
        break;
      case UserRole.courier:
        user = const UserEntity(
          uid: 'kurir-001',
          name: 'Bambang (Kurir)',
          phoneNumber: '+6281122334455',
          email: 'bambang.kurir@laundryin.id',
          role: UserRole.courier,
        );
        break;
      case UserRole.cashier:
        user = const UserEntity(
          uid: 'kasir-001',
          name: 'Dewi (Kasir)',
          phoneNumber: '+6285566778899',
          email: 'dewi.kasir@laundryin.id',
          role: UserRole.cashier,
        );
        break;
      case UserRole.admin:
        user = const UserEntity(
          uid: 'admin-001',
          name: 'Owner (Admin)',
          phoneNumber: '+628999888777',
          email: 'admin@laundryin.id',
          role: UserRole.admin,
        );
        break;
    }
    _currentUser = user;
    return user;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 150));
    _currentUser = null;
  }
}
