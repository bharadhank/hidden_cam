import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'guide_animation_state.dart';

/// Static 2D fallback illustration widget for the SafeLens Female Guide (Aria).
///
/// Used when:
/// 1. 3D WebGL or device hardware acceleration is unavailable.
/// 2. Reduced-motion accessibility preference is active.
/// 3. Offline or low-memory power-saving mode is requested.
class GuideFallbackWidget extends StatefulWidget {
  final GuideAnimationState state;
  final String? speechText;
  final double height;
  final double width;
  final bool isReducedMotion;
  final bool isCircle;

  const GuideFallbackWidget({
    super.key,
    this.state = GuideAnimationState.idle,
    this.speechText,
    this.height = 240,
    this.width = double.infinity,
    this.isReducedMotion = false,
    this.isCircle = false,
  });

  @override
  State<GuideFallbackWidget> createState() => _GuideFallbackWidgetState();
}

class _GuideFallbackWidgetState extends State<GuideFallbackWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    if (!widget.isReducedMotion) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(GuideFallbackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isReducedMotion != oldWidget.isReducedMotion) {
      if (widget.isReducedMotion) {
        _pulseController.stop();
      } else {
        _pulseController.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getStateAuraColor() {
    switch (widget.state) {
      case GuideAnimationState.scanning:
        return AppColors.naturalTeal;
      case GuideAnimationState.processing:
        return const Color(0xFF5AB6AD);
      case GuideAnimationState.reassuring:
        return AppColors.softSageGreen;
      case GuideAnimationState.greeting:
        return AppColors.naturalTeal;
      case GuideAnimationState.explaining:
      case GuideAnimationState.pointing:
        return AppColors.softAmber;
      case GuideAnimationState.paused:
      case GuideAnimationState.idle:
        return AppColors.softSageGreen.withValues(alpha: 0.6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auraColor = _getStateAuraColor();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.speechText != null && widget.speechText!.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.outlineLight),
              boxShadow: [AppColors.softShadow],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: auraColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    widget.speechText!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepForestGreen,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final double breathScale = widget.isReducedMotion
                ? 1.0
                : 1.0 + (_pulseController.value * 0.025);
            final double glowBlur = widget.isReducedMotion
                ? 16.0
                : 16.0 + (_pulseController.value * 12.0);

            if (widget.isCircle) {
              return Transform.scale(
                scale: breathScale,
                child: Container(
                  width: widget.height,
                  height: widget.height,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: auraColor.withValues(alpha: 0.8),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: auraColor.withValues(alpha: 0.25),
                        blurRadius: glowBlur,
                        spreadRadius: 2,
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/female_guide_fallback.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }

            return Transform.scale(
              scale: breathScale,
              child: Container(
                height: widget.height,
                width: widget.width,
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ambient decorative glow backing
                    Container(
                      width: widget.height * 0.85,
                      height: widget.height * 0.85,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: auraColor.withValues(alpha: 0.12),
                        boxShadow: [
                          BoxShadow(
                            color: auraColor.withValues(alpha: 0.2),
                            blurRadius: glowBlur,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    // High-res Guide illustration card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        height: widget.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: auraColor.withValues(alpha: 0.35),
                            width: 1.5,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/female_guide_fallback.jpg',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildVectorFallback(auraColor);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildVectorFallback(Color accentColor) {
    return Container(
      width: widget.height * 0.8,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shield_rounded,
            size: 48,
            color: accentColor,
          ),
          const SizedBox(height: 8),
          const Text(
            'SafeLens Guide Aria',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.deepForestGreen,
            ),
          ),
        ],
      ),
    );
  }
}
