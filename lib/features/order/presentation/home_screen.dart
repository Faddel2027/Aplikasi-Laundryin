import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/widgets/active_order_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../core/widgets/laundry_bottom_nav.dart';
import '../../../core/widgets/location_selector.dart';
import '../../../core/widgets/notification_bell.dart';
import '../../../core/widgets/promo_banner.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/service_card.dart';
import '../../../core/widgets/stage_progress.dart';
import '../../../core/widgets/status_chip.dart';
import '../../auth/domain/user_entity.dart';
import '../../auth/presentation/auth_providers.dart';
import '../domain/order_model.dart';
import 'order_providers.dart';

/// Customer Home screen displaying greetings, location, search, promos, active orders, and service grid.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentNavIndex = 0;
  String _selectedAddressLabel = 'Alamat Jemput';
  String _selectedAddress = 'Jl. Merpati No. 12, Sukajadi';
  bool _hasUnreadNotification = true;
  int _selectedOrderTab = 0; // 0: Aktif, 1: Riwayat

  Future<void> _refreshData() async {
    ref.invalidate(servicesListProvider);
    ref.invalidate(activeOrderProvider);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah kamu yakin ingin keluar dari akun Laundryin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(authStateProvider.notifier).signOut();
              if (mounted) context.go('/login');
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLocationSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pilih Alamat Jemput', style: AppTextTheme.h2),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildAddressOption(
                  label: 'Rumah (Utama)',
                  address: 'Jl. Merpati No. 12, Sukajadi',
                  isSelected: _selectedAddress.contains('Merpati'),
                  onTap: () {
                    setState(() {
                      _selectedAddressLabel = 'Rumah';
                      _selectedAddress = 'Jl. Merpati No. 12, Sukajadi';
                    });
                    Navigator.of(ctx).pop();
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildAddressOption(
                  label: 'Kantor',
                  address: 'Gedung Graha Lt. 3, Sudirman',
                  isSelected: _selectedAddress.contains('Sudirman'),
                  onTap: () {
                    setState(() {
                      _selectedAddressLabel = 'Kantor';
                      _selectedAddress = 'Gedung Graha Lt. 3, Sudirman';
                    });
                    Navigator.of(ctx).pop();
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildAddressOption(
                  label: 'Kost',
                  address: 'Jl. Anggrek No. 5, Dago',
                  isSelected: _selectedAddress.contains('Anggrek'),
                  onTap: () {
                    setState(() {
                      _selectedAddressLabel = 'Kost';
                      _selectedAddress = 'Jl. Anggrek No. 5, Dago';
                    });
                    Navigator.of(ctx).pop();
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton.outline(
                  text: 'Tambah Alamat Baru (P0: C-09)',
                  icon: Icons.add_location_alt_outlined,
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Form Tambah Alamat (P0: C-09) siap dikonfigurasi.'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressOption({
    required String label,
    required String address,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.cardRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight.withValues(alpha: 0.3) : AppColors.surface,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    address,
                    style: AppTextTheme.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSheet() {
    setState(() => _hasUnreadNotification = false);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notifikasi Kamu', style: AppTextTheme.h2),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildNotificationItem(
                icon: Icons.local_laundry_service_rounded,
                iconColor: AppColors.primary,
                title: 'Pakaianmu Sedang Dicuci 🧼',
                body: 'Order ORD-202610-001 kini dalam proses pencucian higienis di outlet.',
                time: '15 menit yang lalu',
              ),
              const Divider(height: AppSpacing.md),
              _buildNotificationItem(
                icon: Icons.local_offer_rounded,
                iconColor: AppColors.warning,
                title: 'Diskon Spesial 30% Untukmu! 🎉',
                body: 'Gunakan kode voucher BARU30 untuk potongan harga s.d. Rp20.000.',
                time: '2 jam yang lalu',
              ),
              const Divider(height: AppSpacing.md),
              _buildNotificationItem(
                icon: Icons.delivery_dining_rounded,
                iconColor: AppColors.accent,
                title: 'Kurir Menuju Lokasimu 🛵',
                body: 'Bambang sedang menjemput pakaian ke Jl. Merpati No. 12.',
                time: 'Kemarin',
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                text: 'Tutup Notifikasi',
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String body,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextTheme.captionMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(body, style: AppTextTheme.caption.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(time, style: AppTextTheme.caption.copyWith(color: AppColors.textMuted, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTrackingSheet(OrderModel order) {
    final stage = mapStatusToStage(order.status) ?? 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lacak Pesanan', style: AppTextTheme.h2),
                      Text('ID: ${order.orderId}', style: AppTextTheme.captionMedium),
                    ],
                  ),
                  StatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              StageProgress(currentStage: stage),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppRadius.cardRadius,
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildTrackingStep(
                      title: 'Pesanan Diterima',
                      time: '10.00 WIB',
                      isCompleted: true,
                    ),
                    _buildTrackingStep(
                      title: 'Pakaian Dijemput Kurir',
                      time: '10.30 WIB',
                      isCompleted: true,
                    ),
                    _buildTrackingStep(
                      title: 'Proses Pencucian di Outlet',
                      time: '11.15 WIB (Saat ini)',
                      isCompleted: true,
                      isCurrent: true,
                    ),
                    _buildTrackingStep(
                      title: 'Setrika & Quality Control',
                      time: 'Estimasi: 14.00 WIB',
                      isCompleted: false,
                    ),
                    _buildTrackingStep(
                      title: 'Siap Diantar ke Rumah',
                      time: 'Estimasi: Besok, 16.00 WIB',
                      isCompleted: false,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      text: 'Hubungi Outlet',
                      icon: Icons.chat_bubble_outline_rounded,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Menghubungi customer support Laundryin...')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton.primary(
                      text: 'Tutup Lacak',
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingStep({
    required String title,
    required String time,
    required bool isCompleted,
    bool isCurrent = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isCurrent
                  ? AppColors.primary
                  : (isCompleted ? AppColors.success : AppColors.textMuted),
              size: 20,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 24,
                color: isCompleted ? AppColors.success : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextTheme.captionMedium.copyWith(
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                      color: isCurrent ? AppColors.primaryDark : AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  time,
                  style: AppTextTheme.caption.copyWith(
                    color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPromoSheet(PromoBannerItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
              Text(item.title, style: AppTextTheme.h2),
              const SizedBox(height: AppSpacing.xs),
              Text(item.subtitle, style: AppTextTheme.body.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.lg),
              if (item.code != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.3),
                    borderRadius: AppRadius.cardRadius,
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kode Voucher:', style: AppTextTheme.caption),
                          Text(item.code!, style: AppTextTheme.h2.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, color: AppColors.primary),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: item.code!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Kode voucher "${item.code}" berhasil disalin!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              AppButton.primary(
                text: 'Gunakan Promo Ini',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (item.code != null) {
                    Clipboard.setData(ClipboardData(text: item.code!));
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Voucher promo aktif! Salin kode "${item.code}" saat memesan.'),
                      backgroundColor: AppColors.primaryDark,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: _buildBody(),
      ),
      bottomNavigationBar: LaundryBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (idx) {
          setState(() => _currentNavIndex = idx);
        },
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
            badgeCount: 1,
          ),
          LaundryBottomNavItem(
            label: 'Promo',
            icon: Icons.local_offer_outlined,
            activeIcon: Icons.local_offer_rounded,
          ),
          LaundryBottomNavItem(
            label: 'Profil',
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentNavIndex) {
      case 1:
        return _buildOrdersTab();
      case 2:
        return _buildPromosTab();
      case 3:
        return _buildProfileTab();
      case 0:
      default:
        return _buildHomeTab();
    }
  }

  // TAB 0: BERANDA
  Widget _buildHomeTab() {
    final filteredServicesAsync = ref.watch(filteredServicesProvider);
    final activeOrderAsync = ref.watch(activeOrderProvider);

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppColors.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // 1. Header (Location Selector & Notification Bell)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: LocationSelector.selected(
                      label: _selectedAddressLabel,
                      address: _selectedAddress,
                      onTap: _showLocationSheet,
                    ),
                  ),
                  NotificationBell(
                    hasUnread: _hasUnreadNotification,
                    onTap: _showNotificationSheet,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, color: AppColors.textSecondary),
                    tooltip: 'Keluar dari Akun',
                    onPressed: _showLogoutDialog,
                  ),
                ],
              ),
            ),
          ),

          // 2. Greeting & Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Hai, ',
                        style: AppTextTheme.h2.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Barup! 👋',
                        style: AppTextTheme.h2.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Mau cuci apa hari ini?',
                    style: AppTextTheme.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppSearchBar(
                    hintText: 'Cari layanan cuci, sepatu, karpet...',
                    onChanged: (val) {
                      ref.read(serviceSearchQueryProvider.notifier).setQuery(val);
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),

          // 3. Promo Banner Carousel
          SliverToBoxAdapter(
            child: PromoBanner(
              items: [
                PromoBannerItem(
                  title: 'Diskon Pengguna Baru 30%',
                  subtitle: 'Hemat sampai Rp20.000 untuk pesanan cucian pertamamu!',
                  badgeText: 'PENGGUNA BARU',
                  code: 'BARU30',
                  onTap: () => _showPromoSheet(
                    const PromoBannerItem(
                      title: 'Diskon Pengguna Baru 30%',
                      subtitle: 'Hemat sampai Rp20.000 untuk pesanan cucian pertamamu!',
                      code: 'BARU30',
                    ),
                  ),
                ),
                PromoBannerItem(
                  title: 'Gratis Ongkir Jemput Antar',
                  subtitle: 'Antar jemput tanpa biaya untuk cucian kiloan minimum 5 kg.',
                  badgeText: 'HEMAT ONGKIR',
                  code: 'FREEONGKIR',
                  onTap: () => _showPromoSheet(
                    const PromoBannerItem(
                      title: 'Gratis Ongkir Jemput Antar',
                      subtitle: 'Antar jemput tanpa biaya untuk cucian kiloan minimum 5 kg.',
                      code: 'FREEONGKIR',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

          // 4. Active Order Section (if available)
          SliverToBoxAdapter(
            child: activeOrderAsync.when(
              data: (activeOrder) {
                if (activeOrder == null) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Pesanan Aktif'),
                    ActiveOrderCard(
                      orderId: activeOrder.orderId,
                      serviceName: activeOrder.serviceName,
                      status: activeOrder.status,
                      scheduleText: activeOrder.scheduleText,
                      onTap: () => _showTrackingSheet(activeOrder),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                );
              },
              loading: () => const Column(
                children: [
                  SectionHeader(title: 'Pesanan Aktif'),
                  ActiveOrderCard.loading(),
                  SizedBox(height: AppSpacing.lg),
                ],
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),

          // 5. Section Header "Layanan Kami"
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Layanan Kami',
              subtitle: 'Pilih layanan sesuai kebutuhan pakaianmu',
              actionText: 'Lihat Semua',
              onActionTap: () {
                ref.read(serviceSearchQueryProvider.notifier).setQuery('');
              },
            ),
          ),

          // 6. Service Grid 3x2
          filteredServicesAsync.when(
            data: (services) {
              if (services.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Layanan tidak ditemukan',
                            style: AppTextTheme.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.sm,
                ),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: AppSpacing.md,
                        crossAxisSpacing: AppSpacing.md,
                        childAspectRatio: 1.15,
                      ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final service = services[index];
                    return ServiceCard(
                      title: service.name,
                      startingPrice: service.startingPrice,
                      unit: service.unit,
                      icon: service.icon,
                      colorTheme: service.colorTheme,
                      badge: service.badge,
                      isInactive: !service.isActive,
                      onTap: () {
                        context.push('/service-detail/${service.id}');
                      },
                    );
                  }, childCount: services.length),
                ),
              );
            },
            loading: () => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            error: (error, _) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('Gagal memuat layanan', style: AppTextTheme.h3),
                      const SizedBox(height: AppSpacing.md),
                      AppButton.outline(
                        text: 'Coba Lagi',
                        onPressed: () =>
                            ref.invalidate(servicesListProvider),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom padding for scroll view to clear bottom nav
          const SliverToBoxAdapter(
            child: SizedBox(
              height: AppSpacing.bottomNavHeight + AppSpacing.xl,
            ),
          ),
        ],
      ),
    );
  }

  // TAB 1: PESANAN
  Widget _buildOrdersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pesanan Saya', style: AppTextTheme.h1),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Pantau status cucian aktif dan riwayat pesananmu',
            style: AppTextTheme.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Segmented Tabs
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedOrderTab = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedOrderTab == 0 ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _selectedOrderTab == 0 ? AppColors.primary : AppColors.border),
                    ),
                    child: Center(
                      child: Text(
                        'Pesanan Aktif (1)',
                        style: AppTextTheme.captionMedium.copyWith(
                          color: _selectedOrderTab == 0 ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedOrderTab = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedOrderTab == 1 ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _selectedOrderTab == 1 ? AppColors.primary : AppColors.border),
                    ),
                    child: Center(
                      child: Text(
                        'Riwayat Selesai (1)',
                        style: AppTextTheme.captionMedium.copyWith(
                          color: _selectedOrderTab == 1 ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          if (_selectedOrderTab == 0) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.cardRadius,
                border: Border.all(color: AppColors.border),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ORD-202610-001', style: AppTextTheme.captionMedium.copyWith(fontWeight: FontWeight.bold)),
                      const StatusChip(status: OrderStatus.dicuci),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Cuci Kiloan (4 kg)', style: AppTextTheme.h3),
                  const SizedBox(height: AppSpacing.xxs),
                  Text('Estimasi selesai: Besok, 16.00 WIB', style: AppTextTheme.caption.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.md),
                  const StageProgress(currentStage: 2),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton.outline(
                          text: 'Lacak Status',
                          icon: Icons.location_searching_rounded,
                          onPressed: () {
                            _showTrackingSheet(
                              OrderModel(
                                orderId: 'ORD-202610-001',
                                serviceId: 'kiloan',
                                serviceName: 'Cuci Kiloan (4 kg)',
                                status: OrderStatus.dicuci,
                                scheduleText: 'Estimasi selesai: Besok, 16.00 WIB',
                                estimatedPrice: 28000,
                                createdAt: DateTime.now(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.cardRadius,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ORD-202610-000', style: AppTextTheme.captionMedium.copyWith(fontWeight: FontWeight.bold)),
                      const StatusChip(status: OrderStatus.selesai),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Cuci Satuan (2 item jas)', style: AppTextTheme.h3),
                  const SizedBox(height: AppSpacing.xxs),
                  Text('Selesai kemarin • Total: Rp30.000', style: AppTextTheme.caption.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.md),
                  AppButton.outline(
                    text: 'Pesan Lagi',
                    icon: Icons.replay_rounded,
                    onPressed: () => context.push('/service-detail/satuan'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // TAB 2: PROMO
  Widget _buildPromosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Promo & Voucher', style: AppTextTheme.h1),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Gunakan kode voucher untuk cucian hemat setiap hari',
            style: AppTextTheme.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),

          _buildVoucherCard(
            title: 'Diskon Pengguna Baru 30%',
            description: 'Potongan hingga Rp20.000 tanpa minimal transaksi.',
            code: 'BARU30',
            expiry: 'Berlaku s.d. 31 Des 2026',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildVoucherCard(
            title: 'Gratis Ongkir Jemput Antar',
            description: 'Bebas biaya pengantaran untuk layanan cuci kiloan min. 5 kg.',
            code: 'FREEONGKIR',
            expiry: 'Berlaku setiap hari',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildVoucherCard(
            title: 'Diskon Express 20%',
            description: 'Khusus pesanan Express Kilat selesai dalam 6-12 jam.',
            code: 'KILATHEMAT',
            expiry: 'Berlaku s.d. Minggu ini',
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard({
    required String title,
    required String description,
    required String code,
    required String expiry,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_offer_rounded, color: AppColors.primaryDark, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextTheme.h3),
                    Text(expiry, style: AppTextTheme.caption.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(description, style: AppTextTheme.body.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  code,
                  style: AppTextTheme.captionMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              AppButton.primary(
                text: 'Salin Kode',
                icon: Icons.copy_rounded,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Kode voucher "$code" berhasil disalin!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 3: PROFIL
  Widget _buildProfileTab() {
    final user = ref.watch(authStateProvider).user;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profil Saya', style: AppTextTheme.h1),
          const SizedBox(height: AppSpacing.lg),

          // User Info Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.cardRadius,
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    (user?.name.isNotEmpty ?? false) ? user!.name[0].toUpperCase() : 'B',
                    style: AppTextTheme.h1.copyWith(color: AppColors.primaryDark),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.name ?? 'Barup', style: AppTextTheme.h2),
                      const SizedBox(height: 2),
                      Text(user?.phoneNumber ?? '+62 812-3456-7890', style: AppTextTheme.captionMedium),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: AppRadius.pillRadius,
                        ),
                        child: Text(
                          'Role: ${user?.role.name.toUpperCase() ?? 'CUSTOMER'}',
                          style: AppTextTheme.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Pengaturan Akun'),

          _buildProfileMenuItem(
            icon: Icons.person_outline_rounded,
            title: 'Lengkapi / Ubah Profil (C-14)',
            subtitle: 'Nama lengkap, email, dan alamat',
            onTap: () => context.push('/complete-profile'),
          ),
          _buildProfileMenuItem(
            icon: Icons.location_on_outlined,
            title: 'Kelola Alamat Tersimpan',
            subtitle: _selectedAddress,
            onTap: _showLocationSheet,
          ),

          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Pengujian Lintas Role (Milestone 3)'),

          _buildProfileMenuItem(
            icon: Icons.delivery_dining_rounded,
            title: 'Masuk Portal Kurir',
            subtitle: 'Beralih peran ke kurir jemput-antar',
            onTap: () async {
              await ref.read(authStateProvider.notifier).switchRole(UserRole.courier);
              if (mounted) context.go('/courier');
            },
          ),
          _buildProfileMenuItem(
            icon: Icons.point_of_sale_rounded,
            title: 'Masuk Portal Kasir',
            subtitle: 'Beralih peran ke kasir timbangan & proses',
            onTap: () async {
              await ref.read(authStateProvider.notifier).switchRole(UserRole.cashier);
              if (mounted) context.go('/cashier');
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          // Logout Button
          AppButton.outline(
            text: 'Keluar dari Akun',
            icon: Icons.logout_rounded,
            onPressed: _showLogoutDialog,
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryDark, size: 22),
      ),
      title: Text(title, style: AppTextTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: AppTextTheme.caption.copyWith(color: AppColors.textSecondary)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}
