import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import '../core/theme/app_colors.dart';
import 'female_guide_animation_controller.dart';
import 'guide_fallback_widget.dart';

/// Interactive 3D Guide Widget for the SafeLens Application.
///
/// Embeds the real-time rigged 3D cartoon female guide (Aria) with
/// smooth named animations ('idle', 'greeting', 'explaining', 'scanning',
/// 'pointing', 'processing', 'reassuring', 'paused').
///
/// Features seamless error fallback to [GuideFallbackWidget] when 3D
/// rendering or WebGL is not available on the current platform.
class FemaleGuide3DWidget extends StatefulWidget {
  final FemaleGuideAnimationController controller;
  final double height;
  final double width;
  final bool enableTouch;
  final String? speechText;
  final bool isReducedMotion;
  final VoidCallback? onTap;

  const FemaleGuide3DWidget({
    super.key,
    required this.controller,
    this.height = 320,
    this.width = double.infinity,
    this.enableTouch = false,
    this.speechText,
    this.isReducedMotion = false,
    this.onTap,
  });

  @override
  State<FemaleGuide3DWidget> createState() => _FemaleGuide3DWidgetState();
}

class _FemaleGuide3DWidgetState extends State<FemaleGuide3DWidget>
    with WidgetsBindingObserver {
  bool _has3DError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.speechText != null) {
      widget.controller.setSpeechText(widget.speechText);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      widget.controller.pause();
    } else if (state == AppLifecycleState.resumed && !widget.isReducedMotion) {
      widget.controller.play(widget.controller.state);
    }
  }

  @override
  void didUpdateWidget(FemaleGuide3DWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.speechText != oldWidget.speechText) {
      widget.controller.setSpeechText(widget.speechText);
    }
    if (widget.isReducedMotion != oldWidget.isReducedMotion) {
      widget.controller.setReducedMotion(widget.isReducedMotion);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final speech = widget.speechText ?? widget.controller.speechText;

    // In case of reduced motion or explicit 3D loading failure, use 2D fallback
    if (widget.isReducedMotion || _has3DError) {
      return GestureDetector(
        onTap: widget.onTap,
        child: GuideFallbackWidget(
          state: widget.controller.state,
          speechText: speech,
          height: widget.height,
          width: widget.width,
          isReducedMotion: widget.isReducedMotion,
        ),
      );
    }

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Companion Dialogue Bubble
              if (speech != null && speech.isNotEmpty)
                _buildSpeechBubble(speech),

              // 3D Canvas
              SizedBox(
                height: widget.height,
                width: widget.width,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Model Viewer
                    Flutter3DViewer(
                      src: 'assets/avatar/safelens_avatar.glb',
                      controller: widget.controller.controller,
                      enableTouch: widget.enableTouch,
                      activeGestureInterceptor: true,
                      progressBarColor: AppColors.naturalTeal,
                      onProgress: (double progress) {
                        debugPrint('Aria 3D progress: ${(progress * 100).toInt()}%');
                      },
                      onLoad: (String modelAddress) {
                        debugPrint('Aria 3D model loaded: $modelAddress');
                      },
                      onError: (String error) {
                        debugPrint('Aria 3D Viewer error: $error');
                        if (mounted) {
                          setState(() {
                            _has3DError = true;
                          });
                          widget.controller.handleLoadError(error);
                        }
                      },
                    ),

                    // Subtle loading indicator overlay while model finishes init
                    if (widget.controller.isLoading && !_has3DError)
                      Container(
                        color: AppColors.warmCream.withValues(alpha: 0.7),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.naturalTeal,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Aria is joining...',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpeechBubble(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 24, right: 24),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepForestGreen.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.naturalTeal,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
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
    );
  }
}
