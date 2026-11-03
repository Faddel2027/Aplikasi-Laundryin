import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';

/// Text link component with default, pressed, and disabled states.
class AppTextLink extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isDisabled;
  final TextStyle? style;
  final IconData? icon;

  const AppTextLink({
    super.key,
    required this.text,
    this.onTap,
    this.isDisabled = false,
    this.style,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isDisabled
        ? AppColors.disabledText
        : AppColors.primary;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.minTouchTarget,
        minWidth: AppSpacing.minTouchTarget,
      ),
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: (style ?? AppTextTheme.bodyMedium).copyWith(
                  color: effectiveColor,
                  fontWeight: FontWeight.w600,
                  decoration: isDisabled
                      ? TextDecoration.none
                      : TextDecoration.underline,
                  decorationColor: effectiveColor,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: AppSpacing.xs),
                Icon(icon, size: 16, color: effectiveColor),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
