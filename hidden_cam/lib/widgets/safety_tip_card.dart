import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'rounded_card.dart';

class SafetyTipCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;

  const SafetyTipCard({
    super.key,
    this.title = 'Take a moment to look around before using an unfamiliar space.',
    this.description =
        'Smoke detectors, clock radios, and wall sconces are common items to visually verify.',
    this.icon = Icons.lightbulb_outline_rounded,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.amberLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.softAmber,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepForestGreen,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
