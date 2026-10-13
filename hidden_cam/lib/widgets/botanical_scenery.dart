import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class BotanicalFooterFoliage extends StatelessWidget {
  final double height;
  final double opacity;

  const BotanicalFooterFoliage({
    super.key,
    this.height = 100,
    this.opacity = 0.85,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: CustomPaint(
        size: Size(double.infinity, height),
        painter: _BotanicalLeavesPainter(),
      ),
    );
  }
}

class _BotanicalLeavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background Soft Layer
    final bgFoliage1 = Path()
      ..moveTo(0, h)
      ..cubicTo(w * 0.05, h * 0.55, w * 0.18, h * 0.28, w * 0.35, h * 0.52)
      ..cubicTo(w * 0.48, h * 0.70, w * 0.58, h * 0.88, w * 0.68, h)
      ..close();
    canvas.drawPath(
      bgFoliage1,
      Paint()..color = AppColors.softSageGreen.withValues(alpha: 0.35),
    );

    final bgFoliage2 = Path()
      ..moveTo(w, h)
      ..cubicTo(w * 0.95, h * 0.45, w * 0.82, h * 0.18, w * 0.65, h * 0.42)
      ..cubicTo(w * 0.52, h * 0.65, w * 0.42, h * 0.85, w * 0.32, h)
      ..close();
    canvas.drawPath(
      bgFoliage2,
      Paint()..color = AppColors.naturalTeal.withValues(alpha: 0.30),
    );

    // Left Leaf Fronds
    final leftLeaf1 = Path()
      ..moveTo(w * 0.08, h)
      ..cubicTo(w * 0.08, h * 0.65, w * 0.15, h * 0.40, w * 0.26, h * 0.38)
      ..cubicTo(w * 0.24, h * 0.65, w * 0.18, h * 0.88, w * 0.08, h)
      ..close();
    canvas.drawPath(
      leftLeaf1,
      Paint()..color = AppColors.deepForestGreen.withValues(alpha: 0.50),
    );

    final leftLeaf2 = Path()
      ..moveTo(0, h)
      ..cubicTo(w * 0.02, h * 0.72, w * 0.08, h * 0.52, w * 0.18, h * 0.50)
      ..cubicTo(w * 0.16, h * 0.72, w * 0.10, h * 0.90, 0, h)
      ..close();
    canvas.drawPath(
      leftLeaf2,
      Paint()..color = AppColors.naturalTeal.withValues(alpha: 0.60),
    );

    // Right Leaf Fronds
    final rightLeaf1 = Path()
      ..moveTo(w * 0.92, h)
      ..cubicTo(w * 0.92, h * 0.65, w * 0.85, h * 0.40, w * 0.74, h * 0.38)
      ..cubicTo(w * 0.76, h * 0.65, w * 0.82, h * 0.88, w * 0.92, h)
      ..close();
    canvas.drawPath(
      rightLeaf1,
      Paint()..color = AppColors.deepForestGreen.withValues(alpha: 0.50),
    );

    final rightLeaf2 = Path()
      ..moveTo(w, h)
      ..cubicTo(w * 0.98, h * 0.72, w * 0.92, h * 0.52, w * 0.82, h * 0.50)
      ..cubicTo(w * 0.84, h * 0.72, w * 0.90, h * 0.90, w, h)
      ..close();
    canvas.drawPath(
      rightLeaf2,
      Paint()..color = AppColors.naturalTeal.withValues(alpha: 0.60),
    );

    // Center Sprout
    final sprout = Path()
      ..moveTo(w * 0.50, h)
      ..cubicTo(w * 0.48, h * 0.82, w * 0.45, h * 0.70, w * 0.41, h * 0.65)
      ..cubicTo(w * 0.45, h * 0.75, w * 0.48, h * 0.88, w * 0.50, h)
      ..cubicTo(w * 0.52, h * 0.82, w * 0.55, h * 0.70, w * 0.59, h * 0.65)
      ..cubicTo(w * 0.55, h * 0.75, w * 0.52, h * 0.88, w * 0.50, h)
      ..close();
    canvas.drawPath(
      sprout,
      Paint()..color = AppColors.deepForestGreen.withValues(alpha: 0.40),
    );
  }

  @override
  bool shouldRepaint(covariant _BotanicalLeavesPainter oldDelegate) => false;
}
