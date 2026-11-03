import 'package:flutter/material.dart';

/// Design tokens for Laundryin color palette as defined in docs/PRD.md (section 3.1).
/// All colors must be accessed from this class or Theme.of(context).
class AppColors {
  const AppColors._();

  // Primary palette
  static const Color primary = Color(0xFF0EA5E9);
  static const Color primaryDark = Color(0xFF0369A1);
  static const Color primaryLight = Color(0xFFE0F2FE);

  // Accent
  static const Color accent = Color(0xFF14B8A6);
  static const Color accentLight = Color(0xFFCCFBF1);
  static const Color accentDark = Color(0xFF0F766E);

  // Neutral & Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFF1F5F9);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Semantic & Feedback
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0EA5E9);
  static const Color infoLight = Color(0xFFE0F2FE);

  // Tints & Pastels (Service cards, status badges, illustration backgrounds)
  static const Color tintBlue = Color(0xFFE0F2FE);
  static const Color tintPurple = Color(0xFFF3E8FF);
  static const Color tintAmber = Color(0xFFFEF3C7);
  static const Color tintTosca = Color(0xFFCCFBF1);
  static const Color tintGreen = Color(0xFFDCFCE7);
  static const Color tintRose = Color(0xFFFFE4E6);

  // Disabled states
  static const Color disabledBackground = Color(0xFFE2E8F0);
  static const Color disabledText = Color(0xFF94A3B8);
}
