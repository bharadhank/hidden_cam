import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/report_issue_model.dart';
import '../widgets/shield_3d_widget.dart';
import '../controllers/shield_animation_controller.dart';
import '../widgets/primary_button.dart';
import '../widgets/rounded_card.dart';
import 'main_navigation_shell.dart';

class ReportConfirmationScreen extends StatelessWidget {
  final ReportIssueModel report;

  const ReportConfirmationScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Shield in SUCCESS animation state
              const Shield3DWidget(
                state: ShieldState.success,
                size: 130,
                showRings: false,
              ),

              const SizedBox(height: 24),

              const Text(
                'Report Recorded Safely',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepForestGreen,
                  letterSpacing: -0.4,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Your documentation has been saved to your encrypted on-device history. No data has left your phone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              // Submission Summary Card
              RoundedCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildSummaryRow('Reference', report.id),
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: AppColors.outlineLight),
                    const SizedBox(height: 10),
                    _buildSummaryRow('Category', report.noticeType.label),
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: AppColors.outlineLight),
                    const SizedBox(height: 10),
                    _buildSummaryRow(
                      'Location',
                      report.location.isEmpty
                          ? 'Not specified'
                          : report.location,
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: AppColors.outlineLight),
                    const SizedBox(height: 10),
                    _buildSummaryRow(
                      'Security',
                      '100% On-device sealed',
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Primary Action: View in History
              PrimaryButton(
                text: 'View in Scan History',
                icon: Icons.history_rounded,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainNavigationShell(initialIndex: 2),
                    ),
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 12),

              // Secondary Action: Return Home
              PrimaryButton(
                text: 'Return to Home',
                icon: Icons.home_outlined,
                isOutlined: true,
                backgroundColor: AppColors.naturalTeal,
                textColor: AppColors.naturalTeal,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainNavigationShell(initialIndex: 0),
                    ),
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isHighlighted
                ? AppColors.naturalTeal
                : AppColors.deepForestGreen,
          ),
        ),
      ],
    );
  }
}
