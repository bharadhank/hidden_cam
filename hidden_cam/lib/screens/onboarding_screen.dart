import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../services/storage_service.dart';
import '../widgets/primary_button.dart';
import '../guide/guide.dart';
import 'main_navigation_shell.dart';

class OnboardingScreen extends StatefulWidget {
  final int initialPage;

  const OnboardingScreen({super.key, this.initialPage = 0});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  late FemaleGuideAnimationController _guideController;
  bool _use3DPreview = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
    _guideController = FemaleGuideAnimationController(
      initialState: GuideAnimationState.greeting,
      initialSpeechText: 'Welcome! I am Aria, your 3D safety companion.',
    );
  }

  @override
  void dispose() {
    _guideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    switch (page) {
      case 0:
        _guideController.greeting();
        _guideController.setSpeechText("Welcome! I am Aria, your 3D safety guide.");
        break;
      case 1:
        _guideController.explaining();
        _guideController.setSpeechText("I'll guide you through mindful checks of your space.");
        break;
      case 2:
        _guideController.reassuring();
        _guideController.setSpeechText("Private, non-invasive assessment on-device.");
        break;
    }
  }

  void _finishOnboarding() {
    StorageService().setCompletedOnboarding(true);
    Navigator.pushReplacement(
      context,
        PageRouteBuilder(
          pageBuilder: (ctx, anim, secAnim) => const MainNavigationShell(),
          transitionsBuilder: (ctx, anim, secAnim, child) {
            return FadeTransition(opacity: anim, child: child);
          },
          transitionDuration: const Duration(milliseconds: 350),
        ),
    );
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: Column(
          children: [
            // Header: SafeLens logo & Skip action
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.naturalTeal,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shield_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'SafeLens',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepForestGreen,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _use3DPreview = !_use3DPreview;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _use3DPreview
                                ? AppColors.naturalTeal.withValues(alpha: 0.15)
                                : AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _use3DPreview
                                  ? AppColors.naturalTeal
                                  : AppColors.outlineLight,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _use3DPreview
                                    ? Icons.view_in_ar_rounded
                                    : Icons.smart_display_rounded,
                                size: 14,
                                color: _use3DPreview
                                    ? AppColors.naturalTeal
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _use3DPreview ? '3D Live' : 'Video Clip',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _use3DPreview
                                      ? AppColors.naturalTeal
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: _finishOnboarding,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          backgroundColor: AppColors.surfaceContainerLow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // PageView content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildOnboardingStep1(),
                  _buildOnboardingStep2(),
                  _buildOnboardingStep3(),
                ],
              ),
            ),

            // Footer pagination dots, primary button, trust badge
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                children: [
                  // Stepper Pagination Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final isActive = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: isActive ? 28 : 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.naturalTeal
                              : AppColors.softSageGreen.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  // Next / Get Started Action
                  PrimaryButton(
                    text: _currentPage == 2 ? 'Get Started' : 'Next',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _nextPage,
                  ),

                  const SizedBox(height: 12),

                  // Privacy Trust Badge
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 15,
                        color: AppColors.naturalTeal,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Privacy-first & non-invasive assessment',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Know your space
  Widget _buildOnboardingStep1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visual Framing: Female Guide Video / 3D Live
          if (_use3DPreview)
            FemaleGuide3DWidget(
              controller: _guideController,
              height: 280,
              enableTouch: true,
            )
          else
            const FemaleGuideVideoWidget(
              videoAssetPath: 'assets/videos/welcome_guide.mp4',
              fallbackState: GuideAnimationState.greeting,
              speechText: "Hello! I'm Aria, your 3D SafeLens guide.",
              height: 280,
            ),

          const SizedBox(height: 24),

          const Text(
            'Know your space.',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.deepForestGreen,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'SafeLens helps you become more aware of your surroundings with gentle clarity.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Step 2: Check with confidence
  Widget _buildOnboardingStep2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_use3DPreview)
            FemaleGuide3DWidget(
              controller: _guideController,
              height: 280,
              enableTouch: true,
            )
          else
            const FemaleGuideVideoWidget(
              videoAssetPath: 'assets/videos/explaining_guide.mp4',
              fallbackState: GuideAnimationState.explaining,
              speechText: "I'll guide you through mindful checks step by step.",
              height: 280,
            ),

          const SizedBox(height: 24),

          const Text(
            'Check with confidence.',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.deepForestGreen,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Follow simple steps to check your surroundings with mindful clarity.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Step 3: Your privacy matters
  Widget _buildOnboardingStep3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Step 3: Interactive 3D Guide showcase
          FemaleGuide3DWidget(
            controller: _guideController,
            height: 280,
            enableTouch: true,
            speechText: "100% on-device. Your privacy is paramount.",
          ),

          const SizedBox(height: 24),

          const Text(
            'Your privacy matters.',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.deepForestGreen,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'All assessments are performed entirely on your device. No camera feeds or room scans leave your phone.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
