import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';
import '../utils/format_rupiah.dart';
import 'app_button.dart';

/// Bottom sticky action bar with price information and primary call-to-action button.
class StickyActionBar extends StatelessWidget {
  final int? price;
  final String? priceLabel;
  final String? customPriceText;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? buttonIcon;

  const StickyActionBar({
    super.key,
    this.price,
    this.priceLabel = 'Total Estimasi',
    this.customPriceText,
    required this.buttonText,
    this.onButtonPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    final displayPrice =
        customPriceText ?? (price != null ? formatRupiah(price!) : null);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1.0)),
        boxShadow: AppShadows.topBar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              if (displayPrice != null) ...[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (priceLabel != null)
                      Text(
                        priceLabel!,
                        style: AppTextTheme.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      displayPrice,
                      style: AppTextTheme.h3.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.lg),
              ],
              Expanded(
                child: AppButton.primary(
                  text: buttonText,
                  onPressed: onButtonPressed,
                  isLoading: isLoading,
                  isDisabled: isDisabled,
                  icon: buttonIcon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
