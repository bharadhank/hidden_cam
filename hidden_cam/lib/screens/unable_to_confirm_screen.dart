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

class UnableToConfirmScreen extends StatelessWidget {
  final ScanResultModel result;

  const UnableToConfirmScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
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
              // Shield with paused / calm posture
              const Shield3DWidget(
                state: ShieldState.idle,
                size: 130,
                showRings: false,
              ),

              const SizedBox(height: 18),

              // Title
              const Text(
                AppStrings.unableToConfirmTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepForestGreen,
                  letterSpacing: -0.4,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'This inspection was inconclusive.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 10),

              // Reassurance Pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Text(
                  'Heavy wireless noise or dense barriers prevented clear sensor reading.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Explanatory Card
              RoundedCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.naturalTeal,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Why checks may be inconclusive',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepForestGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• High density of guest Wi-Fi routers in multi-story hotels\n'
                      '• Device camera exposure limitations in extreme dark or harsh glare\n'
                      '• Metal shielding or reinforced walls attenuating radio returns',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 16,
                            color: AppColors.naturalTeal,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'A simple 2-minute visual check around eye-level items is recommended.',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.deepForestGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Primary CTA: Rescan with Adjusted Positioning
              PrimaryButton(
                text: 'Try Another Method / Rescan',
                icon: Icons.refresh_rounded,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScanMethodSelectionScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              // Secondary CTA: Recommended Safety Steps
              PrimaryButton(
                text: 'Follow Physical Safety Steps',
                icon: Icons.checklist_rounded,
                isOutlined: true,
                backgroundColor: AppColors.naturalTeal,
                textColor: AppColors.naturalTeal,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SafetyStepsScreen(),
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
}
