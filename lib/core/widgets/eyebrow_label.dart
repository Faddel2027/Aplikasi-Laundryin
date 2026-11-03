import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_theme.dart';

/// Small all-caps eyebrow label (e.g., 'SELAMAT DATANG', 'DETAIL LAYANAN').
class EyebrowLabel extends StatelessWidget {
  final String text;
  final Color? color;

  const EyebrowLabel({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextTheme.eyebrow.copyWith(
        color: color ?? AppColors.primaryDark,
      ),
    );
  }
}
