import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';

enum OrderStatus {
  menungguKonfirmasi,
  kurirMenujuLokasi,
  dijemput,
  ditimbang,
  dicuci,
  disetrika,
  siapDiantar,
  siapDiambil,
  dalamPengantaran,
  selesai,
  dibatalkan,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.menungguKonfirmasi:
        return 'Menunggu Konfirmasi';
      case OrderStatus.kurirMenujuLokasi:
        return 'Kurir Menuju Lokasi';
      case OrderStatus.dijemput:
        return 'Dijemput';
      case OrderStatus.ditimbang:
        return 'Ditimbang';
      case OrderStatus.dicuci:
        return 'Dicuci';
      case OrderStatus.disetrika:
        return 'Disetrika';
      case OrderStatus.siapDiantar:
        return 'Siap Diantar';
      case OrderStatus.siapDiambil:
        return 'Siap Diambil';
      case OrderStatus.dalamPengantaran:
        return 'Dalam Pengantaran';
      case OrderStatus.selesai:
        return 'Selesai';
      case OrderStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.menungguKonfirmasi:
        return AppColors.warning;
      case OrderStatus.kurirMenujuLokasi:
      case OrderStatus.dijemput:
        return AppColors.primary;
      case OrderStatus.ditimbang:
        return const Color(0xFF9333EA);
      case OrderStatus.dicuci:
        return AppColors.accent;
      case OrderStatus.disetrika:
        return const Color(0xFF3B82F6);
      case OrderStatus.siapDiantar:
      case OrderStatus.siapDiambil:
        return const Color(0xFF10B981);
      case OrderStatus.dalamPengantaran:
        return AppColors.primaryDark;
      case OrderStatus.selesai:
        return AppColors.success;
      case OrderStatus.dibatalkan:
        return AppColors.error;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case OrderStatus.menungguKonfirmasi:
        return AppColors.warningLight;
      case OrderStatus.kurirMenujuLokasi:
      case OrderStatus.dijemput:
        return AppColors.primaryLight;
      case OrderStatus.ditimbang:
        return AppColors.tintPurple;
      case OrderStatus.dicuci:
        return AppColors.tintTosca;
      case OrderStatus.disetrika:
        return AppColors.tintBlue;
      case OrderStatus.siapDiantar:
      case OrderStatus.siapDiambil:
        return AppColors.tintGreen;
      case OrderStatus.dalamPengantaran:
        return AppColors.primaryLight;
      case OrderStatus.selesai:
        return AppColors.successLight;
      case OrderStatus.dibatalkan:
        return AppColors.errorLight;
    }
  }
}

/// Status chip with indicator dot and background tint.
class StatusChip extends StatelessWidget {
  final OrderStatus status;
  final String? customLabel;

  const StatusChip({super.key, required this.status, this.customLabel});

  @override
  Widget build(BuildContext context) {
    final dotColor = status.color;
    final bgColor = status.backgroundColor;
    final labelText = customLabel ?? status.label;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            labelText,
            style: AppTextTheme.caption.copyWith(
              color: dotColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
