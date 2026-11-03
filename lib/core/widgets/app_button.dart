import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';

enum AppButtonVariant { primary, outline }

/// Standard reusable button for Laundryin.
///
/// Variants:
/// - [AppButton.primary]: Filled primary button with optional right icon.
/// - [AppButton.outline]: Outlined border button with optional left icon.
///
/// States handled: default, pressed, disabled, loading.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final bool isFullWidth;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isFullWidth = true,
    this.width,
    this.height = AppSpacing.minTouchTarget,
  });

  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isFullWidth = true,
    this.width,
    this.height = AppSpacing.minTouchTarget,
  }) : variant = AppButtonVariant.primary;

  const AppButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isFullWidth = true,
    this.width,
    this.height = AppSpacing.minTouchTarget,
  }) : variant = AppButtonVariant.outline;

  @override
  Widget build(BuildContext context) {
    final bool effectivelyDisabled =
        isDisabled || isLoading || onPressed == null;

    Widget content;
    if (isLoading) {
      content = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == AppButtonVariant.primary
                ? AppColors.textOnPrimary
                : AppColors.primary,
          ),
        ),
      );
    } else {
      final textWidget = Text(
        text,
        style: AppTextTheme.button.copyWith(
          color: effectivelyDisabled
              ? AppColors.disabledText
              : (variant == AppButtonVariant.primary
                    ? AppColors.textOnPrimary
                    : AppColors.primaryDark),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

      if (icon != null) {
        if (variant == AppButtonVariant.primary) {
          // Primary: Icon on right per PRD
          content = Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: textWidget),
              const SizedBox(width: AppSpacing.sm),
              Icon(
                icon,
                size: 20,
                color: effectivelyDisabled
                    ? AppColors.disabledText
                    : AppColors.textOnPrimary,
              ),
            ],
          );
        } else {
          // Outline: Icon on left per PRD
          content = Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: effectivelyDisabled
                    ? AppColors.disabledText
                    : AppColors.primaryDark,
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(child: textWidget),
            ],
          );
        }
      } else {
        content = textWidget;
      }
    }

    Widget button;
    if (variant == AppButtonVariant.primary) {
      button = ElevatedButton(
        onPressed: effectivelyDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.disabledBackground,
          disabledForegroundColor: AppColors.disabledText,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
          minimumSize: Size(
            isFullWidth ? double.infinity : (width ?? 0),
            height,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
        ),
        child: content,
      );
    } else {
      button = OutlinedButton(
        onPressed: effectivelyDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          disabledForegroundColor: AppColors.disabledText,
          side: BorderSide(
            color: effectivelyDisabled
                ? AppColors.disabledBackground
                : AppColors.border,
            width: 1.5,
          ),
          backgroundColor: AppColors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
          minimumSize: Size(
            isFullWidth ? double.infinity : (width ?? 0),
            height,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
        ),
        child: content,
      );
    }

    if (isFullWidth) {
      return SizedBox(width: double.infinity, height: height, child: button);
    }

    return SizedBox(width: width, height: height, child: button);
  }
}
