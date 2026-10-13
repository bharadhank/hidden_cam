import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette specified in SafeLens specification
  static const Color warmCream = Color(0xFFF7F3E8);
  static const Color softSageGreen = Color(0xFFA8C3A0);
  static const Color naturalTeal = Color(0xFF4F8F89);
  static const Color deepForestGreen = Color(0xFF23483F);
  static const Color softAmber = Color(0xFFD6A84F);
  static const Color mutedCoral = Color(0xFFC9786B);

  // Surface & Layering Tints (Serene Safeguard Identity)
  static const Color surface = warmCream;
  static const Color surfaceCard = Colors.white;
  static const Color surfaceContainer = Color(0xFFEDF5EA);
  static const Color surfaceContainerLow = Color(0xFFF2F7F0);
  static const Color surfaceContainerHigh = Color(0xFFD8E8D5);
  static const Color surfaceDim = Color(0xFFE2EADF);

  // Accents & Secondary Fills
  static const Color tealLight = Color(0xFFE3F1EF);
  static const Color tealDark = Color(0xFF1E5E57);
  static const Color sageLight = Color(0xFFEFF5EC);
  static const Color amberLight = Color(0xFFFBF4E4);
  static const Color coralLight = Color(0xFFFBEFEB);

  // Text & Content Hierarchy
  static const Color textPrimary = deepForestGreen;
  static const Color textSecondary = Color(0xFF536E67);
  static const Color textTertiary = Color(0xFF7E9790);
  static const Color textMuted = Color(0xFFA4B5B0);

  // Borders, Dividers & Outlines
  static const Color outline = Color(0xFFD7E2DC);
  static const Color outlineLight = Color(0xFFE6EFEA);

  // Soft Shadows
  static BoxShadow softShadow = BoxShadow(
    color: deepForestGreen.withValues(alpha: 0.05),
    blurRadius: 16,
    offset: const Offset(0, 4),
  );

  static BoxShadow elevatedShadow = BoxShadow(
    color: naturalTeal.withValues(alpha: 0.18),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );

  static BoxShadow amberGlow = BoxShadow(
    color: softAmber.withValues(alpha: 0.25),
    blurRadius: 24,
    offset: const Offset(0, 6),
  );
}
