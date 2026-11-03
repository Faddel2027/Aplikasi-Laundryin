import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../core/widgets/eyebrow_label.dart';
import '../../../core/widgets/phone_field.dart';
import '../../../core/widgets/terms_text.dart';
import '../domain/user_entity.dart';
import 'auth_providers.dart';

/// Login screen with phone number OTP and Google Sign In.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _phoneError;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String val) {
    if (_phoneError != null) {
      setState(() => _phoneError = null);
    }
  }

  Future<void> _submitPhone() async {
    final rawPhone = _phoneController.text.trim();
    final validationError = validatePhoneNumber(rawPhone);

    if (validationError != null) {
      setState(() => _phoneError = validationError);
      return;
    }

    final success = await ref
        .read(authStateProvider.notifier)
        .sendOtp(rawPhone);
    if (!mounted) return;

    if (success) {
      context.push('/otp?phone=$rawPhone');
    } else {
      final error =
          ref.read(authStateProvider).errorMessage ?? 'Gagal mengirim OTP';
      setState(() => _phoneError = error);
    }
  }

  Future<void> _signInWithGoogle() async {
    final success = await ref
        .read(authStateProvider.notifier)
        .signInWithGoogle();
    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      final error =
          ref.read(authStateProvider).errorMessage ??
          'Gagal masuk dengan Google';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    }
  }

  Future<void> _loginAsRole(UserRole role) async {
    final success = await ref
        .read(authStateProvider.notifier)
        .signInAsRole(role);
    if (!mounted) return;

    if (success) {
      switch (role) {
        case UserRole.courier:
          context.go('/courier');
          break;
        case UserRole.cashier:
          context.go('/cashier');
          break;
        case UserRole.admin:
        case UserRole.customer:
          context.go('/home');
          break;
      }
    } else {
      final error =
          ref.read(authStateProvider).errorMessage ?? 'Gagal masuk sebagai peran';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ketentuan Layanan', style: AppTextTheme.h2),
        content: SingleChildScrollView(
          child: Text(
            'Selamat datang di Laundryin.\n\n'
            '1. Layanan antar-jemput beroperasi sesuai slot waktu yang dipilih.\n'
            '2. Timbangan berat pakaian dihitung secara akurat di outlet oleh kasir.\n'
            '3. Pembatalan pesanan hanya diperbolehkan sebelum pakaian dijemput kurir.\n'
            '4. Pembayaran digital dilakukan melalui gateway resmi yang aman.\n\n'
            'Dengan menggunakan Laundryin, kamu setuju dengan seluruh ketentuan di atas.',
            style: AppTextTheme.body.copyWith(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          AppButton.primary(
            text: 'Saya Mengerti',
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Kebijakan Privasi', style: AppTextTheme.h2),
        content: SingleChildScrollView(
          child: Text(
            'Privasi dan keamanan data kamu adalah prioritas kami.\n\n'
            '1. Nomor telepon dan alamat hanya digunakan untuk keperluan penjemputan dan pengantaran cucian.\n'
            '2. Data pesanan dan lokasi terlindungi oleh sistem keamanan berbasis hak akses.\n'
            '3. Kami tidak membagikan informasi pribadimu kepada pihak ketiga tanpa izin.',
            style: AppTextTheme.body.copyWith(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          AppButton.primary(
            text: 'Tutup',
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: AppSpacing.screenPadding,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandMark.small(customSize: 28),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Laundryin',
              style: AppTextTheme.h3.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              const EyebrowLabel(text: 'SELAMAT DATANG'),
              const SizedBox(height: AppSpacing.sm),
              Text('Masuk ke Akun Kamu', style: AppTextTheme.h1),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Masukkan nomor WhatsApp atau HP aktif untuk menerima kode verifikasi cepat.',
                style: AppTextTheme.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // PhoneField
              PhoneField(
                controller: _phoneController,
                errorText: _phoneError,
                onChanged: _onPhoneChanged,
                onSubmitted: (_) => _submitPhone(),
                isDisabled: authState.isLoading,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Send OTP Button
              AppButton.primary(
                text: 'Kirim Kode OTP',
                icon: Icons.arrow_forward_rounded,
                isLoading: authState.isLoading,
                onPressed: _submitPhone,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Divider "atau"
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      'atau',
                      style: AppTextTheme.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Google Sign In Button
              AppButton.outline(
                text: 'Lanjutkan dengan Google',
                icon: Icons.g_mobiledata_rounded,
                isLoading: authState.isLoading,
                onPressed: _signInWithGoogle,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Mock Auth Role Selection Section (PRD M3)
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'PILIH ROLE (MOCK AUTH)',
                      style: AppTextTheme.captionMedium.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Button 1: Customer
              AppButton.outline(
                text: 'Login sebagai Customer',
                icon: Icons.person_rounded,
                isLoading: authState.isLoading,
                onPressed: () => _loginAsRole(UserRole.customer),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Button 2: Courier
              AppButton.outline(
                text: 'Login sebagai Kurir',
                icon: Icons.delivery_dining_rounded,
                isLoading: authState.isLoading,
                onPressed: () => _loginAsRole(UserRole.courier),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Button 3: Cashier
              AppButton.outline(
                text: 'Login sebagai Kasir',
                icon: Icons.point_of_sale_rounded,
                isLoading: authState.isLoading,
                onPressed: () => _loginAsRole(UserRole.cashier),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // Terms & Privacy disclaimer
              Center(
                child: TermsText(
                  onTermsTap: _showTermsDialog,
                  onPrivacyTap: _showPrivacyDialog,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
