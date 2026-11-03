import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_chip.dart';
import '../../auth/domain/user_entity.dart';
import '../../auth/presentation/auth_providers.dart';

/// Screen for Courier portal (K-01 to K-04).
class CourierScreen extends ConsumerStatefulWidget {
  const CourierScreen({super.key});

  @override
  ConsumerState<CourierScreen> createState() => _CourierScreenState();
}

class _CourierScreenState extends ConsumerState<CourierScreen> {
  int _selectedFilter = 0; // 0: Semua, 1: Jemput, 2: Antar

  final List<Map<String, dynamic>> _tasks = [
    {
      'id': 'TSK-001',
      'type': 'Jemput',
      'customerName': 'Budi Santoso',
      'phone': '081298765432',
      'address': 'Jl. Anggrek No. 15, Sukajadi',
      'time': '10.00 - 12.00 WIB',
      'service': 'Cuci Kiloan (Estimasi 4 kg)',
      'status': OrderStatus.kurirMenujuLokasi,
      'isCompleted': false,
    },
    {
      'id': 'TSK-002',
      'type': 'Antar',
      'customerName': 'Siti Rahma',
      'phone': '081345678912',
      'address': 'Jl. Flamboyan No. 8, Pasteur',
      'time': '13.00 - 15.00 WIB',
      'service': 'Cuci Satuan (3 item jas)',
      'status': OrderStatus.dalamPengantaran,
      'isCompleted': false,
    },
  ];

  void _completeTask(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Konfirmasi Bukti Tugas', style: AppTextTheme.h2),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Unggah foto bukti pakaian untuk menyelesaikan tugas ini.',
              style: AppTextTheme.body.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: AppRadius.cardRadius,
                border: Border.all(color: AppColors.border, style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo_rounded, size: 36, color: AppColors.primary),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Ambil / Pilih Foto (1-4 foto)', style: AppTextTheme.captionMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton.primary(
              text: 'Selesaikan Tugas',
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() {
                  _tasks[index]['isCompleted'] = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tugas ${_tasks[index]['id']} berhasil diselesaikan!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah kamu yakin ingin keluar dari akun Kurir?'),
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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;

    final filtered = _tasks.where((t) {
      if (_selectedFilter == 1) return t['type'] == 'Jemput';
      if (_selectedFilter == 2) return t['type'] == 'Antar';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: Text(
          'Portal Kurir',
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
            // Courier Header Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              decoration: const BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.delivery_dining_rounded, size: 32, color: AppColors.primaryDark),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Kurir Laundryin',
                          style: AppTextTheme.h3.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: AppRadius.pillRadius,
                              ),
                              child: Text(
                                'Role: Kurir',
                                style: AppTextTheme.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '${_tasks.where((t) => !(t['isCompleted'] as bool)).length} tugas aktif',
                              style: AppTextTheme.caption.copyWith(color: Colors.white.withValues(alpha: 0.9)),
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

            // Filter Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: Row(
                children: [
                  _buildFilterChip(0, 'Semua (${_tasks.length})'),
                  const SizedBox(width: AppSpacing.sm),
                  _buildFilterChip(1, 'Jemput (1)'),
                  const SizedBox(width: AppSpacing.sm),
                  _buildFilterChip(2, 'Antar (1)'),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Task List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada tugas pada filter ini.',
                        style: AppTextTheme.body.copyWith(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                        vertical: AppSpacing.xs,
                      ),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final task = filtered[index];
                        final isCompleted = task['isCompleted'] as bool;

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
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: task['type'] == 'Jemput'
                                              ? AppColors.primaryLight
                                              : AppColors.accentLight,
                                          borderRadius: AppRadius.pillRadius,
                                        ),
                                        child: Text(
                                          task['type'] as String,
                                          style: AppTextTheme.caption.copyWith(
                                            color: task['type'] == 'Jemput'
                                                ? AppColors.primaryDark
                                                : AppColors.accentDark,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Text(
                                        task['id'] as String,
                                        style: AppTextTheme.caption.copyWith(color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                  if (isCompleted)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.successLight,
                                        borderRadius: AppRadius.pillRadius,
                                      ),
                                      child: Text(
                                        'Selesai',
                                        style: AppTextTheme.caption.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  else
                                    StatusChip(status: task['status'] as OrderStatus),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(task['customerName'] as String, style: AppTextTheme.h3),
                              const SizedBox(height: AppSpacing.xxs),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_rounded, size: 16, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      task['address'] as String,
                                      style: AppTextTheme.captionMedium.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Row(
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    task['time'] as String,
                                    style: AppTextTheme.caption.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppButton.outline(
                                      text: 'Hubungi',
                                      icon: Icons.phone_outlined,
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Menghubungi ${task['customerName']} (${task['phone']})...'),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: AppButton.primary(
                                      text: isCompleted ? 'Selesai' : 'Update',
                                      isDisabled: isCompleted,
                                      icon: Icons.check_circle_outline_rounded,
                                      onPressed: () => _completeTask(index),
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
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: AppRadius.pillRadius,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
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
