import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_link.dart';
import '../../../core/widgets/laundry_app_bar.dart';
import '../../../core/widgets/otp_field.dart';
import 'auth_providers.dart';

/// OTP Verification screen with auto-submit, 60s countdown timer, and masked phone display.
class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String _enteredOtp = '';
  String? _errorMessage;
  int _secondsRemaining = 60;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    setState(() => _secondsRemaining = 60);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _maskPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length < 8) return '+62 $phone';
    final prefix = cleaned.substring(0, cleaned.length >= 4 ? 4 : 2);
    final suffix = cleaned.substring(cleaned.length - 4);
    return '+62 $prefix-****-$suffix';
  }

  Future<void> _verifyOtp(String code) async {
    setState(() => _errorMessage = null);

    final success = await ref
        .read(authStateProvider.notifier)
        .verifyOtp(widget.phoneNumber, code);

    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      final error =
          ref.read(authStateProvider).errorMessage ?? 'Kode verifikasi salah';
      setState(() => _errorMessage = error);
    }
  }

  Future<void> _resendCode() async {
    if (_secondsRemaining > 0) return;

    final success = await ref
        .read(authStateProvider.notifier)
        .sendOtp(widget.phoneNumber);
    if (!mounted) return;

    if (success) {
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode OTP baru telah dikirim! (Gunakan 123456)'),
          backgroundColor: AppColors.primaryDark,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const LaundryAppBar.backWithTitle(title: 'Verifikasi Nomor'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_person_rounded,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Text(
                  'Verifikasi Nomor Kamu',
                  style: AppTextTheme.h1,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Center(
                child: Text(
                  'Masukkan 6 digit kode yang dikirim ke ${_maskPhoneNumber(widget.phoneNumber)}',
                  style: AppTextTheme.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // OtpField
              OtpField(
                length: 6,
                hasError: _errorMessage != null,
                isDisabled: authState.isLoading,
                onChanged: (val) {
                  _enteredOtp = val;
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
                onCompleted: (val) {
                  _enteredOtp = val;
                  _verifyOtp(val);
                },
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: Text(
                    _errorMessage!,
                    style: AppTextTheme.captionMedium.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.xxl),

              // Verify Button
              AppButton.primary(
                text: 'Verifikasi',
                isLoading: authState.isLoading,
                isDisabled: _enteredOtp.length < 6,
                onPressed: () => _verifyOtp(_enteredOtp),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Resend Timer & Link
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tidak menerima kode? ',
                      style: AppTextTheme.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (_secondsRemaining > 0)
                      Text(
                        'Kirim ulang (${_secondsRemaining}d)',
                        style: AppTextTheme.captionMedium.copyWith(
                          color: AppColors.disabledText,
                        ),
                      )
                    else
                      AppTextLink(text: 'Kirim Ulang', onTap: _resendCode),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
