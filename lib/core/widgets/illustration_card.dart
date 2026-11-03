import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

enum IllustrationCardTheme { blue, tosca, purple }

/// Card container for onboarding and feature illustrations.
///
/// Themes:
/// - [IllustrationCardTheme.blue]
/// - [IllustrationCardTheme.tosca]
/// - [IllustrationCardTheme.purple]
class IllustrationCard extends StatelessWidget {
  final IllustrationCardTheme theme;
  final Widget? child;
  final IconData? icon;
  final double height;
  final double? width;

  const IllustrationCard({
    super.key,
    this.theme = IllustrationCardTheme.blue,
    this.child,
    this.icon,
    this.height = 240,
    this.width,
  });

  Color _getBackgroundColor() {
    switch (theme) {
      case IllustrationCardTheme.blue:
        return AppColors.tintBlue;
      case IllustrationCardTheme.tosca:
        return AppColors.tintTosca;
      case IllustrationCardTheme.purple:
        return AppColors.tintPurple;
    }
  }

  Color _getAccentColor() {
    switch (theme) {
      case IllustrationCardTheme.blue:
        return AppColors.primary;
      case IllustrationCardTheme.tosca:
        return AppColors.accent;
      case IllustrationCardTheme.purple:
        return const Color(0xFF9333EA);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor();
    final accentColor = _getAccentColor();

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.cardRadius,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient soft background circles for aesthetic appeal
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.12),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.1),
                ),
              ),
            ),
            if (child != null)
              child!
            else if (icon != null)
              Icon(icon, size: 84, color: accentColor)
            else
              Icon(
                Icons.local_laundry_service_rounded,
                size: 84,
                color: accentColor,
              ),
          ],
        ),
      ),
    );
  }
}
