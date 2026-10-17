import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/scan_method.dart';
import '../models/scan_result_model.dart';
import '../services/scan_service.dart';
import '../widgets/primary_button.dart';
import '../widgets/rounded_card.dart';
import '../guide/guide.dart';
import 'active_scanning_screen.dart';

class ScanMethodSelectionScreen extends StatefulWidget {
  const ScanMethodSelectionScreen({super.key});

  @override
  State<ScanMethodSelectionScreen> createState() =>
      _ScanMethodSelectionScreenState();
}

class _ScanMethodSelectionScreenState extends State<ScanMethodSelectionScreen> {
  ScanMethod _selectedMethod = ScanMethod.availableMethods.first;
  ScanResultType _targetOutcome = ScanResultType.normal;
  late FemaleGuideAnimationController _ariaController;

  @override
  void initState() {
    super.initState();
    _ariaController = FemaleGuideAnimationController(
      initialState: GuideAnimationState.explaining,
      initialSpeechText: 'Aria Tip: Infrared Glint checks camera lenses, while RF sweeping spots wireless signals.',
    );
  }

  @override
  void dispose() {
    _ariaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        title: const Text('Choose Scan Method'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Inspection Methods',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepForestGreen,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Select a method tailored to your space. Each method inspects specific frequency or optical traits.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Guide Explaining Widget
                    RoundedCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      backgroundColor: AppColors.surfaceContainerLow,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                              height: 120,
                              child: FemaleGuide3DWidget(
                                controller: _ariaController,
                                height: 120,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.lightbulb_outline_rounded, size: 14, color: AppColors.naturalTeal),
                                    SizedBox(width: 4),
                                    Text(
                                      'Aria Explains',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.deepForestGreen,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Different hidden lenses react to light glints, while wireless bugs emit radio pulses. Choose a check below.',
                                  style: TextStyle(
                                    fontSize: 12,
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

                    const SizedBox(height: 18),
                    ...ScanMethod.availableMethods.map((method) {
                      final isSelected = _selectedMethod.type == method.type;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: RoundedCard(
                          onTap: () {
                            setState(() => _selectedMethod = method);
                          },
                          padding: const EdgeInsets.all(18),
                          border: isSelected
                              ? Border.all(color: AppColors.naturalTeal, width: 2)
                              : null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.naturalTeal
                                          : AppColors.surfaceContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      method.icon,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.deepForestGreen,
                                      size: 22,
                                    ),
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
                                                method.title,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.deepForestGreen,
                                                ),
                                              ),
                                            ),
                                            if (method.isRecommended)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.surfaceContainerHigh,
                                                  borderRadius:
                                                      BorderRadius.circular(9999),
                                                ),
                                                child: const Text(
                                                  'Recommended',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.naturalTeal,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          method.subtitle,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.naturalTeal
                                            : AppColors.outline,
                                        width: 2,
                                      ),
                                      color: isSelected
                                          ? AppColors.naturalTeal
                                          : Colors.transparent,
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            size: 14,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),
                              const Divider(height: 1, color: AppColors.outlineLight),
                              const SizedBox(height: 12),

                              // Can Detect vs Cannot Detect
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 15,
                                    color: AppColors.naturalTeal,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                          height: 1.4,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Can detect: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.deepForestGreen,
                                            ),
                                          ),
                                          TextSpan(text: method.canDetect),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.cancel_outlined,
                                    size: 15,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                          height: 1.4,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Cannot detect: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.deepForestGreen,
                                            ),
                                          ),
                                          TextSpan(text: method.cannotDetect),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    // Testing Simulation Switch (Demonstration transparency per Section 8)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.tune_rounded,
                                size: 16,
                                color: AppColors.naturalTeal,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Simulation Mode Preview',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepForestGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Choose test scenario outcome for UI flow inspection:',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildOutcomeChip(
                                label: 'Clean (Normal)',
                                type: ScanResultType.normal,
                              ),
                              const SizedBox(width: 8),
                              _buildOutcomeChip(
                                label: 'Indicator',
                                type: ScanResultType.possibleIndicator,
                              ),
                              const SizedBox(width: 8),
                              _buildOutcomeChip(
                                label: 'Inconclusive',
                                type: ScanResultType.unableToConfirm,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Persistent Start Scan Action
            Padding(
              padding: const EdgeInsets.all(20),
              child: PrimaryButton(
                text: 'Start Selected Scan',
                icon: Icons.play_arrow_rounded,
                onPressed: () {
                  ScanService().selectMethod(_selectedMethod);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ActiveScanningScreen(
                        method: _selectedMethod,
                        desiredOutcome: _targetOutcome,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutcomeChip({
    required String label,
    required ScanResultType type,
  }) {
    final isSelected = _targetOutcome == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _targetOutcome = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.naturalTeal : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.naturalTeal : AppColors.outline,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.deepForestGreen,
            ),
          ),
        ),
      ),
    );
  }
}
