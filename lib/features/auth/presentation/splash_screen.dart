import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// app_colors.dart accessed via AppGradients/AppTextTheme; direct import not needed here.
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/widgets/brand_mark.dart';
import 'auth_providers.dart';

/// Splash screen that checks onboarding and authentication state.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    // Delay minimum 1 second for smooth splash display
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    await ref.read(authStateProvider.notifier).checkInitialState();
    if (!mounted) return;

    final authState = ref.read(authStateProvider);

    if (!authState.isOnboardingCompleted) {
      context.go('/onboarding');
    } else if (authState.isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppGradients.brandHero),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Large BrandMark
              const BrandMark.large(customSize: 88),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Laundryin',
                style: AppTextTheme.h1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Cucian bersih, hidup tenang',
                style: AppTextTheme.body.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Versi 1.0.0 (MVP)',
                style: AppTextTheme.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
