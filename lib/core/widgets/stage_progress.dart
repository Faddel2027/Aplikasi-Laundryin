import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';
import 'status_chip.dart';

/// Maps an [OrderStatus] to its corresponding 3-stage progress index (1, 2, or 3).
/// Returns null for cancelled order.
int? mapStatusToStage(OrderStatus status) {
  switch (status) {
    case OrderStatus.menungguKonfirmasi:
    case OrderStatus.kurirMenujuLokasi:
    case OrderStatus.dijemput:
      return 1;
    case OrderStatus.ditimbang:
    case OrderStatus.dicuci:
    case OrderStatus.disetrika:
    case OrderStatus.siapDiantar:
    case OrderStatus.siapDiambil:
      return 2;
    case OrderStatus.dalamPengantaran:
    case OrderStatus.selesai:
      return 3;
    case OrderStatus.dibatalkan:
      return null;
  }
}

/// 3-stage visual progress stepper per docs/PRD.md (section 5).
///
/// Stage 1: Dijemput
/// Stage 2: Diproses
/// Stage 3: Diantar
class StageProgress extends StatelessWidget {
  final int currentStage; // 1, 2, or 3
  final String? activeStatusLabel;

  const StageProgress({
    super.key,
    required this.currentStage,
    this.activeStatusLabel,
  }) : assert(
         currentStage >= 1 && currentStage <= 3,
         'currentStage must be 1, 2, or 3',
       );

  @override
  Widget build(BuildContext context) {
    const stageTitles = ['Dijemput', 'Diproses', 'Diantar'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(5, (index) {
            if (index.isOdd) {
              // Connecting line
              final stepBefore = (index ~/ 2) + 1;
              final isPassed = currentStage > stepBefore;
              return Expanded(
                child: Container(
                  height: 3,
                  color: isPassed ? AppColors.primary : AppColors.border,
                ),
              );
            }

            final stageIndex = (index ~/ 2) + 1;
            final isCompleted = currentStage > stageIndex;
            final isCurrent = currentStage == stageIndex;

            Color nodeColor;
            Widget nodeChild;

            if (isCompleted) {
              nodeColor = AppColors.primary;
              nodeChild = const Icon(
                Icons.check_rounded,
                size: 14,
                color: Colors.white,
              );
            } else if (isCurrent) {
              nodeColor = AppColors.primary;
              nodeChild = Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              );
            } else {
              nodeColor = AppColors.border;
              nodeChild = Text(
                '$stageIndex',
                style: AppTextTheme.caption.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              );
            }

            return Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: nodeColor,
                shape: BoxShape.circle,
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Center(child: nodeChild),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(3, (i) {
            final stage = i + 1;
            final isCurrent = currentStage == stage;
            final isPassed = currentStage >= stage;

            return Expanded(
              child: Text(
                stageTitles[i],
                textAlign: i == 0
                    ? TextAlign.left
                    : (i == 1 ? TextAlign.center : TextAlign.right),
                style: AppTextTheme.caption.copyWith(
                  color: isCurrent
                      ? AppColors.primaryDark
                      : (isPassed
                            ? AppColors.textPrimary
                            : AppColors.textSecondary),
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            );
          }),
        ),
        if (activeStatusLabel != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: AppRadius.pillRadius,
            ),
            child: Text(
              activeStatusLabel!,
              style: AppTextTheme.captionMedium.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
