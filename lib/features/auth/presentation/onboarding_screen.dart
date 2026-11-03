import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_link.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../core/widgets/illustration_card.dart';
import '../../../core/widgets/page_indicator.dart';
import 'auth_providers.dart';

class OnboardingSlideData {
  final String title;
  final String description;
  final IllustrationCardTheme theme;
  final IconData icon;

  const OnboardingSlideData({
    required this.title,
    required this.description,
    required this.theme,
    required this.icon,
  });
}

/// Onboarding screen with 3 slides introducing Laundryin features.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      title: 'Pesan Dari Rumah',
      description: 'Pilih jenis cucianmu, atur jadwal pengambilan, dan biarkan kurir kami yang bekerja untukmu.',
      theme: IllustrationCardTheme.blue,
      icon: Icons.home_work_rounded,
    ),
    OnboardingSlideData(
      title: 'Dijemput & Diantar',
      description: 'Pakaian kotor diambil langsung di depan pintu rumahmu dan diantar kembali bersih, wangi, serta rapi.',
      theme: IllustrationCardTheme.tosca,
      icon: Icons.local_shipping_rounded,
    ),
    OnboardingSlideData(
      title: 'Pantau Real-Time',
      description: 'Pantau tahapan cuci, timbangan kasir, hingga posisi kurir secara langsung dari genggaman ponselmu.',
      theme: IllustrationCardTheme.purple,
      icon: Icons.track_changes_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    await ref.read(authStateProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go('/login');
    }
  }

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastSlide = _currentPage == _slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: AppSpacing.screenPadding,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandMark.small(customSize: 28),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Laundryin',
              style: AppTextTheme.h3.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          if (!isLastSlide)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
              child: AppTextLink(text: 'Lewati', onTap: _finishOnboarding),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IllustrationCard(
                          theme: slide.theme,
                          icon: slide.icon,
                          height: 260,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          slide.title,
                          style: AppTextTheme.h1,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                          ),
                          child: Text(
                            slide.description,
                            style: AppTextTheme.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              PageIndicator(count: _slides.length, currentIndex: _currentPage),
              const SizedBox(height: AppSpacing.xxl),
              AppButton.primary(
                text: isLastSlide ? 'Mulai Sekarang' : 'Selanjutnya',
                icon: Icons.arrow_forward_rounded,
                onPressed: _onNext,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
