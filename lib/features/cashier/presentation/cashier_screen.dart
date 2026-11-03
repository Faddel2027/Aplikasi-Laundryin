import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/utils/format_rupiah.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_chip.dart';
import '../../auth/domain/user_entity.dart';
import '../../auth/presentation/auth_providers.dart';

/// Screen for Cashier portal (S-01 to S-06).
class CashierScreen extends ConsumerStatefulWidget {
  const CashierScreen({super.key});

  @override
  ConsumerState<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends ConsumerState<CashierScreen> {
  int _selectedFilter = 0; // 0: Semua, 1: Ditimbang, 2: Dicuci, 3: Siap Diantar

  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD-202610-001',
      'customer': 'Barup',
      'service': 'Cuci Kiloan',
      'unit': 'kg',
      'unitPrice': 7000,
      'weight': 4.0,
      'total': 28000,
      'status': OrderStatus.dicuci,
      'courier': 'Bambang (Kurir 1)',
      'isPaid': false,
    },
    {
      'id': 'ORD-202610-002',
      'customer': 'Dewi Lestari',
      'service': 'Cuci Kiloan',
      'unit': 'kg',
      'unitPrice': 7000,
      'weight': null,
      'total': null,
      'status': OrderStatus.dijemput,
      'courier': 'Bambang (Kurir 1)',
      'isPaid': false,
    },
    {
      'id': 'ORD-202610-003',
      'customer': 'Ahmad Fauzi',
      'service': 'Cuci Satuan',
      'unit': 'item',
      'unitPrice': 15000,
      'weight': 2.0,
      'total': 30000,
      'status': OrderStatus.siapDiantar,
      'courier': 'Belum ditugaskan',
      'isPaid': true,
    },
  ];

  void _showWeighingDialog(int index) {
    final order = _orders[index];
    final weightController = TextEditingController(
      text: order['weight'] != null ? '${order['weight']}' : '3.5',
    );

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final parsedWeight = double.tryParse(weightController.text) ?? 0.0;
          final calcTotal = (parsedWeight * (order['unitPrice'] as int)).round();

          return AlertDialog(
            title: Text('Input Timbangan', style: AppTextTheme.h2),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order: ${order['id']} (${order['customer']})',
                  style: AppTextTheme.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Berat Riil (${order['unit']}):', style: AppTextTheme.captionMedium),
                const SizedBox(height: AppSpacing.xs),
                TextField(
                  controller: weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    suffixText: order['unit'] as String,
                    border: OutlineInputBorder(borderRadius: AppRadius.inputRadius),
                  ),
                  onChanged: (_) => setDialogState(() {}),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Akhir:', style: AppTextTheme.body),
                    Text(
                      formatRupiah(calcTotal),
                      style: AppTextTheme.h3.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  setState(() {
                    _orders[index]['weight'] = parsedWeight;
                    _orders[index]['total'] = calcTotal;
                    _orders[index]['status'] = OrderStatus.ditimbang;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Timbangan berhasil disimpan: $parsedWeight ${order['unit']} (${formatRupiah(calcTotal)})'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateStatus(int index) {
    final order = _orders[index];
    OrderStatus nextStatus;
    final current = order['status'] as OrderStatus;
    if (current == OrderStatus.dijemput || current == OrderStatus.ditimbang) {
      nextStatus = OrderStatus.dicuci;
    } else if (current == OrderStatus.dicuci) {
      nextStatus = OrderStatus.disetrika;
    } else {
      nextStatus = OrderStatus.siapDiantar;
    }

    setState(() {
      _orders[index]['status'] = nextStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status order ${order['id']} diubah ke: ${nextStatus.name}'),
        backgroundColor: AppColors.primaryDark,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah kamu yakin ingin keluar dari akun Kasir?'),
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

  void _assignCourier(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Tugaskan Kurir', style: AppTextTheme.h2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delivery_dining_rounded, color: AppColors.primary),
              title: const Text('Bambang (Kurir 1)'),
              subtitle: const Text('Sedang di zona Sukajadi'),
              onTap: () {
                Navigator.of(ctx).pop();
                setState(() {
                  _orders[index]['courier'] = 'Bambang (Kurir 1)';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kurir Bambang berhasil ditugaskan!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delivery_dining_rounded, color: AppColors.primary),
              title: const Text('Agus (Kurir 2)'),
              subtitle: const Text('Sedang di zona Pasteur'),
              onTap: () {
                Navigator.of(ctx).pop();
                setState(() {
                  _orders[index]['courier'] = 'Agus (Kurir 2)';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kurir Agus berhasil ditugaskan!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _recordCashPayment(int index) {
    final order = _orders[index];
    if (order['isPaid'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order ini sudah lunas.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Catat Pembayaran Tunai', style: AppTextTheme.h2),
        content: Text(
          'Konfirmasi penerimaan uang tunai sebesar ${formatRupiah(order['total'] as int? ?? 0)} dari customer ${order['customer']}?',
          style: AppTextTheme.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _orders[index]['isPaid'] = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pembayaran tunai order ${order['id']} berhasil dicatat (Lunas)!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Terima Tunai', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;

    final filtered = _orders.where((o) {
      if (_selectedFilter == 1) return o['status'] == OrderStatus.dijemput || o['status'] == OrderStatus.ditimbang;
      if (_selectedFilter == 2) return o['status'] == OrderStatus.dicuci || o['status'] == OrderStatus.disetrika;
      if (_selectedFilter == 3) return o['status'] == OrderStatus.siapDiantar;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Text(
          'Portal Kasir - Outlet Pusat',
          style: AppTextTheme.h3.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
            tooltip: 'Ganti Role ke Customer',
            onPressed: () async {
              await ref.read(authStateProvider.notifier).switchRole(UserRole.customer);
              if (context.mounted) context.go('/home');
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 18),
            label: const Text('Keluar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Cashier Header Banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    child: const Icon(Icons.point_of_sale_rounded, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Kasir Outlet',
                          style: AppTextTheme.h3.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.3),
                                borderRadius: AppRadius.pillRadius,
                              ),
                              child: Text(
                                'Role: Kasir',
                                style: AppTextTheme.caption.copyWith(color: AppColors.warningLight, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '${_orders.length} order hari ini',
                              style: AppTextTheme.caption.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Filter status chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: Row(
                children: [
                  _buildFilterChip(0, 'Semua (${_orders.length})'),
                  const SizedBox(width: AppSpacing.sm),
                  _buildFilterChip(1, 'Timbang (1)'),
                  const SizedBox(width: AppSpacing.sm),
                  _buildFilterChip(2, 'Proses (1)'),
                  const SizedBox(width: AppSpacing.sm),
                  _buildFilterChip(3, 'Siap Antar (1)'),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Order Queue List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.xs,
                ),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final order = filtered[index];
                  final originalIndex = _orders.indexOf(order);

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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order['id'] as String, style: AppTextTheme.captionMedium.copyWith(fontWeight: FontWeight.bold)),
                            StatusChip(status: order['status'] as OrderStatus),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(order['customer'] as String, style: AppTextTheme.h3),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          '${order['service']} • ${order['weight'] != null ? '${order['weight']} ${order['unit']}' : 'Belum ditimbang'}',
                          style: AppTextTheme.body.copyWith(color: AppColors.textSecondary),
                        ),
                        if (order['total'] != null) ...[
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Total: ${formatRupiah(order['total'] as int)}',
                            style: AppTextTheme.captionMedium.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => _assignCourier(originalIndex),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.delivery_dining_rounded, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Kurir: ${order['courier']}',
                                      style: AppTextTheme.caption.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            InkWell(
                              onTap: () => _recordCashPayment(originalIndex),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: order['isPaid'] == true ? AppColors.successLight : AppColors.warningLight,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      order['isPaid'] == true ? Icons.check_circle_rounded : Icons.payments_rounded,
                                      size: 14,
                                      color: order['isPaid'] == true ? AppColors.success : AppColors.warning,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      order['isPaid'] == true ? 'Lunas' : 'Bayar Tunai',
                                      style: AppTextTheme.caption.copyWith(
                                        color: order['isPaid'] == true ? AppColors.success : AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: AppButton.outline(
                                text: order['weight'] == null ? 'Timbang' : 'Ubah Berat',
                                icon: Icons.scale_rounded,
                                onPressed: () => _showWeighingDialog(originalIndex),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: AppButton.primary(
                                text: 'Update Status',
                                icon: Icons.arrow_forward_rounded,
                                onPressed: () => _updateStatus(originalIndex),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedFilter == index;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = index),
      borderRadius: AppRadius.pillRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : AppColors.surface,
          borderRadius: AppRadius.pillRadius,
          border: Border.all(
            color: isSelected ? const Color(0xFF0F172A) : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextTheme.captionMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
