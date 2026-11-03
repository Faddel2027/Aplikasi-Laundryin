import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundryin/core/theme/app_theme.dart';
import 'package:laundryin/features/auth/presentation/complete_profile_screen.dart';

void main() {
  Widget buildTestWidget() {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const CompleteProfileScreen(),
      ),
    );
  }

  group('Milestone 3: CompleteProfileScreen (C-14, P0)', () {
    testWidgets('renders all visual elements and fields according to PRD', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('LANGKAH TERAKHIR'), findsOneWidget);
      expect(find.text('Data Diri Kamu'), findsOneWidget);
      expect(find.textContaining('Nama Lengkap'), findsOneWidget);
      expect(find.textContaining('Email (Opsional)'), findsOneWidget);
      expect(find.textContaining('Alamat Utama'), findsOneWidget);
      expect(find.text('Simpan Profil & Lanjutkan'), findsOneWidget);
    });

    testWidgets('validates full name minimum length before submitting', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final submitBtn = find.text('Simpan Profil & Lanjutkan');
      await tester.ensureVisible(submitBtn);
      await tester.pumpAndSettle();

      // Submit with empty name
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.text('Nama lengkap minimal 3 karakter'), findsOneWidget);

      // Enter short name (2 characters)
      final nameField = find.byType(TextField).first;
      await tester.enterText(nameField, 'Ab');
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.text('Nama lengkap minimal 3 karakter'), findsOneWidget);
    });
  });
}
