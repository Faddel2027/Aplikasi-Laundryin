import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';

enum NoteCalloutVariant { info, warning, error }

/// Callout note banner with icon and message.
///
/// Variants:
/// - [NoteCalloutVariant.info]
/// - [NoteCalloutVariant.warning]
/// - [NoteCalloutVariant.error]
class NoteCallout extends StatelessWidget {
  final String message;
  final String? title;
  final NoteCalloutVariant variant;
  final IconData? customIcon;

  const NoteCallout({
    super.key,
    required this.message,
    this.title,
    this.variant = NoteCalloutVariant.info,
    this.customIcon,
  });

  const NoteCallout.warning({
    super.key,
    required this.message,
    this.title,
    this.customIcon,
  }) : variant = NoteCalloutVariant.warning;

  const NoteCallout.info({
    super.key,
    required this.message,
    this.title,
    this.customIcon,
  }) : variant = NoteCalloutVariant.info;

  const NoteCallout.error({
    super.key,
    required this.message,
    this.title,
    this.customIcon,
  }) : variant = NoteCalloutVariant.error;

  Color _getBackgroundColor() {
    switch (variant) {
      case NoteCalloutVariant.info:
        return AppColors.infoLight;
      case NoteCalloutVariant.warning:
        return AppColors.warningLight;
      case NoteCalloutVariant.error:
        return AppColors.errorLight;
    }
  }

  Color _getAccentColor() {
    switch (variant) {
      case NoteCalloutVariant.info:
        return AppColors.primaryDark;
      case NoteCalloutVariant.warning:
        return const Color(0xFFB45309);
      case NoteCalloutVariant.error:
        return AppColors.error;
    }
  }

  IconData _getDefaultIcon() {
    switch (variant) {
      case NoteCalloutVariant.info:
        return Icons.info_outline_rounded;
      case NoteCalloutVariant.warning:
        return Icons.warning_amber_rounded;
      case NoteCalloutVariant.error:
        return Icons.error_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor();
    final accentColor = _getAccentColor();
    final iconData = customIcon ?? _getDefaultIcon();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconData, size: 20, color: accentColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: AppTextTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                ],
                Text(
                  message,
                  style: AppTextTheme.caption.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
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
