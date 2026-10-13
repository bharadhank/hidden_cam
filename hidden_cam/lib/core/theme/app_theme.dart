import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme().apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.warmCream,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.naturalTeal,
        onPrimary: Colors.white,
        secondary: AppColors.softSageGreen,
        onSecondary: AppColors.deepForestGreen,
        error: AppColors.mutedCoral,
        onError: Colors.white,
        surface: AppColors.warmCream,
        onSurface: AppColors.deepForestGreen,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        outline: AppColors.outline,
      ),
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.deepForestGreen,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: AppColors.deepForestGreen,
          letterSpacing: -0.4,
          height: 1.25,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.deepForestGreen,
          letterSpacing: -0.2,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.deepForestGreen,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.deepForestGreen,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          fontSize: 15,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontSize: 13,
          color: AppColors.textSecondary,
          height: 1.45,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          fontSize: 12,
          color: AppColors.textTertiary,
          height: 1.4,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        labelMedium: textTheme.labelMedium?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: textTheme.labelSmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.warmCream.withValues(alpha: 0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.deepForestGreen, size: 22),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.deepForestGreen,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineLight,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
