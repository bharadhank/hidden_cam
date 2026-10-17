import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../services/storage_service.dart';
import '../widgets/shield_3d_widget.dart';
import '../controllers/shield_animation_controller.dart';
import '../widgets/botanical_scenery.dart';
import 'onboarding_screen.dart';
import 'main_navigation_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..forward();

    _navTimer = Timer(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      final hasCompleted = StorageService().hasCompletedOnboarding;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (ctx, anim, secAnim) => hasCompleted
              ? const MainNavigationShell()
              : const OnboardingScreen(),
          transitionsBuilder: (ctx, anim, secAnim, child) {
            return FadeTransition(opacity: anim, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: Stack(
        children: [
          // Ambient soft glow in background
          Positioned(
            top: -60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.softSageGreen.withValues(alpha: 0.25),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.softSageGreen.withValues(alpha: 0.35),
                      blurRadius: 80,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Center Identity Block
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // 3D Shield Hero with Greeting State
                const Shield3DWidget(
                  state: ShieldState.greeting,
                  size: 110,
                  showRings: false,
                ),

                const SizedBox(height: 24),

                // App Title
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepForestGreen,
                    letterSpacing: -0.6,
                  ),
                ),

                const SizedBox(height: 10),

                // Tagline
                const Text(
                  AppStrings.tagline,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const Spacer(flex: 3),

                // Status indication pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.naturalTeal,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        AppStrings.calibrationText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.deepForestGreen,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Aria Guide Introduction Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.outlineLight),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 9,
                        backgroundImage: AssetImage('assets/images/female_guide_fallback.jpg'),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Guided by Aria • 3D Female Companion',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.naturalTeal,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Smooth Progress Bar Tracker
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 110),
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: LinearProgressIndicator(
                          value: _progressController.value,
                          minHeight: 4,
                          backgroundColor: AppColors.surfaceContainerHigh,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.naturalTeal,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 36),

                // Lush Botanical Foliage Layer
                const BotanicalFooterFoliage(height: 110),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
