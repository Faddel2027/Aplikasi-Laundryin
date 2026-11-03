import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';
import 'page_indicator.dart';

class PromoBannerItem {
  final String title;
  final String subtitle;
  final String? code;
  final String? badgeText;
  final VoidCallback? onTap;

  const PromoBannerItem({
    required this.title,
    required this.subtitle,
    this.code,
    this.badgeText,
    this.onTap,
  });
}

/// Promo banner carousel with blue gradient cards and page indicator.
///
/// States:
/// - Standard: 1 to 5 banner slides.
/// - Loading: Animated skeleton placeholder.
class PromoBanner extends StatefulWidget {
  final List<PromoBannerItem> items;
  final bool isLoading;
  final double height;

  const PromoBanner({
    super.key,
    required this.items,
    this.isLoading = false,
    this.height = 156,
  });

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Container(
        height: widget.height,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppRadius.cardRadius,
        ),
      );
    }

    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (idx) {
              setState(() => _currentPage = idx);
            },
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: InkWell(
                  onTap: item.onTap,
                  borderRadius: AppRadius.cardRadius,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: AppGradients.promoBanner,
                      borderRadius: AppRadius.cardRadius,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: ClipRect(
                      child: Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                        // Decorative water wave / bubble icons
                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: Icon(
                            Icons.local_offer_rounded,
                            size: 100,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (item.badgeText != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xxs,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: AppRadius.pillRadius,
                                ),
                                child: Text(
                                  item.badgeText!,
                                  style: AppTextTheme.caption.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                            ],
                            Text(
                              item.title,
                              style: AppTextTheme.h3.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              item.subtitle,
                              style: AppTextTheme.body.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (item.code != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'KODE: ${item.code}',
                                  style: AppTextTheme.captionMedium.copyWith(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          ),
        ),
        if (widget.items.length > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          PageIndicator(count: widget.items.length, currentIndex: _currentPage),
        ],
      ],
    );
  }
}
