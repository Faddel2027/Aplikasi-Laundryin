import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';

enum BrandMarkVariant { large, small }

/// Laundryin brand mark logo component.
///
/// Variants:
/// - [BrandMarkVariant.large]: White icon inside gradient container with soft shadow.
/// - [BrandMarkVariant.small]: Compact gradient icon mark.
class BrandMark extends StatelessWidget {
  final BrandMarkVariant variant;
  final double? customSize;

  const BrandMark({
    super.key,
    this.variant = BrandMarkVariant.small,
    this.customSize,
  });

  const BrandMark.large({super.key, this.customSize})
    : variant = BrandMarkVariant.large;

  const BrandMark.small({super.key, this.customSize})
    : variant = BrandMarkVariant.small;

  @override
  Widget build(BuildContext context) {
    if (variant == BrandMarkVariant.large) {
      final size = customSize ?? 80.0;
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          gradient: AppGradients.brand,
          borderRadius: AppRadius.cardRadius,
          boxShadow: AppShadows.soft,
        ),
        child: Center(
          child: Icon(
            Icons.local_laundry_service_rounded,
            size: size * 0.55,
            color: AppColors.surface,
          ),
        ),
      );
    }

    final size = customSize ?? 40.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppGradients.brand,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Center(
        child: Icon(
          Icons.local_laundry_service_rounded,
          size: size * 0.55,
          color: AppColors.surface,
        ),
      ),
    );
  }
}
