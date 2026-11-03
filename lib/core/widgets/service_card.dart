import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';
import '../utils/format_rupiah.dart';

enum ServicePastelColor { blue, purple, amber, tosca, green, rose }

/// Service card for 3x2 grid on Home screen.
///
/// Variants:
/// - 6 pastel tint color themes.
/// - States: default, pressed, inactive.
class ServiceCard extends StatelessWidget {
  final String title;
  final int startingPrice;
  final String unit;
  final IconData icon;
  final ServicePastelColor colorTheme;
  final String? badge;
  final bool isInactive;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.title,
    required this.startingPrice,
    required this.unit,
    required this.icon,
    this.colorTheme = ServicePastelColor.blue,
    this.badge,
    this.isInactive = false,
    this.onTap,
  });

  Color _getBackgroundColor() {
    if (isInactive) return AppColors.surfaceVariant;
    switch (colorTheme) {
      case ServicePastelColor.blue:
        return AppColors.tintBlue;
      case ServicePastelColor.purple:
        return AppColors.tintPurple;
      case ServicePastelColor.amber:
        return AppColors.tintAmber;
      case ServicePastelColor.tosca:
        return AppColors.tintTosca;
      case ServicePastelColor.green:
        return AppColors.tintGreen;
      case ServicePastelColor.rose:
        return AppColors.tintRose;
    }
  }

  Color _getAccentColor() {
    if (isInactive) return AppColors.disabledText;
    switch (colorTheme) {
      case ServicePastelColor.blue:
        return AppColors.primary;
      case ServicePastelColor.purple:
        return const Color(0xFF9333EA);
      case ServicePastelColor.amber:
        return const Color(0xFFD97706);
      case ServicePastelColor.tosca:
        return AppColors.accent;
      case ServicePastelColor.green:
        return const Color(0xFF16A34A);
      case ServicePastelColor.rose:
        return const Color(0xFFE11D48);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor();
    final accentColor = _getAccentColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isInactive ? null : onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(
              color: isInactive
                  ? AppColors.disabledBackground
                  : AppColors.border,
              width: 1.0,
            ),
            boxShadow: isInactive ? null : AppShadows.card,
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(icon, size: 24, color: accentColor),
                    ),
                  ),
                  if (badge != null && !isInactive)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: AppRadius.pillRadius,
                        ),
                        child: Text(
                          badge!,
                          style: AppTextTheme.caption.copyWith(
                            color: AppColors.error,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  else if (isInactive)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.disabledBackground,
                          borderRadius: AppRadius.pillRadius,
                        ),
                        child: Text(
                          'Segera',
                          style: AppTextTheme.caption.copyWith(
                            color: AppColors.disabledText,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isInactive
                          ? AppColors.disabledText
                          : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Mulai ${formatRupiah(startingPrice, compact: true)}/$unit',
                    style: AppTextTheme.caption.copyWith(
                      color: isInactive
                          ? AppColors.disabledText
                          : AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
