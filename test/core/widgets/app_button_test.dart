import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundryin/core/theme/app_theme.dart';
import 'package:laundryin/core/widgets/app_button.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Center(
          child: Padding(padding: const EdgeInsets.all(16.0), child: child),
        ),
      ),
    );
  }

  group('AppButton widget tests', () {
    testWidgets('calls onPressed when tapped in normal state', (tester) async {
      var tapCount = 0;
      await tester.pumpWidget(
        buildTestWidget(
          AppButton.primary(text: 'Klik Saya', onPressed: () => tapCount++),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Klik Saya'), findsOneWidget);
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(tapCount, equals(1));
    });

    testWidgets(
      'loading state renders CircularProgressIndicator and ignores taps',
      (tester) async {
        var tapCount = 0;
        await tester.pumpWidget(
          buildTestWidget(
            AppButton.primary(
              text: 'Simpan',
              isLoading: true,
              onPressed: () => tapCount++,
            ),
          ),
        );
        await tester.pump();

        // Progress indicator should be visible
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        // Original text should not be shown while loading
        expect(find.text('Simpan'), findsNothing);

        // Attempt tapping the button
        await tester.tap(find.byType(AppButton));
        await tester.pump();

        // Tap count must remain 0
        expect(tapCount, equals(0));
      },
    );

    testWidgets('disabled state ignores taps and dims', (tester) async {
      var tapCount = 0;
      await tester.pumpWidget(
        buildTestWidget(
          AppButton.primary(
            text: 'Disabled Button',
            isDisabled: true,
            onPressed: () => tapCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(tapCount, equals(0));
    });

    testWidgets('outline variant renders OutlinedButton with icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          AppButton.outline(
            text: 'Kembali',
            icon: Icons.arrow_back,
            onPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('Kembali'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
