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
  late AnimationController _laserScanController;
  late AnimationController _dragSpringController;

  // Touch drag 3D rotation angles
  double _dragTiltX = 0.0;
  double _dragTiltY = 0.0;
  double _springStartTiltX = 0.0;
  double _springStartTiltY = 0.0;

  @override
  void initState() {
    super.initState();

    // Floating compound 3D oscillation (Lissajous curve)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    // Pulse for scanning & caution
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Laser scanner vertical sweep
    _laserScanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // State transition controller
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _transitionController.forward();

    // Spring return animation when user releases finger drag
    _dragSpringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() {
        final curve = Curves.elasticOut.transform(_dragSpringController.value);
        setState(() {
          _dragTiltX = _springStartTiltX * (1.0 - curve);
          _dragTiltY = _springStartTiltY * (1.0 - curve);
        });
      });

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
      _laserScanController.stop();
      return;
    }

    switch (widget.state) {
      case ShieldState.idle:
      case ShieldState.greeting:
        _pulseController.stop();
        _laserScanController.stop();
        if (!_floatController.isAnimating) _floatController.repeat();
        break;
      case ShieldState.scanning:
      case ShieldState.processing:
        if (!_floatController.isAnimating) _floatController.repeat();
        if (!_pulseController.isAnimating) _pulseController.repeat(reverse: true);
        if (!_laserScanController.isAnimating) _laserScanController.repeat(reverse: true);
        break;
      case ShieldState.caution:
        _laserScanController.stop();
        if (!_floatController.isAnimating) _floatController.repeat();
        if (!_pulseController.isAnimating) _pulseController.repeat(reverse: true);
        break;
      case ShieldState.safe:
      case ShieldState.success:
      case ShieldState.paused:
        _floatController.stop();
        _pulseController.stop();
        _laserScanController.stop();
        break;
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    _laserScanController.dispose();
    _transitionController.dispose();
    _dragSpringController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.isReducedMotion) return;
    _dragSpringController.stop();
    setState(() {
      // Sensible tilt responsiveness
      _dragTiltY = (_dragTiltY + details.delta.dx * 0.008).clamp(-0.45, 0.45);
      _dragTiltX = (_dragTiltX - details.delta.dy * 0.008).clamp(-0.35, 0.35);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.isReducedMotion) return;
    _springStartTiltX = _dragTiltX;
    _springStartTiltY = _dragTiltY;
    _dragSpringController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSize = widget.size;

    return GestureDetector(
      onTap: widget.onTap,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Center(
        child: SizedBox(
          width: effectiveSize * (widget.showRings ? 1.6 : 1.1),
          height: effectiveSize * (widget.showRings ? 1.6 : 1.1),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ambient 3D holographic scanning rings
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
                          : AppColors.naturalTeal.withValues(alpha: 0.22);

                  final scale = widget.isReducedMotion
                      ? 1.0
                      : 1.0 + (_pulseController.value * 0.08);

                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: effectiveSize * 0.82,
                      height: effectiveSize * 0.82,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: glowColor,
                            blurRadius: 45,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Volumetric 3D Shield with 3D Matrix Perspective & Extrusion
              AnimatedBuilder(
                animation: Listenable.merge([
                  _floatController,
                  _laserScanController,
                  _transitionController,
                ]),
                builder: (context, child) {
                  final floatVal = _floatController.value * 2 * math.pi;

                  // Compound 3D Lissajous floating motion
                  double autoRotY = 0.0;
                  double autoRotX = 0.0;
                  double autoRotZ = 0.0;
                  double translateY = 0.0;

                  if (!widget.isReducedMotion) {
                    if (widget.state == ShieldState.idle ||
                        widget.state == ShieldState.greeting) {
                      autoRotY = math.sin(floatVal) * 0.18;
                      autoRotX = math.cos(floatVal * 0.7) * 0.08;
                      autoRotZ = math.sin(floatVal * 0.5) * 0.03;
                      translateY = math.sin(floatVal) * 5.0;
                    } else if (widget.state == ShieldState.scanning ||
                        widget.state == ShieldState.processing) {
                      // Energetic scanning hover
                      autoRotY = math.sin(floatVal * 1.5) * 0.22;
                      autoRotX = math.cos(floatVal * 1.2) * 0.10;
                      autoRotZ = math.sin(floatVal * 0.8) * 0.04;
                      translateY = math.sin(floatVal * 2.0) * 4.0;
                    } else if (widget.state == ShieldState.caution) {
                      autoRotY = math.sin(floatVal * 2.5) * 0.12;
                      autoRotX = 0.06;
                      translateY = math.sin(floatVal * 1.5) * 3.0;
                    }
                  }

                  final totalRotX = autoRotX + _dragTiltX;
                  final totalRotY = autoRotY + _dragTiltY;
                  final totalRotZ = autoRotZ + (_dragTiltY * 0.1);

                  // 3D perspective matrix
                  final transform = Matrix4.identity()
                    ..setEntry(3, 2, 0.002) // Natural perspective distance
                    ..setTranslationRaw(0.0, translateY, 0.0)
                    ..rotateX(totalRotX)
                    ..rotateY(totalRotY)
                    ..rotateZ(totalRotZ);

                  return Transform(
                    transform: transform,
                    alignment: Alignment.center,
                    child: CustomPaint(
                      size: Size(effectiveSize, effectiveSize),
                      painter: _VolumetricShield3DPainter(
                        state: widget.state,
                        transitionProgress: _transitionController.value,
                        rotationX: totalRotX,
                        rotationY: totalRotY,
                        laserScanProgress: _laserScanController.value,
                      ),
                    ),
                  );
                },
              ),

              // State Badges
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
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_rounded,
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
                            offset: const Offset(0, 4),
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

class _VolumetricShield3DPainter extends CustomPainter {
  final ShieldState state;
  final double transitionProgress;
  final double rotationX;
  final double rotationY;
  final double laserScanProgress;

  _VolumetricShield3DPainter({
    required this.state,
    required this.transitionProgress,
    required this.rotationX,
    required this.rotationY,
    required this.laserScanProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // 3D Extrusion offsets based on rotation
    final extrudeDx = math.sin(rotationY) * 9.0;
    final extrudeDy = -math.sin(rotationX) * 9.0;

    // Dynamic virtual light source position
    final lightOffset = Offset(
      center.dx - (rotationY * w * 0.9),
      center.dy - (h * 0.38) + (rotationX * h * 0.5),
    );

    // 1. Cast Floor Shadow (Moves in opposition to 3D tilt)
    final shadowOffset = Offset(-extrudeDx * 1.3, 14.0 - extrudeDy * 0.8);
    final floorShadowPath = _createShieldPath(w * 0.94, h * 0.94, center + shadowOffset);
    final floorShadowPaint = Paint()
      ..color = AppColors.deepForestGreen.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawPath(floorShadowPath, floorShadowPaint);

    // 2. 3D Extruded Chassis Slices (Creates Real Physical Depth / Bevel Thickness)
    const int extrusionSteps = 5;
    for (int step = extrusionSteps; step >= 1; step--) {
      final t = step / extrusionSteps;
      final sliceOffset = Offset(extrudeDx * t, extrudeDy * t);
      final slicePath = _createShieldPath(
        w * (0.90 + (0.015 * t)),
        h * (0.90 + (0.015 * t)),
        center + sliceOffset,
      );

      // Chassis dark graphite green with rim lighting
      final slicePaint = Paint()
        ..color = Color.lerp(
          const Color(0xFF0F241F),
          const Color(0xFF1D3F36),
          1.0 - t,
        )!
        ..style = PaintingStyle.fill;

      canvas.drawPath(slicePath, slicePaint);
    }

    // 3. Outer Titanium / Forest Bevel Rim (Front Face)
    final outerPath = _createShieldPath(w * 0.90, h * 0.90, center);
    final outerShader = LinearGradient(
      begin: Alignment(
        -1.0 - (rotationY * 1.5),
        -1.0 - (rotationX * 1.5),
      ),
      end: Alignment(
        1.0 + (rotationY * 1.5),
        1.0 + (rotationX * 1.5),
      ),
      colors: const [
        Color(0xFF38685C),
        Color(0xFF23483F),
        Color(0xFF16322B),
      ],
      stops: const [0.0, 0.45, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final outerPaint = Paint()
      ..shader = outerShader
      ..style = PaintingStyle.fill;
    canvas.drawPath(outerPath, outerPaint);

    // 4. Raised Luminous Metallic Edge (Natural Teal #4F8F89)
    final raisedEdgePath = _createShieldPath(w * 0.82, h * 0.82, center);
    final raisedShader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF88D2C9),
        AppColors.naturalTeal,
        const Color(0xFF2E655F),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final raisedPaint = Paint()
      ..shader = raisedShader
      ..style = PaintingStyle.fill;
    canvas.drawPath(raisedEdgePath, raisedPaint);

    // 5. Deep Concave Crystalline Emerald Face
    final innerFacePath = _createShieldPath(w * 0.72, h * 0.72, center);
    final innerShader = RadialGradient(
      center: Alignment(
        (lightOffset.dx - center.dx) / (w / 2),
        (lightOffset.dy - center.dy) / (h / 2),
      ),
      radius: 0.95,
      colors: [
        state == ShieldState.caution
            ? const Color(0xFF5A4418)
            : const Color(0xFF32685A),
        AppColors.deepForestGreen,
        const Color(0xFF102720),
      ],
      stops: const [0.0, 0.65, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final innerPaint = Paint()
      ..shader = innerShader
      ..style = PaintingStyle.fill;
    canvas.drawPath(innerFacePath, innerPaint);

    // Inner bevel highlight stroke
    final innerStroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawPath(innerFacePath, innerStroke);

    // 6. Active Holographic 3D Laser Scan Line (Sweeps across the shield)
    if (state == ShieldState.scanning || state == ShieldState.processing) {
      canvas.save();
      canvas.clipPath(innerFacePath);

      final scanY = (center.dy - (h * 0.35)) + (laserScanProgress * (h * 0.70));

      // Laser Glow Curtain
      final curtainPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.naturalTeal.withValues(alpha: 0.35),
            Colors.white.withValues(alpha: 0.75),
            AppColors.naturalTeal.withValues(alpha: 0.15),
            Colors.transparent,
          ],
          stops: const [0.0, 0.42, 0.5, 0.58, 1.0],
        ).createShader(Rect.fromLTWH(0, scanY - 24, w, 48));

      canvas.drawRect(Rect.fromLTWH(0, scanY - 24, w, 48), curtainPaint);

      // Bright Core Laser Beam
      final laserCorePaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(0, scanY), Offset(w, scanY), laserCorePaint);

      canvas.restore();
    }

    // 7. Inset 3D Leaf Logo (Floating above shield bed with parallax)
    final leafParallax = Offset(-rotationY * 3.5, rotationX * 3.5);
    canvas.save();
    canvas.translate(center.dx + leafParallax.dx, center.dy + leafParallax.dy);

    final leafScale = (w / 120.0) * 0.65;
    canvas.scale(leafScale, leafScale);

    // Leaf drop shadow for stereoscopic 3D floating effect
    final leafShadow = Path();
    leafShadow.moveTo(1, -21);
    leafShadow.cubicTo(-14, -11, -19, 5, -17, 19);
    leafShadow.cubicTo(-15, 31, -7, 41, 1, 45);
    leafShadow.cubicTo(-4, 35, -5, 23, -3, 11);
    leafShadow.cubicTo(-1, 1, 5, -9, 13, -15);
    leafShadow.cubicTo(9, -19, 5, -21, 1, -21);
    leafShadow.close();

    final leafShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawPath(leafShadow, leafShadowPaint);

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
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFFFF),
          AppColors.warmCream,
          Color(0xFFE4DCBF),
        ],
      ).createShader(const Rect.fromLTWH(-20, -22, 40, 66))
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
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFC4E0BD),
          AppColors.softSageGreen,
          Color(0xFF7E9D75),
        ],
      ).createShader(const Rect.fromLTWH(-10, -10, 20, 50))
      ..style = PaintingStyle.fill;
    canvas.drawPath(leafSagePath, sagePaint);

    canvas.restore();

    // 8. 3D Curved Specular Glass Glare (Slides dynamically across the lens)
    final glareShiftX = -rotationY * (w * 0.35);
    final glareShiftY = rotationX * (h * 0.25);

    final specularPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.42),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.85],
      ).createShader(
        Rect.fromLTWH(
          (w * 0.2) + glareShiftX,
          (h * 0.15) + glareShiftY,
          w * 0.45,
          h * 0.38,
        ),
      )
      ..style = PaintingStyle.fill;

    final glarePath = Path()
      ..moveTo(center.dx + glareShiftX, center.dy - (h * 0.34) + glareShiftY)
      ..cubicTo(
        center.dx - (w * 0.28) + glareShiftX,
        center.dy - (h * 0.34) + glareShiftY,
        center.dx - (w * 0.34) + glareShiftX,
        center.dy - (h * 0.15) + glareShiftY,
        center.dx - (w * 0.34) + glareShiftX,
        center.dy + (h * 0.05) + glareShiftY,
      )
      ..cubicTo(
        center.dx - (w * 0.15) + glareShiftX,
        center.dy - (h * 0.1) + glareShiftY,
        center.dx + glareShiftX,
        center.dy - (h * 0.2) + glareShiftY,
        center.dx + glareShiftX,
        center.dy - (h * 0.34) + glareShiftY,
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
  bool shouldRepaint(covariant _VolumetricShield3DPainter oldDelegate) {
    return oldDelegate.state != state ||
        oldDelegate.transitionProgress != transitionProgress ||
        oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.laserScanProgress != laserScanProgress;
  }
}
