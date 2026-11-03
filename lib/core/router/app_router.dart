import 'package:go_router/go_router.dart';

import '../../features/auth/domain/user_entity.dart';
import '../../features/auth/presentation/auth_providers.dart';
import '../../features/auth/presentation/complete_profile_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/cashier/presentation/cashier_screen.dart';
import '../../features/courier/presentation/courier_screen.dart';
import '../../features/order/presentation/home_screen.dart';
import '../../features/order/presentation/service_detail_screen.dart';
import '../widgets/component_gallery_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: currentUserNotifier,
  redirect: (context, state) {
    return roleBasedRedirectGuard(
      user: currentUserNotifier.value,
      currentPath: state.uri.path,
    );
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      name: 'otp',
      builder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        return OtpScreen(phoneNumber: phone);
      },
    ),
    GoRoute(
      path: '/complete-profile',
      name: 'complete-profile',
      builder: (context, state) => const CompleteProfileScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/service-detail/:id',
      name: 'service-detail',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ServiceDetailScreen(serviceId: id);
      },
    ),
    GoRoute(
      path: '/courier',
      name: 'courier',
      builder: (context, state) => const CourierScreen(),
    ),
    GoRoute(
      path: '/cashier',
      name: 'cashier',
      builder: (context, state) => const CashierScreen(),
    ),
    GoRoute(
      path: '/gallery',
      name: 'gallery',
      builder: (context, state) => const ComponentGalleryScreen(),
    ),
  ],
);

/// Helper function to enforce role-based redirection guards (C-01, Section 2).
String? roleBasedRedirectGuard({
  required UserEntity? user,
  required String currentPath,
}) {
  if (user == null) {
    if (currentPath == '/courier' ||
        currentPath == '/cashier' ||
        currentPath == '/complete-profile') {
      return '/login';
    }
    return null;
  }

  // Cross-role boundary enforcement
  if (user.role == UserRole.courier) {
    if (currentPath != '/courier') {
      return '/courier';
    }
    return null;
  }

  if (user.role == UserRole.cashier) {
    if (currentPath != '/cashier') {
      return '/cashier';
    }
    return null;
  }

  if (user.role == UserRole.customer) {
    if (currentPath == '/courier' || currentPath == '/cashier') {
      return '/home';
    }
    return null;
  }

  return null;
}
