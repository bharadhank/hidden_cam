import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/scan_result_model.dart';
import '../widgets/shield_3d_widget.dart';
import '../controllers/shield_animation_controller.dart';
import 'normal_result_screen.dart';
import 'possible_indicator_screen.dart';
import 'unable_to_confirm_screen.dart';

class ProcessingScreen extends StatefulWidget {
  final ScanResultModel result;

  const ProcessingScreen({super.key, required this.result});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  int _currentStep = 0;
  Timer? _stepTimer;

  final List<String> _stages = [
    'Evaluating frequency spectrum consistency...',
    'Benchmarking against benign domestic signatures...',
    'Synthesizing spatial privacy assessment...',
  ];

  @override
  void initState() {
    super.initState();
    _startProcessingTimeline();
  }

  void _startProcessingTimeline() {
    _stepTimer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (_currentStep < _stages.length - 1) {
        setState(() => _currentStep++);
      } else {
        timer.cancel();
        _navigateToResult();
      }
    });
  }

  void _navigateToResult() {
    Widget destination;
    switch (widget.result.type) {
      case ScanResultType.normal:
        destination = NormalResultScreen(result: widget.result);
        break;
      case ScanResultType.possibleIndicator:
        destination = PossibleIndicatorScreen(result: widget.result);
        break;
      case ScanResultType.unableToConfirm:
        destination = UnableToConfirmScreen(result: widget.result);
        break;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, anim, secAnim) => destination,
        transitionsBuilder: (ctx, anim, secAnim, child) {
          return FadeTransition(opacity: anim, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // 3D Volumetric Shield in PROCESSING state with holographic rings
              Shield3DWidget(
                state: ShieldState.processing,
                size: 160,
                showRings: true,
              ),

              const SizedBox(height: 36),

              const Text(
                'Analyzing Environment',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepForestGreen,
                  letterSpacing: -0.4,
                ),
              ),

              const SizedBox(height: 10),

              // Step Text
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _stages[_currentStep],
                  key: ValueKey<int>(_currentStep),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // 3D Luminous Stage Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_stages.length, (index) {
                  final isDone = index <= _currentStep;
                  final isCurrent = index == _currentStep;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: isCurrent ? 32 : (isDone ? 20 : 10),
                    height: 6,
                    decoration: BoxDecoration(
                      color: isDone
                          ? AppColors.naturalTeal
                          : AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: AppColors.naturalTeal.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  );
                }),
              ),


              const Spacer(flex: 3),

              // Reassuring Methodology Note
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.lock_clock_outlined,
                      size: 18,
                      color: AppColors.naturalTeal,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Visual animation represents mathematical signal filtering. It is not real-time surveillance.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
