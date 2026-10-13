import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class SafeLensBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback onScanPressed;

  const SafeLensBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.onScanPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmCream.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepForestGreen.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.shield_outlined,
                activeIcon: Icons.shield_rounded,
                label: 'Home',
              ),
              _buildCenterScanButton(),
              _buildNavItem(
                index: 2,
                icon: Icons.history_rounded,
                activeIcon: Icons.history_rounded,
                label: 'History',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.tune_rounded,
                activeIcon: Icons.tune_rounded,
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.naturalTeal : AppColors.textTertiary;

    return InkWell(
      onTap: () => onIndexChanged(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: color,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterScanButton() {
    return GestureDetector(
      onTap: onScanPressed,
      child: Transform.translate(
        offset: const Offset(0, -10),
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.naturalTeal,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.naturalTeal.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.radar_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}
