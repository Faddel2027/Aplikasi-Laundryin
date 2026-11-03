/// Spacing tokens based on 8pt grid as defined in docs/PRD.md (section 3.1).
class AppSpacing {
  const AppSpacing._();

  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double screenPadding = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;
  static const double huge = 48.0;

  /// Header safe area offset below status bar
  static const double statusBarSafe = 54.0;

  /// Standard bottom navigation bar height
  static const double bottomNavHeight = 72.0;

  /// Minimum accessible touch target per WCAG AA guidelines
  static const double minTouchTarget = 48.0;
}
