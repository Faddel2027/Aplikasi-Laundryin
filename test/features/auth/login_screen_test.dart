import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundryin/core/theme/app_theme.dart';
import 'package:laundryin/core/widgets/phone_field.dart';
import 'package:laundryin/features/auth/presentation/login_screen.dart';

void main() {
  Widget buildTestWidget() {
    return ProviderScope(
      child: MaterialApp(theme: AppTheme.lightTheme, home: const LoginScreen()),
    );
  }

  group('LoginScreen widget tests', () {
    testWidgets('renders all visual elements according to PRD', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('SELAMAT DATANG'), findsOneWidget);
      expect(find.text('Masuk ke Akun Kamu'), findsOneWidget);
      expect(find.byType(PhoneField), findsOneWidget);
      expect(find.text('Kirim Kode OTP'), findsOneWidget);
      expect(find.text('Lanjutkan dengan Google'), findsOneWidget);
      expect(find.text('Login sebagai Customer'), findsOneWidget);
      expect(find.text('Login sebagai Kurir'), findsOneWidget);
      expect(find.text('Login sebagai Kasir'), findsOneWidget);
      expect(find.textContaining('Ketentuan Layanan'), findsOneWidget);
    });

    testWidgets('validates phone number before submitting', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap without typing phone
      await tester.tap(find.text('Kirim Kode OTP'));
      await tester.pumpAndSettle();

      expect(find.text('Nomor telepon tidak boleh kosong'), findsOneWidget);

      // Enter short number
      final phoneInput = find.descendant(
        of: find.byType(PhoneField),
        matching: find.byType(TextField),
      );
      await tester.enterText(phoneInput, '1234');
      await tester.tap(find.text('Kirim Kode OTP'));
      await tester.pumpAndSettle();

      expect(find.text('Nomor telepon minimal 9 digit'), findsOneWidget);
    });
  });
}
