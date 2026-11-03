import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundryin/main.dart';

void main() {
  testWidgets('LaundryinApp smoke test mounts successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: LaundryinApp()));
    // Splash renders immediately with gradient and brand text
    await tester.pump(const Duration(milliseconds: 50));

    // The app should show the Laundryin brand on the splash screen
    expect(find.text('Laundryin'), findsWidgets);
    expect(find.text('Cucian bersih, hidup tenang'), findsOneWidget);

    // Let the splash navigation timer complete and navigate to onboarding
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();
  });
}
