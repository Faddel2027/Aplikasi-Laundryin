import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';

/// Hero image header for service details.
///
/// Variants:
/// - Image + back button + badge.
/// - Image + back button without badge.
/// - Fallback placeholder when image fails to load.
class HeroImageHeader extends StatelessWidget {
  final String? imageUrl;
  final String? badgeText;
  final VoidCallback? onBackTap;
  final double height;
  final IconData placeholderIcon;

  const HeroImageHeader({
    super.key,
    this.imageUrl,
    this.badgeText,
    this.onBackTap,
    this.height = 240,
    this.placeholderIcon = Icons.local_laundry_service_rounded,
  });

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(gradient: AppGradients.brandHero),
      child: Center(
        child: Icon(
          placeholderIcon,
          size: 72,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with gradient fallback
          if (imageUrl != null && imageUrl!.isNotEmpty)
            Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.surfaceVariant,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            )
          else
            _buildPlaceholder(),

          // Dark gradient overlay for contrast
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.darkOverlay,
              ),
            ),
          ),

          // Floating Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.sm,
            left: AppSpacing.screenPadding,
            child: Material(
              color: AppColors.surface.withValues(alpha: 0.9),
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onBackTap ?? () => Navigator.of(context).maybePop(),
                child: const SizedBox(
                  width: AppSpacing.minTouchTarget,
                  height: AppSpacing.minTouchTarget,
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textPrimary,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Optional Badge on top right
          if (badgeText != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + AppSpacing.md,
              right: AppSpacing.screenPadding,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.pillRadius,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      badgeText!,
                      style: AppTextTheme.captionMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
