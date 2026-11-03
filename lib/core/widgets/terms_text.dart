import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_theme.dart';

/// Terms of service and privacy policy disclaimer text with two clickable links.
class TermsText extends StatelessWidget {
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;
  final TextAlign textAlign;

  const TermsText({
    super.key,
    this.onTermsTap,
    this.onPrivacyTap,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Dengan melanjutkan, kamu menyetujui ',
        style: AppTextTheme.caption.copyWith(color: AppColors.textSecondary),
        children: [
          TextSpan(
            text: 'Ketentuan Layanan',
            style: AppTextTheme.captionMedium.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTermsTap,
          ),
          const TextSpan(text: ' dan '),
          TextSpan(
            text: 'Kebijakan Privasi',
            style: AppTextTheme.captionMedium.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onPrivacyTap,
          ),
          const TextSpan(text: ' Laundryin.'),
        ],
      ),
      textAlign: textAlign,
    );
  }
}
