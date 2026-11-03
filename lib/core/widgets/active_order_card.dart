import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_theme.dart';
import 'stage_progress.dart';
import 'status_chip.dart';

/// Card displaying the customer's current active order on the Home screen.
///
/// States:
/// - Stages 1 to 3 with stage progress.
/// - Loading skeleton.
class ActiveOrderCard extends StatelessWidget {
  final String orderId;
  final String serviceName;
  final OrderStatus status;
  final String? scheduleText;
  final VoidCallback? onTap;
  final bool isLoading;

  const ActiveOrderCard({
    super.key,
    required this.orderId,
    required this.serviceName,
    required this.status,
    this.scheduleText,
    this.onTap,
    this.isLoading = false,
  });

  const ActiveOrderCard.loading({super.key})
    : orderId = '',
      serviceName = '',
      status = OrderStatus.menungguKonfirmasi,
      scheduleText = null,
      onTap = null,
      isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 160,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppRadius.cardRadius,
        ),
      );
    }

    final stage = mapStatusToStage(status) ?? 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.soft,
        border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.cardRadius,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pesanan Aktif',
                            style: AppTextTheme.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            serviceName,
                            style: AppTextTheme.h3,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    StatusChip(status: status),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                StageProgress(
                  currentStage: stage,
                  activeStatusLabel: status.label,
                ),
                if (scheduleText != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  const Divider(color: AppColors.borderSubtle),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          scheduleText!,
                          style: AppTextTheme.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
