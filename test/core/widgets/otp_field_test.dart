import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundryin/core/theme/app_theme.dart';
import 'package:laundryin/core/widgets/otp_field.dart';

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

  group('OtpField widget tests', () {
    testWidgets('renders 6 text fields by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OtpField()));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets(
      'typing digits advances through fields and triggers onCompleted',
      (tester) async {
        String currentOtp = '';
        String completedOtp = '';

        await tester.pumpWidget(
          buildTestWidget(
            OtpField(
              onChanged: (val) => currentOtp = val,
              onCompleted: (val) => completedOtp = val,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textFields = find.byType(TextField);

        // Enter digits sequentially
        await tester.enterText(textFields.at(0), '1');
        await tester.pumpAndSettle();
        expect(currentOtp, equals('1'));

        await tester.enterText(textFields.at(1), '2');
        await tester.pumpAndSettle();
        expect(currentOtp, equals('12'));

        await tester.enterText(textFields.at(2), '3');
        await tester.pumpAndSettle();
        expect(currentOtp, equals('123'));

        await tester.enterText(textFields.at(3), '4');
        await tester.pumpAndSettle();
        expect(currentOtp, equals('1234'));

        await tester.enterText(textFields.at(4), '5');
        await tester.pumpAndSettle();
        expect(currentOtp, equals('12345'));

        await tester.enterText(textFields.at(5), '6');
        await tester.pumpAndSettle();
        expect(currentOtp, equals('123456'));
        expect(completedOtp, equals('123456'));
      },
    );

    testWidgets('paste of 6 digits fills all boxes and triggers onCompleted', (
      tester,
    ) async {
      String completedOtp = '';

      await tester.pumpWidget(
        buildTestWidget(OtpField(onCompleted: (val) => completedOtp = val)),
      );
      await tester.pumpAndSettle();

      final firstField = find.byType(TextField).first;
      await tester.enterText(firstField, '987654');
      await tester.pumpAndSettle();

      expect(completedOtp, equals('987654'));
      expect(find.text('9'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('backspace on empty box clears previous box', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OtpField()));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);

      // Enter digit in first field
      await tester.enterText(textFields.at(0), '5');
      await tester.pumpAndSettle();
      expect(find.text('5'), findsOneWidget);

      // Trigger backspace on second field via sendKeyEvent
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pumpAndSettle();

      // First field should now be cleared
      expect(find.text('5'), findsNothing);
    });

    testWidgets('renders error state properly', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OtpField(hasError: true)));
      await tester.pumpAndSettle();

      expect(find.byType(OtpField), findsOneWidget);
    });
  });
}
