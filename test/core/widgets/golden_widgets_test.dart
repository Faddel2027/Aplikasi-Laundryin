import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundryin/core/theme/app_theme.dart';
import 'package:laundryin/core/widgets/widgets.dart';

void main() {
  Widget buildTestWrapper(Widget child, {double width = 390}) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            width: width,
            child: Padding(padding: const EdgeInsets.all(16.0), child: child),
          ),
        ),
      ),
    );
  }

  group('Golden tests for key core widget variants', () {
    testWidgets('BrandMark variants golden test', (tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BrandMark.large(),
              BrandMark.small(),
              BrandMark.small(customSize: 28),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/brand_mark_variants.png'),
      );
    });

    testWidgets('AppButton variants golden test', (tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton.primary(
                text: 'Pesan Sekarang',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              const AppButton.primary(text: 'Loading Button', isLoading: true),
              const SizedBox(height: 12),
              const AppButton.primary(
                text: 'Disabled Button',
                isDisabled: true,
              ),
              const SizedBox(height: 12),
              AppButton.outline(
                text: 'Pilih Outlet Lain',
                icon: Icons.storefront_rounded,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/app_button_variants.png'),
      );
    });

    testWidgets('StatusChip variants golden test', (tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: OrderStatus.values
                .map((s) => StatusChip(status: s))
                .toList(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/status_chip_variants.png'),
      );
    });

    testWidgets('StageProgress variants golden test', (tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StageProgress(
                currentStage: 1,
                activeStatusLabel: 'Dijemput Kurir',
              ),
              SizedBox(height: 20),
              StageProgress(
                currentStage: 2,
                activeStatusLabel: 'Sedang Dicuci',
              ),
              SizedBox(height: 20),
              StageProgress(
                currentStage: 3,
                activeStatusLabel: 'Dalam Pengantaran',
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/stage_progress_variants.png'),
      );
    });

    testWidgets('NoteCallout variants golden test', (tester) async {
      await tester.pumpWidget(
        buildTestWrapper(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NoteCallout.info(
                title: 'Informasi Penimbangan',
                message: 'Berat final ditentukan kasir.',
              ),
              SizedBox(height: 12),
              NoteCallout.warning(
                title: 'Perhatian Khusus',
                message: 'Pakaian luntur pisahkan.',
              ),
              SizedBox(height: 12),
              NoteCallout.error(
                title: 'Gagal Memproses',
                message: 'Jaringan terputus.',
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/note_callout_variants.png'),
      );
    });
  });
}
