import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundryin/core/router/app_router.dart';
import 'package:laundryin/core/theme/app_theme.dart';
import 'package:laundryin/core/widgets/active_order_card.dart';
import 'package:laundryin/core/widgets/phone_field.dart';
import 'package:laundryin/features/auth/data/fake_auth_repository.dart';
import 'package:laundryin/features/auth/presentation/auth_providers.dart';
import 'package:laundryin/features/order/data/fake_order_repository.dart';
import 'package:laundryin/features/order/presentation/order_providers.dart';

void main() {
  Widget createTestApp({
    FakeAuthRepository? fakeAuth,
    FakeOrderRepository? fakeOrder,
  }) {
    return ProviderScope(
      overrides: [
        if (fakeAuth != null)
          authRepositoryProvider.overrideWithValue(fakeAuth),
        if (fakeOrder != null)
          orderRepositoryProvider.overrideWithValue(fakeOrder),
      ],
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }

  group('Milestone 2 Integration Test: Splash -> Onboarding -> Login -> OTP -> Home -> Detail Layanan', () {
    testWidgets(
      'full flow from splash to detail layanan navigates seamlessly',
      (tester) async {
        final fakeAuth = FakeAuthRepository();
        final fakeOrder = FakeOrderRepository();

        await tester.pumpWidget(
          createTestApp(fakeAuth: fakeAuth, fakeOrder: fakeOrder),
        );

        // 1. Splash Screen
        expect(find.text('Laundryin'), findsWidgets);
        expect(find.text('Cucian bersih, hidup tenang'), findsOneWidget);

        // Advance time for splash timer (1000ms) + async check
        await tester.pump(const Duration(milliseconds: 1200));
        await tester.pumpAndSettle();

        // 2. Onboarding Screen
        expect(find.text('Pesan Dari Rumah'), findsOneWidget);
        expect(find.text('Selanjutnya'), findsOneWidget);

        // Tap Next to slide 2
        await tester.tap(find.text('Selanjutnya'));
        await tester.pumpAndSettle();
        expect(find.text('Dijemput & Diantar'), findsOneWidget);

        // Tap Next to slide 3
        await tester.tap(find.text('Selanjutnya'));
        await tester.pumpAndSettle();
        expect(find.text('Pantau Real-Time'), findsOneWidget);
        expect(find.text('Mulai Sekarang'), findsOneWidget);

        // Tap "Mulai Sekarang" to complete onboarding and go to Login
        await tester.tap(find.text('Mulai Sekarang'));
        await tester.pumpAndSettle();

        // 3. Login Screen
        expect(find.text('Masuk ke Akun Kamu'), findsOneWidget);
        expect(find.text('Kirim Kode OTP'), findsOneWidget);

        // Enter valid phone number
        final phoneInput = find.descendant(
          of: find.byType(PhoneField),
          matching: find.byType(TextField),
        );
        await tester.enterText(phoneInput, '81234567890');
        await tester.pumpAndSettle();

        // Tap "Kirim Kode OTP"
        await tester.tap(find.text('Kirim Kode OTP'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        // 4. OTP Screen
        expect(find.text('Verifikasi Nomor Kamu'), findsOneWidget);
        expect(find.textContaining('+62 8123-****-7890'), findsOneWidget);

        // Enter 6 digit code '123456'
        final otpBoxes = find.byType(TextField);
        for (var i = 0; i < 6; i++) {
          await tester.enterText(otpBoxes.at(i), '${i + 1}');
          await tester.pump();
        }
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        // 5. Home Screen - allow async providers (active order & services) to resolve
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        expect(find.textContaining('Barup!'), findsOneWidget);
        expect(find.text('Alamat Jemput'), findsOneWidget);
        expect(find.text('Pesanan Aktif'), findsWidgets);
        expect(find.byType(ActiveOrderCard), findsOneWidget);
        // Scroll down to bring services section into view
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
        await tester.pumpAndSettle();

        expect(find.text('Layanan Kami'), findsOneWidget);
        expect(find.text('Cuci Kiloan'), findsOneWidget);

        // Tap on 'Cuci Kiloan' service card
        await tester.tap(find.text('Cuci Kiloan'));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pumpAndSettle();

        // 6. Detail Layanan Screen
        expect(find.text('LAYANAN KILOAN'), findsOneWidget);
        expect(find.text('Cuci Kiloan'), findsOneWidget);
        expect(find.text('Estimasi Pengerjaan'), findsOneWidget);
        expect(find.text('2 Hari Kerja'), findsOneWidget);
        expect(find.text('Minimal Pemesanan'), findsOneWidget);
        expect(find.text('3 KG'), findsOneWidget);
        expect(find.text('Keunggulan Layanan'), findsOneWidget);
        expect(find.text('Pesan Sekarang'), findsOneWidget);
        expect(find.text('Rp7.000/kg'), findsOneWidget);

        // Tap "Pesan Sekarang"
        await tester.tap(find.text('Pesan Sekarang'));
        await tester.pump();
        expect(
          find.textContaining('Milestone 4: C-03 Form Pesanan'),
          findsOneWidget,
        );
      },
    );
  });
}
