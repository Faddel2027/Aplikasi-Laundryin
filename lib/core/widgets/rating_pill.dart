import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';

/// Rating pill component.
///
/// Variants:
/// - Star icon + average score + review count.
/// - Unrated state: "Belum ada ulasan".
class RatingPill extends StatelessWidget {
  final double? rating;
  final int? reviewCount;

  const RatingPill({super.key, this.rating, this.reviewCount});

  const RatingPill.unrated({super.key}) : rating = null, reviewCount = null;

  @override
  Widget build(BuildContext context) {
    if (rating == null || rating == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppRadius.pillRadius,
        ),
        child: Text(
          'Belum ada ulasan',
          style: AppTextTheme.caption.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: AppRadius.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
          const SizedBox(width: AppSpacing.xs),
          Text(
            rating!.toStringAsFixed(1),
            style: AppTextTheme.captionMedium.copyWith(
              color: const Color(0xFFB45309), // Amber-700
              fontWeight: FontWeight.w700,
            ),
          ),
          if (reviewCount != null && reviewCount! > 0) ...[
            const SizedBox(width: AppSpacing.xs),
            Text(
              '($reviewCount)',
              style: AppTextTheme.caption.copyWith(
                color: const Color(0xFFB45309),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
