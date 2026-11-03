import 'package:flutter/material.dart';

/// Shadow tokens as defined in docs/PRD.md (section 3.1).
/// `shadow.soft` is a soft blue shadow (blur 16–24).
class AppShadows {
  const AppShadows._();

  /// Soft blue shadow (blur 20, 8% primary dark tint)
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x140369A1),
      blurRadius: 20,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Elevated card shadow
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F0F172A),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Floating button or top sticky shadow
  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x1A0369A1),
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// Bottom nav or sticky bar top shadow
  static const List<BoxShadow> topBar = [
    BoxShadow(
      color: Color(0x0D0F172A),
      blurRadius: 16,
      offset: Offset(0, -4),
      spreadRadius: 0,
    ),
  ];
}
