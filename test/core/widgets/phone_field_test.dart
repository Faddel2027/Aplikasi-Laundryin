import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundryin/core/theme/app_theme.dart';
import 'package:laundryin/core/widgets/phone_field.dart';

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

  group('validatePhoneNumber logic tests', () {
    test('returns error for empty string or null', () {
      expect(
        validatePhoneNumber(null),
        equals('Nomor telepon tidak boleh kosong'),
      );
      expect(
        validatePhoneNumber(''),
        equals('Nomor telepon tidak boleh kosong'),
      );
      expect(
        validatePhoneNumber('   '),
        equals('Nomor telepon tidak boleh kosong'),
      );
    });

    test('returns error for non-digit characters', () {
      expect(
        validatePhoneNumber('812abc456'),
        equals('Hanya boleh berisi angka'),
      );
    });

    test('returns error when length is less than 9 digits', () {
      expect(
        validatePhoneNumber('81234567'),
        equals('Nomor telepon minimal 9 digit'),
      );
    });

    test('returns error when length is greater than 13 digits', () {
      expect(
        validatePhoneNumber('81234567890123'),
        equals('Nomor telepon maksimal 13 digit'),
      );
    });

    test(
      'accepts valid Indonesian phone numbers with or without leading zero',
      () {
        expect(validatePhoneNumber('81234567890'), isNull);
        expect(validatePhoneNumber('081234567890'), isNull);
        expect(validatePhoneNumber('812 3456 7890'), isNull);
        expect(validatePhoneNumber('812-3456-7890'), isNull);
      },
    );
  });

  group('PhoneField widget interaction tests', () {
    testWidgets('renders prefix +62 and text field', (tester) async {
      await tester.pumpWidget(buildTestWidget(const PhoneField()));
      await tester.pumpAndSettle();

      expect(find.text('+62'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('entering text updates controller and triggers onChanged', (
      tester,
    ) async {
      String changedValue = '';
      await tester.pumpWidget(
        buildTestWidget(PhoneField(onChanged: (val) => changedValue = val)),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '8123456789');
      await tester.pumpAndSettle();

      expect(changedValue, equals('8123456789'));
      expect(find.byIcon(Icons.cancel_rounded), findsOneWidget);

      // Tap clear button
      await tester.tap(find.byIcon(Icons.cancel_rounded));
      await tester.pumpAndSettle();

      expect(changedValue, equals(''));
      expect(find.text('8123456789'), findsNothing);
    });

    testWidgets('displays error text when provided', (tester) async {
      const errorMsg = 'Nomor telepon tidak valid';
      await tester.pumpWidget(
        buildTestWidget(const PhoneField(errorText: errorMsg)),
      );
      await tester.pumpAndSettle();

      expect(find.text(errorMsg), findsOneWidget);
    });

    testWidgets('does not allow typing when disabled', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const PhoneField(isDisabled: true)),
      );
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });
  });
}
