import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';
import 'widgets.dart';

/// Debug-only Component Gallery showcasing all 27 core components and variants.
class ComponentGalleryScreen extends StatefulWidget {
  const ComponentGalleryScreen({super.key});

  @override
  State<ComponentGalleryScreen> createState() => _ComponentGalleryScreenState();
}

class _ComponentGalleryScreenState extends State<ComponentGalleryScreen> {
  int _navIndex = 0;
  String _phoneInput = '';
  String _otpInput = '';

  Widget _buildGallerySection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.md,
          ),
          child: Text(
            title,
            style: AppTextTheme.h2.copyWith(color: AppColors.primaryDark),
          ),
        ),
        ...children,
        const SizedBox(height: AppSpacing.lg),
        const Divider(color: AppColors.border),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LaundryAppBar.backWithTitle(title: 'Component Gallery'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BrandMark
              _buildGallerySection('1. BrandMark', [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          BrandMark.large(),
                          SizedBox(height: AppSpacing.xs),
                          Text('Large', style: AppTextTheme.caption),
                        ],
                      ),
                      Column(
                        children: [
                          BrandMark.small(),
                          SizedBox(height: AppSpacing.xs),
                          Text('Small (40)', style: AppTextTheme.caption),
                        ],
                      ),
                      Column(
                        children: [
                          BrandMark.small(customSize: 28),
                          SizedBox(height: AppSpacing.xs),
                          Text('Custom (28)', style: AppTextTheme.caption),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),

              // 2. LaundryAppBar
              _buildGallerySection('2. LaundryAppBar', [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    children: [
                      LaundryAppBar.logoWithAction(),
                      Divider(height: 1),
                      LaundryAppBar.backWithTitle(title: 'Detail Pesanan'),
                    ],
                  ),
                ),
              ]),

              // 3. LaundryBottomNav
              _buildGallerySection('3. LaundryBottomNav', [
                LaundryBottomNav(
                  currentIndex: _navIndex,
                  onTap: (idx) => setState(() => _navIndex = idx),
                  customItems: const [
                    LaundryBottomNavItem(
                      label: 'Beranda',
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                    ),
                    LaundryBottomNavItem(
                      label: 'Pesanan',
                      icon: Icons.receipt_long_outlined,
                      activeIcon: Icons.receipt_long_rounded,
                      badgeCount: 2,
                    ),
                    LaundryBottomNavItem(
                      label: 'Promo',
                      icon: Icons.local_offer_outlined,
                      activeIcon: Icons.local_offer_rounded,
                      hasBadgeDot: true,
                    ),
                    LaundryBottomNavItem(
                      label: 'Profil',
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                    ),
                  ],
                ),
              ]),

              // 4. PageIndicator
              _buildGallerySection('4. PageIndicator', [
                const Center(child: PageIndicator(count: 4, currentIndex: 1)),
              ]),

              // 5. SectionHeader
              _buildGallerySection('5. SectionHeader', [
                SectionHeader(
                  title: 'Layanan Laundry',
                  subtitle: 'Pilih layanan sesuai kebutuhanmu',
                  actionText: 'Lihat Semua',
                  onActionTap: () {},
                ),
                const SectionHeader(title: 'Promo Spesial Hari Ini'),
              ]),

              // 6. StickyActionBar
              _buildGallerySection('6. StickyActionBar', [
                StickyActionBar(
                  price: 25000,
                  buttonText: 'Pesan Sekarang',
                  onButtonPressed: () {},
                ),
                const SizedBox(height: AppSpacing.sm),
                const StickyActionBar(
                  price: 50000,
                  buttonText: 'Sedang Memproses',
                  isLoading: true,
                ),
              ]),

              // 7 & 8. AppButton (Primary & Outline)
              _buildGallerySection('7 & 8. AppButton (Primary & Outline)', [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Column(
                    children: [
                      AppButton.primary(
                        text: 'Lanjutkan ke Pembayaran',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () {},
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const AppButton.primary(
                        text: 'Memuat data...',
                        isLoading: true,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const AppButton.primary(
                        text: 'Tombol Dinonaktifkan',
                        isDisabled: true,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton.outline(
                        text: 'Pilih Alamat Lain',
                        icon: Icons.location_on_outlined,
                        onPressed: () {},
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const AppButton.outline(
                        text: 'Outline Disabled',
                        isDisabled: true,
                      ),
                    ],
                  ),
                ),
              ]),

              // 9. AppTextLink
              _buildGallerySection('9. AppTextLink', [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Row(
                    children: [
                      AppTextLink(text: 'Kirim Ulang Kode', onTap: () {}),
                      const SizedBox(width: AppSpacing.lg),
                      const AppTextLink(text: 'Tautan Mati', isDisabled: true),
                    ],
                  ),
                ),
              ]),

              // 10. PhoneField
              _buildGallerySection('10. PhoneField', [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Column(
                    children: [
                      PhoneField(
                        onChanged: (val) => setState(() => _phoneInput = val),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const PhoneField(
                        errorText: 'Nomor telepon minimal 9 digit',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const PhoneField(isDisabled: true),
                      if (_phoneInput.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Input: +62 $_phoneInput',
                          style: AppTextTheme.caption,
                        ),
                      ],
                    ],
                  ),
                ),
              ]),

              // 11. OtpField
              _buildGallerySection('11. OtpField', [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Column(
                    children: [
                      OtpField(
                        onChanged: (val) => setState(() => _otpInput = val),
                        onCompleted: (val) {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const OtpField(hasError: true),
                      if (_otpInput.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Kode OTP: $_otpInput',
                          style: AppTextTheme.caption,
                        ),
                      ],
                    ],
                  ),
                ),
              ]),

              // 12. AppSearchBar
              _buildGallerySection('12. AppSearchBar', [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: AppSearchBar(),
                ),
              ]),

              // 13. EyebrowLabel
              _buildGallerySection('13. EyebrowLabel', [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: EyebrowLabel(text: 'LAYANAN TERBAIK MINGGU INI'),
                ),
              ]),

              // 14. TermsText
              _buildGallerySection('14. TermsText', [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: TermsText(),
                ),
              ]),

              // 15. IllustrationCard
              _buildGallerySection('15. IllustrationCard', [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Column(
                    children: [
                      const IllustrationCard(
                        theme: IllustrationCardTheme.blue,
                        icon: Icons.local_shipping_rounded,
                        height: 140,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const IllustrationCard(
                        theme: IllustrationCardTheme.tosca,
                        icon: Icons.clean_hands_rounded,
                        height: 140,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const IllustrationCard(
                        theme: IllustrationCardTheme.purple,
                        icon: Icons.track_changes_rounded,
                        height: 140,
                      ),
                    ],
                  ),
                ),
              ]),

              // 16. LocationSelector
              _buildGallerySection('16. LocationSelector', [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LocationSelector.selected(
                        label: 'Rumah',
                        address: 'Jl. Merpati No. 12, Sukajadi',
                        onTap: () {},
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      LocationSelector.noAddress(onTap: () {}),
                      const SizedBox(height: AppSpacing.sm),
                      const LocationSelector.loading(),
                    ],
                  ),
                ),
              ]),

              // 17. NotificationBell
              _buildGallerySection('17. NotificationBell', [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Row(
                    children: [
                      NotificationBell(hasUnread: false, onTap: () {}),
                      const SizedBox(width: AppSpacing.lg),
                      NotificationBell(hasUnread: true, onTap: () {}),
                    ],
                  ),
                ),
              ]),

              // 18. PromoBanner
              _buildGallerySection('18. PromoBanner', [
                PromoBanner(
                  items: [
                    PromoBannerItem(
                      title: 'Diskon Pengguna Baru 30%',
                      subtitle:
                          'Hemat sampai Rp20.000 untuk pesanan pertamamu!',
                      badgeText: 'PENGGUNA BARU',
                      code: 'BARU30',
                      onTap: () {},
                    ),
                    PromoBannerItem(
                      title: 'Gratis Ongkir Akhir Pekan',
                      subtitle: 'Antar jemput tanpa biaya untuk cucian kiloan.',
                      badgeText: 'WEEKEND DEALS',
                      code: 'FREEONGKIR',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const PromoBanner(items: [], isLoading: true),
              ]),

              // 19. ServiceCard
              _buildGallerySection('19. ServiceCard (6 Warna Pastel)', [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.15,
                    children: [
                      ServiceCard(
                        title: 'Cuci Kiloan',
                        startingPrice: 7000,
                        unit: 'kg',
                        icon: Icons.local_laundry_service_rounded,
                        colorTheme: ServicePastelColor.blue,
                        badge: 'Populer',
                        onTap: () {},
                      ),
                      ServiceCard(
                        title: 'Cuci Satuan',
                        startingPrice: 15000,
                        unit: 'item',
                        icon: Icons.dry_cleaning_rounded,
                        colorTheme: ServicePastelColor.purple,
                        onTap: () {},
                      ),
                      ServiceCard(
                        title: 'Express Kilat',
                        startingPrice: 12000,
                        unit: 'kg',
                        icon: Icons.bolt_rounded,
                        colorTheme: ServicePastelColor.amber,
                        badge: 'Cepat',
                        onTap: () {},
                      ),
                      ServiceCard(
                        title: 'Cuci Sepatu',
                        startingPrice: 25000,
                        unit: 'psg',
                        icon: Icons.roller_skating_rounded,
                        colorTheme: ServicePastelColor.tosca,
                        onTap: () {},
                      ),
                      ServiceCard(
                        title: 'Cuci Karpet',
                        startingPrice: 35000,
                        unit: 'm²',
                        icon: Icons.layers_rounded,
                        colorTheme: ServicePastelColor.green,
                        onTap: () {},
                      ),
                      const ServiceCard(
                        title: 'Cuci Selimut',
                        startingPrice: 20000,
                        unit: 'item',
                        icon: Icons.bed_rounded,
                        colorTheme: ServicePastelColor.rose,
                        isInactive: true,
                      ),
                    ],
                  ),
                ),
              ]),

              // 20. StatusChip
              _buildGallerySection('20. StatusChip (10 Status)', [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: OrderStatus.values.map((status) {
                      return StatusChip(status: status);
                    }).toList(),
                  ),
                ),
              ]),

              // 21. StageProgress
              _buildGallerySection('21. StageProgress (3 Tahap)', [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Column(
                    children: [
                      StageProgress(
                        currentStage: 1,
                        activeStatusLabel: 'Kurir Menuju Lokasi',
                      ),
                      SizedBox(height: AppSpacing.lg),
                      StageProgress(
                        currentStage: 2,
                        activeStatusLabel: 'Sedang Dicuci',
                      ),
                      SizedBox(height: AppSpacing.lg),
                      StageProgress(
                        currentStage: 3,
                        activeStatusLabel: 'Dalam Pengantaran',
                      ),
                    ],
                  ),
                ),
              ]),

              // 22. ActiveOrderCard
              _buildGallerySection('22. ActiveOrderCard', [
                ActiveOrderCard(
                  orderId: 'ORD-202610-001',
                  serviceName: 'Cuci Kiloan (4 kg)',
                  status: OrderStatus.dicuci,
                  scheduleText: 'Estimasi selesai: Besok, 16.00 WIB',
                  onTap: () {},
                ),
                const SizedBox(height: AppSpacing.md),
                const ActiveOrderCard.loading(),
              ]),

              // 23. HeroImageHeader
              _buildGallerySection('23. HeroImageHeader', [
                HeroImageHeader(
                  height: 180,
                  badgeText: 'Paling Populer',
                  onBackTap: () {},
                ),
              ]),

              // 24. RatingPill
              _buildGallerySection('24. RatingPill', [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Row(
                    children: [
                      RatingPill(rating: 4.9, reviewCount: 128),
                      SizedBox(width: AppSpacing.md),
                      RatingPill.unrated(),
                    ],
                  ),
                ),
              ]),

              // 25. InfoStatBox
              _buildGallerySection('25. InfoStatBox', [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: InfoStatBox(
                    leftLabel: 'Estimasi Waktu',
                    leftValue: '2 Hari Kerja',
                    leftIcon: Icons.timer_outlined,
                    rightLabel: 'Minimal Order',
                    rightValue: '3 Kg',
                    rightIcon: Icons.scale_outlined,
                  ),
                ),
              ]),

              // 26. BenefitTile
              _buildGallerySection('26. BenefitTile (Grid 2 Kolom)', [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: BenefitTile(
                          icon: Icons.verified_rounded,
                          label: 'Deterjen Premium',
                          description: 'Ramah serat pakaian',
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: BenefitTile(
                          icon: Icons.iron_rounded,
                          label: 'Setrika Uap',
                          description: 'Rapi & anti kusut',
                        ),
                      ),
                    ],
                  ),
                ),
              ]),

              // 27. NoteCallout
              _buildGallerySection('27. NoteCallout', [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Column(
                    children: [
                      NoteCallout.info(
                        title: 'Informasi Penimbangan',
                        message: 'Berat akhir akan ditimbang ulang di outlet dan dikonfirmasi lewat aplikasi.',
                      ),
                      SizedBox(height: AppSpacing.sm),
                      NoteCallout.warning(
                        title: 'Pakaian Khusus',
                        message: 'Pakaian berbahan sutra atau berenda disarankan memilih layanan Cuci Satuan.',
                      ),
                      SizedBox(height: AppSpacing.sm),
                      NoteCallout.error(
                        title: 'Area Terlalu Jauh',
                        message: 'Lokasimu saat ini di luar jangkauan operasional antar-jemput outlet kami.',
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
