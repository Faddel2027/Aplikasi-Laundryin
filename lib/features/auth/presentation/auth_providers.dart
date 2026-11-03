import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/fake_auth_repository.dart';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';

/// Global ValueNotifier for reactive GoRouter refreshListenable & route guards.
final currentUserNotifier = ValueNotifier<UserEntity?>(null);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FakeAuthRepository();
});

class AuthState {
  final bool isLoading;
  final UserEntity? user;
  final String? errorMessage;
  final bool isOnboardingCompleted;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.isOnboardingCompleted = false,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    bool? isLoading,
    UserEntity? user,
    String? errorMessage,
    bool? isOnboardingCompleted,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isOnboardingCompleted: isOnboardingCompleted ?? this.isOnboardingCompleted,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> checkInitialState() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final onboarding = await _repository.isOnboardingCompleted();
      final user = await _repository.getCurrentUser();
      currentUserNotifier.value = user;
      state = state.copyWith(
        isLoading: false,
        isOnboardingCompleted: onboarding,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> completeOnboarding() async {
    await _repository.setOnboardingCompleted();
    state = state.copyWith(isOnboardingCompleted: true);
  }

  Future<bool> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.sendOtp(phoneNumber);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.verifyOtp(phoneNumber, otp);
      currentUserNotifier.value = user;
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.signInWithGoogle();
      currentUserNotifier.value = user;
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> signInAsRole(UserRole role) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.signInAsRole(role);
      currentUserNotifier.value = user;
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateProfile({required String name, String? email}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.updateProfile(name: name, email: email);
      currentUserNotifier.value = user;
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> switchRole(UserRole newRole) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _repository.switchRole(newRole);
      currentUserNotifier.value = user;
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    currentUserNotifier.value = null;
    state = state.copyWith(user: null);
  }
}

final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

