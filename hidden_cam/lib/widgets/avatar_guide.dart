import 'package:flutter/material.dart';
import 'dart:math' as math;

enum AvatarState {
  idle,
  greeting,
  explaining,
  pointing,
  thinking,
  scanning,
  safe,
  caution,
  warning,
  success
}

class AvatarGuide extends StatefulWidget {
  final AvatarState state;
  final String? speechText;
  final bool isReducedMotion;

  const AvatarGuide({
    super.key,
    this.state = AvatarState.idle,
    this.speechText,
    this.isReducedMotion = false,
  });

  @override
  State<AvatarGuide> createState() => _AvatarGuideState();
}

class _AvatarGuideState extends State<AvatarGuide> with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late AnimationController _transitionController;

  @override
  void initState() {
    super.initState();
    
    // Idle breathing animation
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    // State transition animation
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _transitionController.forward();
  }

  @override
  void didUpdateWidget(AvatarGuide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state || oldWidget.speechText != widget.speechText) {
      _transitionController.reset();
      _transitionController.forward();
    }
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  Color _getAvatarColor() {
    switch (widget.state) {
      case AvatarState.caution:
        return const Color(0xFFFFC07F); // Soft Amber
      case AvatarState.warning:
        return const Color(0xFFE57373); // Muted Coral
      case AvatarState.safe:
      case AvatarState.success:
        return const Color(0xFF9CA986); // Soft Sage Green
      case AvatarState.scanning:
        return const Color(0xFF00D2FF); // Focus color
      default:
        return const Color(0xFF4A7C59); // Natural Teal
    }
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.speechText != null && widget.speechText!.isNotEmpty)
          FadeTransition(
            opacity: _transitionController,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _transitionController,
                curve: Curves.easeOutBack,
              )),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 15,
                      spreadRadius: -5,
                      offset: const Offset(0, 5),
                    )
                  ],
                  border: Border.all(color: const Color(0xFF4A7C59).withAlpha(30)),
                ),
                child: Text(
                  widget.speechText!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E3F20),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        AnimatedBuilder(
          animation: Listenable.merge([_breatheController, _transitionController]),
          builder: (context, child) {
            // Apply breathing (scale) only if reduced motion is false
            final scale = widget.isReducedMotion
                ? 1.0
                : 1.0 + (_breatheController.value * 0.03);
            
            // Apply a slight tilt based on state
            double rotation = 0;
            if (!widget.isReducedMotion) {
              if (widget.state == AvatarState.thinking) {
                rotation = 0.1; // Slight head tilt
              } else if (widget.state == AvatarState.scanning) {
                rotation = -0.05 * math.sin(_breatheController.value * math.pi * 2);
              }
            }

            return Transform.scale(
              scale: scale,
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: rotation,
                alignment: Alignment.center,
                child: TweenAnimationBuilder<Color?>(
                tween: ColorTween(begin: _getAvatarColor(), end: _getAvatarColor()),
                duration: const Duration(milliseconds: 400),
                builder: (context, color, _) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color?.withAlpha(40),
                      border: Border.all(color: color ?? Colors.green, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: (color ?? Colors.green).withAlpha(widget.state == AvatarState.scanning ? 100 : 40),
                          blurRadius: widget.state == AvatarState.scanning ? 30 : 20,
                          spreadRadius: widget.state == AvatarState.scanning ? 10 : 2,
                        )
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/images/avatar.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              ),
            );
          },
        ),
      ],
    );
  }
}
