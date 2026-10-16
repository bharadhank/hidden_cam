import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ScanRingsWidget extends StatefulWidget {
  final double size;
  final bool isScanning;
  final bool isReducedMotion;
  final Color ringColor;

  const ScanRingsWidget({
    super.key,
    this.size = 280,
    this.isScanning = true,
    this.isReducedMotion = false,
    this.ringColor = AppColors.naturalTeal,
  });

  @override
  State<ScanRingsWidget> createState() => _ScanRingsWidgetState();
}

class _ScanRingsWidgetState extends State<ScanRingsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    if (!widget.isReducedMotion && widget.isScanning) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ScanRingsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isReducedMotion || !widget.isScanning) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isReducedMotion) {
      return CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _StaticScanRingsPainter(color: widget.ringColor),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _Holographic3DRingsPainter(
            progress: _controller.value,
            color: widget.ringColor,
          ),
        );
      },
    );
  }
}

class _Holographic3DRingsPainter extends CustomPainter {
  final double progress;
  final Color color;

  _Holographic3DRingsPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.44;

    // 1. Ambient Expanding Radar Waves (Sonar Pulse)
    for (int i = 0; i < 3; i++) {
      final waveProg = (progress + (i * 0.333)) % 1.0;
      final waveRadius = baseRadius * 0.25 + (waveProg * baseRadius * 0.75);
      final waveAlpha = (math.sin(waveProg * math.pi) * 0.35).clamp(0.0, 1.0);

      final wavePaint = Paint()
        ..color = color.withValues(alpha: waveAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 + (1.0 - waveProg) * 1.5;

      canvas.drawCircle(center, waveRadius, wavePaint);

      // Soft ambient fill on the core pulse
      if (i == 0) {
        final fillPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: waveAlpha * 0.18),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: center, radius: waveRadius));
        canvas.drawCircle(center, waveRadius, fillPaint);
      }
    }

    // 2. Gimbal Ring A: 3D Elliptical Orbit (Tilted on X=60°, revolving around Z)
    _draw3DGimbalRing(
      canvas: canvas,
      center: center,
      radiusX: baseRadius * 0.88,
      radiusY: baseRadius * 0.38,
      rotationAngle: progress * 2 * math.pi,
      tiltAngle: -math.pi / 7,
      baseColor: color,
      particlePhase: progress * 2 * math.pi,
      numTicks: 24,
    );

    // 3. Gimbal Ring B: Counter-Rotating 3D Orbit (Tilted on X=-50°)
    _draw3DGimbalRing(
      canvas: canvas,
      center: center,
      radiusX: baseRadius * 0.74,
      radiusY: baseRadius * 0.32,
      rotationAngle: -progress * 2.2 * math.pi,
      tiltAngle: math.pi / 5,
      baseColor: color.withValues(alpha: 0.85),
      particlePhase: -progress * 2.5 * math.pi + math.pi,
      numTicks: 16,
    );

    // 4. Gimbal Ring C: Inner Swift Gyro Ring
    _draw3DGimbalRing(
      canvas: canvas,
      center: center,
      radiusX: baseRadius * 0.58,
      radiusY: baseRadius * 0.22,
      rotationAngle: progress * 3.1 * math.pi + 1.2,
      tiltAngle: math.pi / 12,
      baseColor: AppColors.softSageGreen,
      particlePhase: progress * 3.1 * math.pi,
      numTicks: 12,
    );

    // 5. Floating Spatial Hologram Particles (Drifting in 3D Depth)
    final random = math.Random(42);
    for (int p = 0; p < 18; p++) {
      final angle = (p * (2 * math.pi / 18)) + (random.nextDouble() * 0.3);
      final distRatio = 0.3 + (random.nextDouble() * 0.65);
      final pRadius = baseRadius * distRatio;
      
      // Floating harmonic drift
      final driftProg = (progress * 2 * math.pi) + (p * 0.7);
      final zDepth = math.sin(driftProg + p); // -1 (far) to +1 (near)
      final x = center.dx + math.cos(angle + (progress * 0.5)) * pRadius;
      final y = center.dy + math.sin(angle + (progress * 0.5)) * pRadius * 0.7 + (math.sin(driftProg) * 6);

      final pScale = 0.7 + (zDepth * 0.35); // larger when closer
      final pAlpha = ((0.3 + (zDepth * 0.35)) * 0.7).clamp(0.08, 0.75);

      final pPaint = Paint()
        ..color = (p % 3 == 0 ? AppColors.softSageGreen : color).withValues(alpha: pAlpha);

      canvas.drawCircle(Offset(x, y), 1.8 * pScale, pPaint);

      // Glowing halos for nearest particles
      if (zDepth > 0.4) {
        final haloPaint = Paint()
          ..color = color.withValues(alpha: pAlpha * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(Offset(x, y), 4.5 * pScale, haloPaint);
      }
    }
  }

  void _draw3DGimbalRing({
    required Canvas canvas,
    required Offset center,
    required double radiusX,
    required double radiusY,
    required double rotationAngle,
    required double tiltAngle,
    required Color baseColor,
    required double particlePhase,
    required int numTicks,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(tiltAngle);

    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: radiusX * 2,
      height: radiusY * 2,
    );

    // 3D Depth shading on the ring track
    final ringShader = SweepGradient(
      transform: GradientRotation(rotationAngle),
      colors: [
        baseColor.withValues(alpha: 0.05),
        baseColor.withValues(alpha: 0.45),
        baseColor.withValues(alpha: 0.12),
        baseColor.withValues(alpha: 0.55),
        baseColor.withValues(alpha: 0.05),
      ],
      stops: const [0.0, 0.28, 0.5, 0.78, 1.0],
    ).createShader(rect);

    final trackPaint = Paint()
      ..shader = ringShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    canvas.drawOval(rect, trackPaint);

    // Orbital Tech Tick Marks along the 3D Ellipse
    final tickPaint = Paint()
      ..color = baseColor.withValues(alpha: 0.3)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (int t = 0; t < numTicks; t++) {
      final theta = (t * (2 * math.pi / numTicks)) + rotationAngle;
      final cosT = math.cos(theta);
      final sinT = math.sin(theta);
      
      final px = radiusX * cosT;
      final py = radiusY * sinT;
      
      // Slight outward tick normal
      final tickLen = (t % 4 == 0) ? 4.0 : 2.0;
      final tx = px + (cosT * tickLen);
      final ty = py + (sinT * tickLen);

      canvas.drawLine(Offset(px, py), Offset(tx, ty), tickPaint);
    }

    // Glowing Orbital Energy Node (Satellite Orb) traveling along the 3D track
    final nodeX = radiusX * math.cos(particlePhase);
    final nodeY = radiusY * math.sin(particlePhase);
    // Depth: When sin(particlePhase) > 0, it is in front of the center plane
    final isFront = math.sin(particlePhase) > 0;
    final nodeScale = isFront ? 1.3 : 0.8;
    final nodeAlpha = isFront ? 0.95 : 0.4;

    // Outer glow for the orb
    final glowPaint = Paint()
      ..color = baseColor.withValues(alpha: nodeAlpha * 0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(nodeX, nodeY), 6.0 * nodeScale, glowPaint);

    // Solid core
    final nodePaint = Paint()
      ..color = Colors.white.withValues(alpha: nodeAlpha);
    canvas.drawCircle(Offset(nodeX, nodeY), 2.8 * nodeScale, nodePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _Holographic3DRingsPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class _StaticScanRingsPainter extends CustomPainter {
  final Color color;

  _StaticScanRingsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, size.width * 0.25, paint);
    canvas.drawCircle(center, size.width * 0.38, paint);
    canvas.drawCircle(center, size.width * 0.48, paint);
  }

  @override
  bool shouldRepaint(covariant _StaticScanRingsPainter oldDelegate) => false;
}

