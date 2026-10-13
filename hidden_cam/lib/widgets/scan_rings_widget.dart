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
      duration: const Duration(milliseconds: 2600),
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
          painter: _DynamicScanRingsPainter(
            progress: _controller.value,
            color: widget.ringColor,
          ),
        );
      },
    );
  }
}

class _DynamicScanRingsPainter extends CustomPainter {
  final double progress;
  final Color color;

  _DynamicScanRingsPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // 3 Concentric Expanding Wave Rings
    for (int i = 0; i < 3; i++) {
      final ringProgress = (progress + (i * 0.33)) % 1.0;
      final radius = 30 + ringProgress * (maxRadius - 30);
      final opacity = (1.0 - ringProgress).clamp(0.0, 1.0) * 0.45;

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, paint);

      // Soft ambient fill aura on the innermost wave
      if (i == 0 && opacity > 0.1) {
        final fillPaint = Paint()
          ..color = color.withValues(alpha: opacity * 0.15)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, radius, fillPaint);
      }
    }

    // Gentle rotating radar sweep arm
    final sweepAngle = progress * 2 * math.pi;
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: math.pi / 2,
        colors: [
          color.withValues(alpha: 0.25),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(sweepAngle);
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: maxRadius * 0.9),
      0,
      math.pi / 2,
      true,
      sweepPaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DynamicScanRingsPainter oldDelegate) {
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
