import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';
import 'brand_mark.dart';

enum LaundryAppBarVariant { logoWithAction, backWithTitle, floatingBack }

/// Laundryin custom AppBar component.
///
/// Variants:
/// - [LaundryAppBarVariant.logoWithAction]: Brand mark + app name + right action widget.
/// - [LaundryAppBarVariant.backWithTitle]: Back button + screen title + optional actions.
/// - [LaundryAppBarVariant.floatingBack]: Floating circular back button over photos.
class LaundryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final LaundryAppBarVariant variant;
  final String? title;
  final Widget? action;
  final List<Widget>? actions;
  final VoidCallback? onBackTap;
  final VoidCallback? onActionTap;
  final Color? backgroundColor;

  const LaundryAppBar({
    super.key,
    this.variant = LaundryAppBarVariant.logoWithAction,
    this.title,
    this.action,
    this.actions,
    this.onBackTap,
    this.onActionTap,
    this.backgroundColor,
  });

  const LaundryAppBar.logoWithAction({
    super.key,
    this.action,
    this.onActionTap,
    this.backgroundColor,
  }) : variant = LaundryAppBarVariant.logoWithAction,
       title = null,
       actions = null,
       onBackTap = null;

  const LaundryAppBar.backWithTitle({
    super.key,
    required String this.title,
    this.onBackTap,
    this.actions,
    this.backgroundColor,
  }) : variant = LaundryAppBarVariant.backWithTitle,
       action = null,
       onActionTap = null;

  const LaundryAppBar.floatingBack({super.key, this.onBackTap})
    : variant = LaundryAppBarVariant.floatingBack,
      title = null,
      action = null,
      actions = null,
      onActionTap = null,
      backgroundColor = Colors.transparent;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    if (variant == LaundryAppBarVariant.floatingBack) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.sm,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
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
        ),
      );
    }

    if (variant == LaundryAppBarVariant.backWithTitle) {
      return AppBar(
        backgroundColor: backgroundColor ?? AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
          tooltip: 'Kembali',
          onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
        ),
        title: Text(title ?? '', style: AppTextTheme.h3),
        actions: actions,
      );
    }

    // Default logoWithAction
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: AppSpacing.screenPadding,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BrandMark.small(customSize: 32),
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
        if (action != null)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
            child: action!,
          )
        else if (onActionTap != null)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
            child: IconButton(
              icon: const Icon(Icons.help_outline_rounded),
              color: AppColors.textSecondary,
              onPressed: onActionTap,
            ),
          ),
      ],
    );
  }
}
