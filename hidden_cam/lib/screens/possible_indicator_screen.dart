import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/scan_result_model.dart';
import '../widgets/shield_3d_widget.dart';
import '../controllers/shield_animation_controller.dart';
import '../widgets/primary_button.dart';
import '../widgets/rounded_card.dart';
import 'device_details_screen.dart';
import 'safety_steps_screen.dart';
import 'scan_method_selection_screen.dart';

class PossibleIndicatorScreen extends StatelessWidget {
  final ScanResultModel result;

  const PossibleIndicatorScreen({super.key, required this.result});

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
              // Hero Status Shield in CAUTION state
              Shield3DWidget(
                state: ShieldState.caution,
                size: 130,
                showRings: false,
              ),

              const SizedBox(height: 18),

              // Main Title
              const Text(
                'Possible indicator',
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
                'Something may need a closer look.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.softAmber,
                ),
              ),

              const SizedBox(height: 14),

              // Reassurance Pill / Disclaimer
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
                  'This result is an indicator, not proof of a hidden camera or unauthorized device.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Action Group
              PrimaryButton(
                text: 'Review Details',
                icon: Icons.arrow_forward_rounded,
                backgroundColor: AppColors.softAmber,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeviceDetailsScreen(result: result),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              PrimaryButton(
                text: 'Safety Steps',
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

              // Why this may appear explanatory card
              RoundedCard(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.amberLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: AppColors.softAmber,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Why this may appear',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepForestGreen,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Common household devices like smart TVs, streaming media sticks, and Wi-Fi range extenders continuously broadcast benign wireless beacons.',
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

              const SizedBox(height: 12),

              // Quick Visual Safety Tip Card
              RoundedCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SafetyStepsScreen(),
                    ),
                  );
                },
                padding: const EdgeInsets.all(16),
                backgroundColor: AppColors.surfaceContainerLow,
                child: const Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      color: AppColors.naturalTeal,
                      size: 22,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Look around comfortably',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepForestGreen,
                            ),
                          ),
                          Text(
                            'Trust your instincts and take your time',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Footer Rescan Button
              TextButton.icon(
                icon: const Icon(Icons.replay_rounded, size: 18),
                label: const Text('Scan area again'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.naturalTeal,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScanMethodSelectionScreen(),
                    ),
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
}
