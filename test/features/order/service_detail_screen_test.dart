import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundryin/core/theme/app_theme.dart';
import 'package:laundryin/core/widgets/hero_image_header.dart';
import 'package:laundryin/core/widgets/info_stat_box.dart';
import 'package:laundryin/core/widgets/note_callout.dart';
import 'package:laundryin/core/widgets/rating_pill.dart';
import 'package:laundryin/core/widgets/sticky_action_bar.dart';
import 'package:laundryin/features/order/data/fake_order_repository.dart';
import 'package:laundryin/features/order/presentation/order_providers.dart';
import 'package:laundryin/features/order/presentation/service_detail_screen.dart';

void main() {
  Widget buildTestWidget({String serviceId = 'kiloan'}) {
    return ProviderScope(
      overrides: [
        orderRepositoryProvider.overrideWithValue(FakeOrderRepository()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: ServiceDetailScreen(serviceId: serviceId),
      ),
    );
  }

  group('ServiceDetailScreen widget tests', () {
    testWidgets('renders all details for Cuci Kiloan service', (tester) async {
      await tester.pumpWidget(buildTestWidget(serviceId: 'kiloan'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.byType(HeroImageHeader), findsOneWidget);
      expect(find.byType(RatingPill), findsOneWidget);
      expect(find.byType(InfoStatBox), findsOneWidget);
      expect(find.byType(NoteCallout), findsOneWidget);
      expect(find.byType(StickyActionBar), findsOneWidget);

      expect(find.text('LAYANAN KILOAN'), findsOneWidget);
      expect(find.text('Cuci Kiloan'), findsOneWidget);
      expect(find.text('2 Hari Kerja'), findsOneWidget);
      expect(find.text('3 KG'), findsOneWidget);
      expect(find.text('Rp7.000/kg'), findsOneWidget);
      expect(find.text('Pesan Sekarang'), findsOneWidget);
    });

    testWidgets('renders not found state for invalid service id', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(serviceId: 'non-existent-id'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('Layanan tidak ditemukan'), findsOneWidget);
    });

    testWidgets('renders Cuci Selimut and allows selecting benefits', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(serviceId: 'selimut'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('Cuci Selimut'), findsOneWidget);
      expect(find.text('Rp20.000/item'), findsOneWidget);
      expect(find.text('Keunggulan Layanan'), findsOneWidget);
      expect(find.text('Mesin Kapasitas Besar'), findsOneWidget);

      // Initially 4/4 benefits active
      expect(find.textContaining('4/4 aktif'), findsOneWidget);

      // Scroll down to bring BenefitTile into view
      await tester.ensureVisible(find.text('Mesin Kapasitas Besar'));
      await tester.pumpAndSettle();

      // Tap on 'Mesin Kapasitas Besar' to deselect it
      await tester.tap(find.text('Mesin Kapasitas Besar'));
      await tester.pumpAndSettle();

      // Now 3/4 benefits active
      expect(find.textContaining('3/4 aktif'), findsOneWidget);

      // Tap again to re-select
      await tester.tap(find.text('Mesin Kapasitas Besar'));
      await tester.pumpAndSettle();

      expect(find.textContaining('4/4 aktif'), findsOneWidget);
    });
  });
}

