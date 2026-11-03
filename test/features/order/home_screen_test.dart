import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundryin/core/theme/app_theme.dart';
import 'package:laundryin/core/widgets/active_order_card.dart';
import 'package:laundryin/core/widgets/app_search_bar.dart';
import 'package:laundryin/core/widgets/laundry_bottom_nav.dart';
import 'package:laundryin/core/widgets/service_card.dart';
import 'package:laundryin/features/order/data/fake_order_repository.dart';
import 'package:laundryin/features/order/presentation/home_screen.dart';
import 'package:laundryin/features/order/presentation/order_providers.dart';

void main() {
  Widget buildTestWidget() {
    return ProviderScope(
      overrides: [
        orderRepositoryProvider.overrideWithValue(FakeOrderRepository()),
      ],
      child: MaterialApp(theme: AppTheme.lightTheme, home: const HomeScreen()),
    );
  }

  group('HomeScreen widget tests', () {
    testWidgets('renders header, promo banner, services, and bottom nav', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      // While loading
      await tester.pump(const Duration(milliseconds: 100));

      // After settling (FutureProvider resolves)
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Header elements always visible
      expect(find.textContaining('Barup!'), findsOneWidget);
      expect(find.byType(AppSearchBar), findsOneWidget);
      expect(find.byType(LaundryBottomNav), findsOneWidget);

      // Active order card should appear (data is preloaded in fake repo)
      expect(find.byType(ActiveOrderCard), findsOneWidget);

      // Services are in SliverGrid — some may be offstage; use skipOffstage: false
      expect(
        find.text('Cuci Kiloan', skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.text('Cuci Satuan', skipOffstage: false),
        findsOneWidget,
      );
      expect(find.byType(ServiceCard, skipOffstage: false), findsWidgets);
    });

    testWidgets('search bar filters service cards', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      final searchField = find.descendant(
        of: find.byType(AppSearchBar),
        matching: find.byType(TextField),
      );

      // Search for "Sepatu"
      await tester.enterText(searchField, 'Sepatu');
      await tester.pumpAndSettle();

      // After filtering, only Cuci Sepatu should remain
      expect(
        find.text('Cuci Sepatu', skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.text('Cuci Kiloan', skipOffstage: false),
        findsNothing,
      );
    });
  });
}
