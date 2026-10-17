import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/rounded_card.dart';
import '../guide/guide.dart';
import 'report_screen.dart';

class SafetyStepsScreen extends StatefulWidget {
  const SafetyStepsScreen({super.key});

  @override
  State<SafetyStepsScreen> createState() => _SafetyStepsScreenState();
}

class _SafetyStepsScreenState extends State<SafetyStepsScreen> {
  final Set<int> _completedSteps = {};
  late FemaleGuideAnimationController _guideController;

  @override
  void initState() {
    super.initState();
    _guideController = FemaleGuideAnimationController(
      initialState: GuideAnimationState.explaining,
      initialSpeechText: 'Stay calm. Follow these gentle recommendations at your own pace.',
    );
  }

  @override
  void dispose() {
    _guideController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> _steps = [
    {
      'num': '01',
      'title': 'Look around carefully',
      'desc':
          'Check unusual objects or unexpected devices placed at eye level, smoke detectors, clock faces, or power outlets.',
    },
    {
      'num': '02',
      'title': 'Don\'t touch unknown equipment',
      'desc':
          'Avoid tampering with or unplugging unfamiliar apparatus. Preserving the exact setup keeps evidence intact if review is required.',
    },
    {
      'num': '03',
      'title': 'Move to a comfortable place',
      'desc':
          'Your comfort and peace of mind come first. If you feel uneasy, step outside to the lobby or another safe environment.',
    },
    {
      'num': '04',
      'title': 'Report if necessary',
      'desc':
          'Record relevant details, capture secure in-app photos, and notify host management or trusted authorities quietly.',
    },
  ];

  void _toggleStep(int index) {
    setState(() {
      if (_completedSteps.contains(index)) {
        _completedSteps.remove(index);
      } else {
        _completedSteps.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        title: const Text('Recommended Safety Steps'),
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
                  children: [
                    // Context Banner with Aria Explaining Gesture
                    RoundedCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      backgroundColor: AppColors.surfaceContainer,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                              height: 110,
                              child: FemaleGuide3DWidget(
                                controller: _guideController,
                                height: 110,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Aria\'s Calm Advice',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepForestGreen,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Most indicators are benign consumer devices. Work through these verification steps calmly at your own pace.',
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

                    const SizedBox(height: 18),

                    // Interactive Steps Checklist
                    ...List.generate(_steps.length, (index) {
                      final step = _steps[index];
                      final isDone = _completedSteps.contains(index);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RoundedCard(
                          padding: const EdgeInsets.all(16),
                          border: isDone
                              ? Border.all(
                                  color: AppColors.naturalTeal.withValues(alpha: 0.5),
                                  width: 1.5,
                                )
                              : null,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isDone
                                      ? AppColors.naturalTeal
                                      : AppColors.surfaceContainer,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  step['num']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDone
                                        ? Colors.white
                                        : AppColors.deepForestGreen,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            step['title']!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.deepForestGreen,
                                              decoration: isDone
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => _toggleStep(index),
                                          child: Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isDone
                                                  ? AppColors.naturalTeal
                                                  : AppColors.surfaceContainerLow,
                                            ),
                                            child: Icon(
                                              Icons.check,
                                              size: 16,
                                              color: isDone
                                                  ? Colors.white
                                                  : AppColors.textTertiary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      step['desc']!,
                                      style: const TextStyle(
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
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Persistent Action
            Padding(
              padding: const EdgeInsets.all(20),
              child: PrimaryButton(
                text: 'Document Finding / File Report',
                icon: Icons.edit_document,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReportScreen(),
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
}
