import 'package:flutter/material.dart';

/// Border radius tokens as defined in docs/PRD.md (section 3.1).
class AppRadius {
  const AppRadius._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double input = 12.0;
  static const double button = 12.0;
  static const double card = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double pill = 999.0;

  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(button),
  );
  static const BorderRadius inputRadius = BorderRadius.all(
    Radius.circular(input),
  );
  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(card),
  );
  static const BorderRadius pillRadius = BorderRadius.all(
    Radius.circular(pill),
  );
}
