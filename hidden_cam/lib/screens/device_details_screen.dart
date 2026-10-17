import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/scan_result_model.dart';
import '../widgets/primary_button.dart';
import '../widgets/rounded_card.dart';
import '../guide/guide.dart';
import 'safety_steps_screen.dart';
import 'report_screen.dart';

class DeviceDetailsScreen extends StatelessWidget {
  final ScanResultModel result;

  const DeviceDetailsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        title: const Text('Device Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Pill & Ref number
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amberLight,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.fiber_manual_record,
                          size: 8,
                          color: AppColors.softAmber,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Possible Device',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.softAmber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Ref #${result.id}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Aria Pointing Guidance Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineLight),
                ),
                child: const Row(
                  children: [
                    GuideFallbackWidget(
                      state: GuideAnimationState.pointing,
                      isCircle: true,
                      height: 38,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Aria Points Out',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepForestGreen,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.touch_app_rounded, size: 14, color: AppColors.naturalTeal),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Examine the frequency and signal strength below. Check physical items in the ~1.8m zone.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Device Identity Card
              RoundedCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.sensors_rounded,
                            color: AppColors.naturalTeal,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result.deviceName ?? 'Unknown electronic device',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepForestGreen,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Discovered via passive ambient scan',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Metrics Grid (Signal, Area, Logged)
                    Row(
                      children: [
                        _buildSubMetric(
                          icon: Icons.signal_cellular_alt_rounded,
                          label: 'SIGNAL',
                          value: 'Moderate',
                          sub: result.signalDbm ?? '-68 dBm',
                        ),
                        const SizedBox(width: 8),
                        _buildSubMetric(
                          icon: Icons.near_me_rounded,
                          label: 'AREA',
                          value: 'Living Room',
                          sub: 'East corner',
                        ),
                        const SizedBox(width: 8),
                        _buildSubMetric(
                          icon: Icons.schedule_rounded,
                          label: 'LOGGED',
                          value: '10:42 PM',
                          sub: 'Just now',
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Frequency Band Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.graphic_eq_rounded,
                                size: 18,
                                color: AppColors.naturalTeal,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                result.frequencyBand ?? 'Band: 2.4GHz RF Beacon',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.deepForestGreen,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: const Text(
                              'Non-broadcast',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Approximate Scan Area Card with Map Radius
              RoundedCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.pin_drop_rounded,
                              size: 18,
                              color: AppColors.naturalTeal,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Approximate Scan Area',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepForestGreen,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '~1.8m radius',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Radar circles
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.naturalTeal.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.naturalTeal.withValues(alpha: 0.15),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.softAmber,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.softAmber.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.radar_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          const Positioned(
                            bottom: 8,
                            child: Text(
                              'Living Room Lounge · East corner',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Confirmed Observations vs Estimates (Required by Section 6)
              RoundedCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Observations & Limitations',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepForestGreen,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildObservationItem(
                      isConfirmed: true,
                      title: 'Confirmed by scan:',
                      description:
                          'Radio frequency beacon transmission detected at 2437 MHz frequency band.',
                    ),
                    const SizedBox(height: 10),
                    _buildObservationItem(
                      isConfirmed: false,
                      title: 'Estimated:',
                      description:
                          'Distance (~1.8m) calculated from signal power attenuation; not confirmed optical location.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Why this may appear
              RoundedCard(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.amberLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: AppColors.softAmber,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Why this may appear',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepForestGreen,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Benign appliances like smart TVs, wireless soundbars, and smart lighting repeaters emit similar RF beacons in hotel rooms.',
                            style: TextStyle(
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
              ),

              const SizedBox(height: 24),

              // Action Buttons
              PrimaryButton(
                text: 'Follow Recommended Safety Steps',
                icon: Icons.checklist_rounded,
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

              PrimaryButton(
                text: 'Document Finding / File Report',
                icon: Icons.edit_note_rounded,
                isOutlined: true,
                backgroundColor: AppColors.naturalTeal,
                textColor: AppColors.naturalTeal,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReportScreen(prefillResult: result),
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

  Widget _buildSubMetric({
    required IconData icon,
    required String label,
    required String value,
    required String sub,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: AppColors.naturalTeal),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textTertiary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.deepForestGreen,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              sub,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObservationItem({
    required bool isConfirmed,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isConfirmed
              ? Icons.check_circle_rounded
              : Icons.adjust_rounded,
          size: 16,
          color: isConfirmed ? AppColors.naturalTeal : AppColors.softAmber,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isConfirmed
                      ? AppColors.naturalTeal
                      : AppColors.softAmber,
                ),
              ),
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
    );
  }
}
