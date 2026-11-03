import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/utils/format_rupiah.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/benefit_tile.dart';
import '../../../core/widgets/eyebrow_label.dart';
import '../../../core/widgets/hero_image_header.dart';
import '../../../core/widgets/info_stat_box.dart';
import '../../../core/widgets/note_callout.dart';
import '../../../core/widgets/rating_pill.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/sticky_action_bar.dart';
import 'order_providers.dart';

/// Screen displaying full details, benefits, pricing, and terms for a selected service.
class ServiceDetailScreen extends ConsumerStatefulWidget {
  final String serviceId;

  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  ConsumerState<ServiceDetailScreen> createState() =>
      _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends ConsumerState<ServiceDetailScreen> {
  final Set<String> _selectedBenefits = {};
  bool _isBenefitsInitialized = false;

  @override
  Widget build(BuildContext context) {
    final serviceAsync = ref.watch(serviceDetailProvider(widget.serviceId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: serviceAsync.when(
        data: (service) {
          if (service == null) {
            return SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.search_off_rounded,
                      size: 54,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Layanan tidak ditemukan', style: AppTextTheme.h2),
                    const SizedBox(height: AppSpacing.md),
                    AppButton.outline(
                      text: 'Kembali',
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!_isBenefitsInitialized) {
            _selectedBenefits.addAll(service.benefits);
            _isBenefitsInitialized = true;
          }

          return Stack(
            children: [
              // Scrollable Content
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  bottom: 120, // Space for bottom StickyActionBar
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Hero Image Header with back button and badge
                    HeroImageHeader(
                      height: 240,
                      imageUrl: service.imageUrl,
                      badgeText: service.badge,
                      placeholderIcon: service.icon,
                      onBackTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          GoRouter.of(context).go('/home');
                        }
                      },
                    ),

                    // 2. Service Info & Rating
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.screenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EyebrowLabel(text: service.categoryLabel),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  service.name,
                                  style: AppTextTheme.h1,
                                ),
                              ),
                              RatingPill(
                                rating: service.ratingAvg > 0
                                    ? service.ratingAvg
                                    : null,
                                reviewCount: service.ratingCount > 0
                                    ? service.ratingCount
                                    : null,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            service.description,
                            style: AppTextTheme.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // 3. Info Stat Box (ETA & Min Order)
                          InfoStatBox(
                            leftLabel: 'Estimasi Pengerjaan',
                            leftValue: service.etaText,
                            leftIcon: Icons.schedule_rounded,
                            rightLabel: 'Minimal Pemesanan',
                            rightValue:
                                '${service.minQty} ${service.unit.toUpperCase()}',
                            rightIcon: Icons.scale_rounded,
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // 4. Section Header "Keunggulan Layanan"
                          SectionHeader(
                            title: 'Keunggulan Layanan',
                            subtitle:
                                'Pilih keunggulan yang kamu inginkan (${_selectedBenefits.length}/${service.benefits.length} aktif)',
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // 5. Grid of 4 Benefit Tiles
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: AppSpacing.sm,
                                  crossAxisSpacing: AppSpacing.sm,
                                  childAspectRatio: 1.5,
                                ),
                            itemCount: service.benefits.length,
                            itemBuilder: (context, index) {
                              final benefit = service.benefits[index];
                              final isSelected =
                                  _selectedBenefits.contains(benefit);
                              return BenefitTile(
                                icon: Icons.verified_rounded,
                                label: benefit,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedBenefits.remove(benefit);
                                    } else {
                                      _selectedBenefits.add(benefit);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // 6. Note Callout
                          NoteCallout.info(
                            title: 'Catatan Penting',
                            message: service.note,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 7. Sticky Bottom Action Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: StickyActionBar(
                  price: service.startingPrice,
                  priceLabel: 'Mulai dari',
                  customPriceText:
                      '${formatRupiah(service.startingPrice)}/${service.unit}',
                  buttonText: 'Pesan Sekarang',
                  buttonIcon: Icons.shopping_bag_outlined,
                  onButtonPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Pesan ${service.name} (Milestone 4: C-03 Form Pesanan)',
                        ),
                        backgroundColor: AppColors.primaryDark,
                      ),
                    );
                    _showOrderSheet(context, service, _selectedBenefits);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Terjadi kesalahan memuat detail layanan',
                    style: AppTextTheme.h3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton.outline(
                    text: 'Coba Lagi',
                    onPressed: () =>
                        ref.invalidate(serviceDetailProvider(widget.serviceId)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOrderSheet(
    BuildContext context,
    dynamic service,
    Set<String> selectedBenefits,
  ) {
    int quantity = service.minQty as int;
    String method = 'Jemput Kurir';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          final estimatedPrice = quantity * (service.startingPrice as int);

          return Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Konfirmasi Pesanan', style: AppTextTheme.h2),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Atur jumlah dan preferensi untuk ${service.name}',
                    style: AppTextTheme.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Selected Benefits Chips
                  if (selectedBenefits.isNotEmpty) ...[
                    Text(
                      'Keunggulan Layanan Dipilih (${selectedBenefits.length})',
                      style: AppTextTheme.captionMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: 4,
                      children: selectedBenefits.map((b) => Chip(
                        label: Text(
                          b,
                          style: AppTextTheme.caption.copyWith(
                            fontSize: 11,
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: AppColors.primaryLight.withValues(alpha: 0.5),
                        side: const BorderSide(color: AppColors.primary, width: 0.5),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )).toList(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Quantity Stepper
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Estimasi Jumlah', style: AppTextTheme.h3),
                          Text(
                            'Minimal: ${service.minQty} ${service.unit}',
                            style: AppTextTheme.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline_rounded),
                            color: quantity > (service.minQty as int)
                                ? AppColors.primary
                                : AppColors.disabledText,
                            onPressed: quantity > (service.minQty as int)
                                ? () => setSheetState(() => quantity--)
                                : null,
                          ),
                          Text(
                            '$quantity ${service.unit}',
                            style: AppTextTheme.h3.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline_rounded,
                              color: AppColors.primary,
                            ),
                            onPressed: () => setSheetState(() => quantity++),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: AppSpacing.xl),

                  // Method Selection
                  Text(
                    'Metode Layanan',
                    style: AppTextTheme.captionMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: method == 'Jemput Kurir'
                                ? AppColors.primaryLight
                                : Colors.transparent,
                            side: BorderSide(
                              color: method == 'Jemput Kurir'
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          onPressed: () =>
                              setSheetState(() => method = 'Jemput Kurir'),
                          child: Text(
                            '🛵 Jemput Kurir',
                            style: AppTextTheme.captionMedium.copyWith(
                              color: method == 'Jemput Kurir'
                                  ? AppColors.primaryDark
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: method == 'Antar Sendiri'
                                ? AppColors.primaryLight
                                : Colors.transparent,
                            side: BorderSide(
                              color: method == 'Antar Sendiri'
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          onPressed: () =>
                              setSheetState(() => method = 'Antar Sendiri'),
                          child: Text(
                            '🏪 Antar Sendiri',
                            style: AppTextTheme.captionMedium.copyWith(
                              color: method == 'Antar Sendiri'
                                  ? AppColors.primaryDark
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Total & Submit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Estimasi', style: AppTextTheme.caption),
                          Text(
                            formatRupiah(estimatedPrice),
                            style: AppTextTheme.h2.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      AppButton.primary(
                        text: 'Buat Pesanan',
                        isFullWidth: false,
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Pesanan ${service.name} ($quantity ${service.unit}) berhasil dibuat!',
                              ),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
