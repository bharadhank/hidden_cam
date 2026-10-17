import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../core/theme/app_colors.dart';
import 'guide_animation_state.dart';
import 'guide_fallback_widget.dart';

/// Contained Pre-rendered Video Widget for SafeLens Female Guide (Aria).
///
/// Designed for predictable, non-interactive sequences:
/// - Welcome greeting clip
/// - Onboarding explanation walkthroughs
/// - Instructional safety moments
///
/// Ensures contained video container with SafeLens warm palette, automatic
/// lifecycle pause on screen defocus, reduced-motion compliance, and
/// bulletproof fallback to [GuideFallbackWidget].
class FemaleGuideVideoWidget extends StatefulWidget {
  final String videoAssetPath;
  final GuideAnimationState fallbackState;
  final String? speechText;
  final double height;
  final double width;
  final bool autoPlay;
  final bool looping;
  final bool isReducedMotion;
  final VoidCallback? onVideoFinished;

  const FemaleGuideVideoWidget({
    super.key,
    required this.videoAssetPath,
    this.fallbackState = GuideAnimationState.greeting,
    this.speechText,
    this.height = 280,
    this.width = double.infinity,
    this.autoPlay = true,
    this.looping = true,
    this.isReducedMotion = false,
    this.onVideoFinished,
  });

  @override
  State<FemaleGuideVideoWidget> createState() => _FemaleGuideVideoWidgetState();
}

class _FemaleGuideVideoWidgetState extends State<FemaleGuideVideoWidget>
    with WidgetsBindingObserver {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!widget.isReducedMotion) {
      _initVideoPlayer();
    }
  }

  Future<void> _initVideoPlayer() async {
    try {
      final controller = VideoPlayerController.asset(widget.videoAssetPath);
      _videoController = controller;
      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }
      await controller.setLooping(widget.looping);
      await controller.setVolume(0.0); // Muted by default for peaceful serenity

      if (widget.onVideoFinished != null && !widget.looping) {
        controller.addListener(() {
          if (controller.value.position >= controller.value.duration) {
            widget.onVideoFinished?.call();
          }
        });
      }

      if (widget.autoPlay && !widget.isReducedMotion) {
        await controller.play();
      }

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('FemaleGuideVideoWidget init error: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_videoController == null || !_isInitialized) return;
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _videoController?.pause();
    } else if (state == AppLifecycleState.resumed && widget.autoPlay && !widget.isReducedMotion) {
      _videoController?.play();
    }
  }

  @override
  void didUpdateWidget(FemaleGuideVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isReducedMotion != oldWidget.isReducedMotion) {
      if (widget.isReducedMotion) {
        _videoController?.pause();
      } else if (_isInitialized && widget.autoPlay) {
        _videoController?.play();
      }
    }
    if (widget.videoAssetPath != oldWidget.videoAssetPath) {
      _videoController?.dispose();
      _isInitialized = false;
      _hasError = false;
      _initVideoPlayer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If reduced motion is preferred or video engine encountered an error, use 2D fallback
    if (widget.isReducedMotion || _hasError) {
      return GuideFallbackWidget(
        state: widget.fallbackState,
        speechText: widget.speechText,
        height: widget.height,
        width: widget.width,
        isReducedMotion: widget.isReducedMotion,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.speechText != null && widget.speechText!.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.outlineLight),
              boxShadow: [AppColors.softShadow],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.naturalTeal,
                  size: 16,
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
        Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.outlineLight, width: 1.5),
            boxShadow: [AppColors.softShadow],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isInitialized && _videoController != null)
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoController!.value.size.width,
                    height: _videoController!.value.size.height,
                    child: VideoPlayer(_videoController!),
                  ),
                )
              else
                // Loading placeholder
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.naturalTeal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Loading guide clip...',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

              // SafeLens subtle bottom brand ribbon
              Positioned(
                bottom: 8,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.deepForestGreen.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shield_rounded,
                        size: 11,
                        color: Colors.white70,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'SafeLens Guide',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
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
    );
  }
}
