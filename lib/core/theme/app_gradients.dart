import 'package:flutter/material.dart';

/// Design tokens for Laundryin gradients as defined in docs/PRD.md (section 3.1).
class AppGradients {
  const AppGradients._();

  /// Brand gradient (#38BDF8 -> #0369A1)
  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF38BDF8), Color(0xFF0369A1)],
  );

  /// Vertical hero gradient for splash or hero headers
  static const LinearGradient brandHero = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0EA5E9), Color(0xFF0369A1)],
  );

  /// Promo banner card gradient
  static const LinearGradient promoBanner = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
  );

  /// Subtle dark overlay for hero image readable text
  static const LinearGradient darkOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xB30F172A)],
  );
}
