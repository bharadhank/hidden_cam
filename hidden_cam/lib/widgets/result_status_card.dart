import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/scan_result_model.dart';
import 'rounded_card.dart';

class ResultStatusCard extends StatelessWidget {
  final ScanResultModel result;
  final VoidCallback? onTap;

  const ResultStatusCard({
    super.key,
    required this.result,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    Color iconColor;
    IconData icon;
    String statusTitle;

    switch (result.type) {
      case ScanResultType.normal:
        badgeColor = AppColors.softSageGreen.withValues(alpha: 0.25);
        iconColor = AppColors.naturalTeal;
        icon = Icons.check_circle_rounded;
        statusTitle = 'No indicators found';
        break;
      case ScanResultType.possibleIndicator:
        badgeColor = AppColors.softAmber.withValues(alpha: 0.25);
        iconColor = AppColors.softAmber;
        icon = Icons.warning_rounded;
        statusTitle = 'Possible Indicator';
        break;
      case ScanResultType.unableToConfirm:
        badgeColor = AppColors.surfaceContainerHigh;
        iconColor = AppColors.textTertiary;
        icon = Icons.help_outline_rounded;
        statusTitle = 'Unable to Confirm';
        break;
    }

    return RoundedCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        statusTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.deepForestGreen,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (result.isDemo)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'DEMO',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textTertiary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${result.location} · ${result.methodTitle}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
            size: 20,
          ),
        ],
      ),
    );
  }
}
