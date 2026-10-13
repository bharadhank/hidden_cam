import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../controllers/shield_animation_controller.dart';
import 'scan_rings_widget.dart';

class Shield3DWidget extends StatefulWidget {
  final ShieldState state;
  final double size;
  final bool showRings;
  final bool isReducedMotion;
  final VoidCallback? onTap;

  const Shield3DWidget({
    super.key,
    this.state = ShieldState.idle,
    this.size = 180,
    this.showRings = false,
    this.isReducedMotion = false,
    this.onTap,
  });

  @override
  State<Shield3DWidget> createState() => _Shield3DWidgetState();
}

class _Shield3DWidgetState extends State<Shield3DWidget>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late AnimationController _transitionController;

  @override
  void initState() {
    super.initState();

    // Idle floating / breathing rotation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    // Pulse for scanning & caution
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // State transition controller (200-450ms)
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _transitionController.forward();

    _updateAnimationState();
  }

  @override
  void didUpdateWidget(Shield3DWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _transitionController.reset();
      _transitionController.forward();
      _updateAnimationState();
    }
    if (oldWidget.isReducedMotion != widget.isReducedMotion) {
      _updateAnimationState();
    }
  }

  void _updateAnimationState() {
    if (widget.isReducedMotion || widget.state == ShieldState.paused) {
      _floatController.stop();
      _pulseController.stop();
      return;
    }

    switch (widget.state) {
      case ShieldState.idle:
      case ShieldState.greeting:
        _pulseController.stop();
        if (!_floatController.isAnimating) _floatController.repeat(reverse: true);
        break;
      case ShieldState.scanning:
      case ShieldState.processing:
      case ShieldState.caution:
        if (!_floatController.isAnimating) _floatController.repeat(reverse: true);
        if (!_pulseController.isAnimating) _pulseController.repeat(reverse: true);
        break;
      case ShieldState.safe:
      case ShieldState.success:
        _floatController.stop();
        _pulseController.stop();
        break;
      case ShieldState.paused:
        _floatController.stop();
        _pulseController.stop();
        break;
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSize = widget.size;

    return GestureDetector(
      onTap: widget.onTap,
      child: Center(
        child: SizedBox(
          width: effectiveSize * (widget.showRings ? 1.6 : 1.1),
          height: effectiveSize * (widget.showRings ? 1.6 : 1.1),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ambient scanning rings when requested
              if (widget.showRings)
                ScanRingsWidget(
                  size: effectiveSize * 1.5,
                  isScanning: widget.state == ShieldState.scanning ||
                      widget.state == ShieldState.processing,
                  isReducedMotion: widget.isReducedMotion,
                  ringColor: widget.state == ShieldState.caution
                      ? AppColors.softAmber
                      : AppColors.naturalTeal,
                ),

              // Soft Aura Glow behind shield
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final glowColor = widget.state == ShieldState.caution
                      ? AppColors.softAmber.withValues(alpha: 0.28)
                      : widget.state == ShieldState.safe ||
                              widget.state == ShieldState.success
                          ? AppColors.softSageGreen.withValues(alpha: 0.35)
                          : AppColors.naturalTeal.withValues(alpha: 0.18);

                  final scale = widget.isReducedMotion
                      ? 1.0
                      : 1.0 + (_pulseController.value * 0.08);

                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: effectiveSize * 0.78,
                      height: effectiveSize * 0.78,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: glowColor,
                            blurRadius: 40,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Reusable 3D Shield with 3D Matrix Perspective Transformation
              AnimatedBuilder(
                animation: Listenable.merge([
                  _floatController,
                  _transitionController,
                ]),
                builder: (context, child) {
                  // Compute 3D rotation angles
                  double rotY = 0.0;
                  double rotX = 0.0;
                  double translateY = 0.0;

                  if (!widget.isReducedMotion) {
                    if (widget.state == ShieldState.idle ||
                        widget.state == ShieldState.greeting) {
                      rotY = math.sin(_floatController.value * math.pi * 2) * 0.12;
                      rotX = math.cos(_floatController.value * math.pi * 2) * 0.04;
                      translateY = math.sin(_floatController.value * math.pi * 2) * 4.0;
                    } else if (widget.state == ShieldState.scanning) {
                      rotY = math.sin(_floatController.value * math.pi * 4) * 0.08;
                      rotX = -0.05;
                    } else if (widget.state == ShieldState.processing) {
                      rotY = math.sin(_floatController.value * math.pi * 4) * 0.15;
                    }
                  }

                  // 3D perspective matrix
                  final transform = Matrix4.identity()
                    ..setEntry(3, 2, 0.0018) // Perspective distance
                    ..setTranslationRaw(0.0, translateY, 0.0)
                    ..rotateX(rotX)
                    ..rotateY(rotY);

                  return Transform(
                    transform: transform,
                    alignment: Alignment.center,
                    child: CustomPaint(
                      size: Size(effectiveSize, effectiveSize),
                      painter: _Shield3DPainter(
                        state: widget.state,
                        transitionProgress: _transitionController.value,
                        rotationY: rotY,
                      ),
                    ),
                  );
                },
              ),

              // State Badges: Subtle checkmark for SAFE, Amber indicator for CAUTION
              if (widget.state == ShieldState.safe ||
                  widget.state == ShieldState.success)
                Positioned(
                  bottom: effectiveSize * 0.14,
                  child: FadeTransition(
                    opacity: _transitionController,
                    child: Container(
                      width: effectiveSize * 0.28,
                      height: effectiveSize * 0.28,
                      decoration: BoxDecoration(
                        color: AppColors.naturalTeal,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.naturalTeal.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: effectiveSize * 0.18,
                      ),
                    ),
                  ),
                ),

              if (widget.state == ShieldState.caution)
                Positioned(
                  bottom: effectiveSize * 0.14,
                  child: FadeTransition(
                    opacity: _transitionController,
                    child: Container(
                      width: effectiveSize * 0.28,
                      height: effectiveSize * 0.28,
                      decoration: BoxDecoration(
                        color: AppColors.softAmber,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.softAmber.withValues(alpha: 0.5),
                            blurRadius: 14,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.priority_high_rounded,
                        color: Colors.white,
                        size: effectiveSize * 0.18,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Shield3DPainter extends CustomPainter {
  final ShieldState state;
  final double transitionProgress;
  final double rotationY;

  _Shield3DPainter({
    required this.state,
    required this.transitionProgress,
    required this.rotationY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // Dynamic light reflection shift based on 3D rotation
    final lightOffset = Offset(
      center.dx - (rotationY * w * 0.8),
      center.dy - (h * 0.35),
    );

    // 1. Shadow beneath the shield
    final shadowPath = _createShieldPath(w * 0.94, h * 0.94, center.translate(0, 8));
    final shadowPaint = Paint()
      ..color = AppColors.deepForestGreen.withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    canvas.drawPath(shadowPath, shadowPaint);

    // 2. Outer Bevel Rim (Deep Forest Green #23483F)
    final outerPath = _createShieldPath(w * 0.90, h * 0.90, center);
    final outerShader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF2C564B),
        AppColors.deepForestGreen,
        const Color(0xFF17332C),
      ],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final outerPaint = Paint()
      ..shader = outerShader
      ..style = PaintingStyle.fill;
    canvas.drawPath(outerPath, outerPaint);

    // 3. Raised Edge (Natural Teal #4F8F89)
    final raisedEdgePath = _createShieldPath(w * 0.82, h * 0.82, center);
    final raisedShader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF67AAA3),
        AppColors.naturalTeal,
        const Color(0xFF386D67),
      ],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final raisedPaint = Paint()
      ..shader = raisedShader
      ..style = PaintingStyle.fill;
    canvas.drawPath(raisedEdgePath, raisedPaint);

    // 4. Inner Recessed Face (Deep Forest Green Body)
    final innerFacePath = _createShieldPath(w * 0.72, h * 0.72, center);
    final innerShader = RadialGradient(
      center: Alignment(
        (lightOffset.dx - center.dx) / (w / 2),
        (lightOffset.dy - center.dy) / (h / 2),
      ),
      radius: 0.85,
      colors: [
        const Color(0xFF315C50),
        AppColors.deepForestGreen,
        const Color(0xFF17352D),
      ],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final innerPaint = Paint()
      ..shader = innerShader
      ..style = PaintingStyle.fill;
    canvas.drawPath(innerFacePath, innerPaint);

    // Inner bevel highlight line
    final innerStroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(innerFacePath, innerStroke);

    // 5. Inset Leaf Details (Warm Cream #F7F3E8 and Soft Sage Green #A8C3A0)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    final leafScale = (w / 120.0) * 0.65;
    canvas.scale(leafScale, leafScale);

    // Outer leaf arc in Warm Cream
    final leafCreamPath = Path();
    leafCreamPath.moveTo(0, -22);
    leafCreamPath.cubicTo(-15, -12, -20, 4, -18, 18);
    leafCreamPath.cubicTo(-16, 30, -8, 40, 0, 44);
    leafCreamPath.cubicTo(-5, 34, -6, 22, -4, 10);
    leafCreamPath.cubicTo(-2, 0, 4, -10, 12, -16);
    leafCreamPath.cubicTo(8, -20, 4, -22, 0, -22);
    leafCreamPath.close();

    final creamPaint = Paint()
      ..color = AppColors.warmCream
      ..style = PaintingStyle.fill;
    canvas.drawPath(leafCreamPath, creamPaint);

    // Inner leaf arc in Soft Sage Green
    final leafSagePath = Path();
    leafSagePath.moveTo(0, -10);
    leafSagePath.cubicTo(-8, -2, -10, 10, -8, 22);
    leafSagePath.cubicTo(-6, 32, 0, 40, 0, 40);
    leafSagePath.cubicTo(4, 32, 10, 22, 8, 8);
    leafSagePath.cubicTo(6, -2, 2, -8, 0, -10);
    leafSagePath.close();

    final sagePaint = Paint()
      ..color = AppColors.softSageGreen
      ..style = PaintingStyle.fill;
    canvas.drawPath(leafSagePath, sagePaint);

    canvas.restore();

    // 6. Specular Glare Arc (Realistic Light Reflection)
    final specularPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.35),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(w * 0.2, h * 0.15, w * 0.4, h * 0.35))
      ..style = PaintingStyle.fill;

    final glarePath = Path()
      ..moveTo(center.dx, center.dy - (h * 0.34))
      ..cubicTo(
        center.dx - (w * 0.28),
        center.dy - (h * 0.34),
        center.dx - (w * 0.34),
        center.dy - (h * 0.15),
        center.dx - (w * 0.34),
        center.dy + (h * 0.05),
      )
      ..cubicTo(
        center.dx - (w * 0.15),
        center.dy - (h * 0.1),
        center.dx,
        center.dy - (h * 0.2),
        center.dx,
        center.dy - (h * 0.34),
      )
      ..close();

    canvas.drawPath(glarePath, specularPaint);
  }

  Path _createShieldPath(double width, double height, Offset center) {
    final path = Path();
    final halfW = width / 2;
    final halfH = height / 2;

    // Top center
    path.moveTo(center.dx, center.dy - halfH);

    // Top right shoulder
    path.cubicTo(
      center.dx + (halfW * 0.5),
      center.dy - halfH,
      center.dx + halfW,
      center.dy - (halfH * 0.75),
      center.dx + halfW,
      center.dy - (halfH * 0.25),
    );

    // Right flank down to bottom tip
    path.cubicTo(
      center.dx + halfW,
      center.dy + (halfH * 0.35),
      center.dx + (halfW * 0.5),
      center.dy + (halfH * 0.85),
      center.dx,
      center.dy + halfH,
    );

    // Left flank from bottom tip up
    path.cubicTo(
      center.dx - (halfW * 0.5),
      center.dy + (halfH * 0.85),
      center.dx - halfW,
      center.dy + (halfH * 0.35),
      center.dx - halfW,
      center.dy - (halfH * 0.25),
    );

    // Top left shoulder back to top center
    path.cubicTo(
      center.dx - halfW,
      center.dy - (halfH * 0.75),
      center.dx - (halfW * 0.5),
      center.dy - halfH,
      center.dx,
      center.dy - halfH,
    );

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _Shield3DPainter oldDelegate) {
    return oldDelegate.state != state ||
        oldDelegate.transitionProgress != transitionProgress ||
        oldDelegate.rotationY != rotationY;
  }
}
