import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';

enum LocationSelectorState { selected, noAddress, loading }

/// Location selector widget in Home header.
///
/// States:
/// - [LocationSelectorState.selected]: Displays address label and address preview with dropdown chevron.
/// - [LocationSelectorState.noAddress]: Prompts user to add an address.
/// - [LocationSelectorState.loading]: Displays compact loading state.
class LocationSelector extends StatelessWidget {
  final LocationSelectorState state;
  final String? label;
  final String? address;
  final VoidCallback? onTap;

  const LocationSelector({
    super.key,
    this.state = LocationSelectorState.selected,
    this.label,
    this.address,
    this.onTap,
  });

  const LocationSelector.selected({
    super.key,
    required String this.label,
    required String this.address,
    this.onTap,
  }) : state = LocationSelectorState.selected;

  const LocationSelector.noAddress({super.key, this.onTap})
    : state = LocationSelectorState.noAddress,
      label = null,
      address = null;

  const LocationSelector.loading({super.key})
    : state = LocationSelectorState.loading,
      label = null,
      address = null,
      onTap = null;

  @override
  Widget build(BuildContext context) {
    if (state == LocationSelectorState.loading) {
      return Container(
        height: 38,
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppRadius.pillRadius,
        ),
      );
    }

    if (state == LocationSelectorState.noAddress) {
      return InkWell(
        onTap: onTap,
        borderRadius: AppRadius.pillRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: AppRadius.pillRadius,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_location_alt_outlined,
                size: 16,
                color: AppColors.primaryDark,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Tambah Alamat',
                style: AppTextTheme.captionMedium.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              const Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: AppColors.primaryDark,
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.location_on_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label ?? 'Alamat Jemput',
                        style: AppTextTheme.captionMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  Text(
                    address ?? 'Pilih alamat pengiriman',
                    style: AppTextTheme.caption.copyWith(
                      color: AppColors.textSecondary,
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
    );
  }
}
