import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';

/// Two-column stat box with vertical divider.
/// Typically used on Detail Layanan to show ETA and Minimum Order.
class InfoStatBox extends StatelessWidget {
  final String leftLabel;
  final String leftValue;
  final IconData? leftIcon;
  final String rightLabel;
  final String rightValue;
  final IconData? rightIcon;

  const InfoStatBox({
    super.key,
    required this.leftLabel,
    required this.leftValue,
    this.leftIcon,
    required this.rightLabel,
    required this.rightValue,
    this.rightIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                if (leftIcon != null) ...[
                  Icon(leftIcon, size: 20, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        leftLabel,
                        style: AppTextTheme.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        leftValue,
                        style: AppTextTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 32,
            width: 1,
            color: AppColors.border,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          ),
          Expanded(
            child: Row(
              children: [
                if (rightIcon != null) ...[
                  Icon(rightIcon, size: 20, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        rightLabel,
                        style: AppTextTheme.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        rightValue,
                        style: AppTextTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
