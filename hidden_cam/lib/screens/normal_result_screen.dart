import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../models/scan_result_model.dart';
import '../widgets/shield_3d_widget.dart';
import '../controllers/shield_animation_controller.dart';
import '../widgets/primary_button.dart';
import '../widgets/rounded_card.dart';
import 'safety_steps_screen.dart';
import 'scan_method_selection_screen.dart';

class NormalResultScreen extends StatelessWidget {
  final ScanResultModel result;

  const NormalResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${result.timestamp.hour.toString().padLeft(2, '0')}:${result.timestamp.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        title: const Text('Scan Result Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hero Shield in SAFE_RESULT State with checkmark
              Shield3DWidget(
                state: ShieldState.safe,
                size: 130,
                showRings: false,
              ),

              const SizedBox(height: 18),

              // Title
              const Text(
                AppStrings.normalResultTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepForestGreen,
                  letterSpacing: -0.4,
                ),
              ),

              const SizedBox(height: 8),

              // Reassuring Summary
              const Text(
                'Nothing suspicious was identified during this check. Your space feels calm and clear.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 24),

              // Diagnostics Card
              RoundedCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _buildMetricRow(
                      icon: Icons.schedule_rounded,
                      title: 'Scan completed',
                      subtitle: 'Full environment sweep',
                      value: timeStr,
                      isHighlighted: true,
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.outlineLight),
                    const SizedBox(height: 12),
                    _buildMetricRow(
                      icon: Icons.radar_rounded,
                      title: 'Scan method',
                      subtitle: result.methodTitle,
                      value: 'Visual Check',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.wifi_tethering_rounded,
                                  size: 16,
                                  color: AppColors.naturalTeal,
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'RF Spectrum: Clear',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.deepForestGreen,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.videocam_off_outlined,
                                  size: 16,
                                  color: AppColors.naturalTeal,
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Infrared: 0 Pulses',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.deepForestGreen,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Reassurance & Mindful Guidance Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        color: AppColors.naturalTeal,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Safety awareness note',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepForestGreen,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            AppStrings.safetyNote,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Primary CTA: View Safety Tips
              PrimaryButton(
                text: 'View Safety Tips',
                icon: Icons.lightbulb_outline_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SafetyStepsScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              // Secondary CTA: Rescan Area
              PrimaryButton(
                text: 'Scan Area Again',
                icon: Icons.refresh_rounded,
                isOutlined: true,
                backgroundColor: AppColors.naturalTeal,
                textColor: AppColors.naturalTeal,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScanMethodSelectionScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    bool isHighlighted = false,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLow,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.naturalTeal, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepForestGreen,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppColors.surfaceContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isHighlighted
                  ? AppColors.naturalTeal
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
