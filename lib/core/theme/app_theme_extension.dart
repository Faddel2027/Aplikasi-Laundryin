import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_gradients.dart';
import 'app_shadows.dart';

/// Custom theme extension for brand-specific tints, shadows, and gradients.
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color tintBlue;
  final Color tintPurple;
  final Color tintAmber;
  final Color tintTosca;
  final Color tintGreen;
  final Color tintRose;
  final List<BoxShadow> softShadow;
  final LinearGradient brandGradient;
  final LinearGradient brandHeroGradient;
  final LinearGradient promoBannerGradient;

  const AppThemeExtension({
    this.tintBlue = AppColors.tintBlue,
    this.tintPurple = AppColors.tintPurple,
    this.tintAmber = AppColors.tintAmber,
    this.tintTosca = AppColors.tintTosca,
    this.tintGreen = AppColors.tintGreen,
    this.tintRose = AppColors.tintRose,
    this.softShadow = AppShadows.soft,
    this.brandGradient = AppGradients.brand,
    this.brandHeroGradient = AppGradients.brandHero,
    this.promoBannerGradient = AppGradients.promoBanner,
  });

  @override
  AppThemeExtension copyWith({
    Color? tintBlue,
    Color? tintPurple,
    Color? tintAmber,
    Color? tintTosca,
    Color? tintGreen,
    Color? tintRose,
    List<BoxShadow>? softShadow,
    LinearGradient? brandGradient,
    LinearGradient? brandHeroGradient,
    LinearGradient? promoBannerGradient,
  }) {
    return AppThemeExtension(
      tintBlue: tintBlue ?? this.tintBlue,
      tintPurple: tintPurple ?? this.tintPurple,
      tintAmber: tintAmber ?? this.tintAmber,
      tintTosca: tintTosca ?? this.tintTosca,
      tintGreen: tintGreen ?? this.tintGreen,
      tintRose: tintRose ?? this.tintRose,
      softShadow: softShadow ?? this.softShadow,
      brandGradient: brandGradient ?? this.brandGradient,
      brandHeroGradient: brandHeroGradient ?? this.brandHeroGradient,
      promoBannerGradient: promoBannerGradient ?? this.promoBannerGradient,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      tintBlue: Color.lerp(tintBlue, other.tintBlue, t) ?? tintBlue,
      tintPurple: Color.lerp(tintPurple, other.tintPurple, t) ?? tintPurple,
      tintAmber: Color.lerp(tintAmber, other.tintAmber, t) ?? tintAmber,
      tintTosca: Color.lerp(tintTosca, other.tintTosca, t) ?? tintTosca,
      tintGreen: Color.lerp(tintGreen, other.tintGreen, t) ?? tintGreen,
      tintRose: Color.lerp(tintRose, other.tintRose, t) ?? tintRose,
      softShadow: t < 0.5 ? softShadow : other.softShadow,
      brandGradient: t < 0.5 ? brandGradient : other.brandGradient,
      brandHeroGradient: t < 0.5 ? brandHeroGradient : other.brandHeroGradient,
      promoBannerGradient: t < 0.5
          ? promoBannerGradient
          : other.promoBannerGradient,
    );
  }
}

/// Convenience extensions on BuildContext to access theme tokens.
extension AppThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>() ??
      const AppThemeExtension();
}
