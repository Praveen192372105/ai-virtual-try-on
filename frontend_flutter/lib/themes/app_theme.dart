// ============================================================
// app_theme.dart — Global Design System & Theme
// AI-Based Virtual Try-On Application
// ============================================================
// PURPOSE:
//   Defines all colors, text styles, component themes for the
//   futuristic glassmorphic dark theme used throughout the app.
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._(); // Prevent instantiation

  // ── Brand Colors ──────────────────────────────────────────
  static const Color primaryPurple  = Color(0xFF7C3AED); // Vibrant violet
  static const Color accentCyan     = Color(0xFF06B6D4); // Electric cyan
  static const Color accentPink     = Color(0xFFEC4899); // Hot pink accent
  static const Color accentGold     = Color(0xFFF59E0B); // Premium gold

  // ── Background Colors ─────────────────────────────────────
  static const Color backgroundDark  = Color(0xFF0A0A1A);
  static const Color surfaceDark     = Color(0xFF12122A);
  static const Color cardDark        = Color(0xFF1A1A35);

  // ── State Colors ──────────────────────────────────────────
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor   = Color(0xFFEF4444);

  // ── Gradients ─────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, accentCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A0A1A), Color(0xFF1A0A2E), Color(0xFF0D1B3E)],
  );

  // ── Dark Theme ────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary:   primaryPurple,
        secondary: accentCyan,
        error:     errorColor,
        surface:   surfaceDark,
        background: backgroundDark,
      ),

      // Typography — Google Fonts: Inter
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        headlineLarge: GoogleFonts.inter(
          fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16, color: Colors.white,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14, color: Colors.white70,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12, color: Colors.white54,
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
          elevation: 4,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryPurple, width: 1.5),
        ),
        labelStyle: const TextStyle(color: Colors.white54),
        hintStyle: const TextStyle(color: Colors.white38),
      ),

      // Chip Theme (for category filters)
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withOpacity(0.08),
        selectedColor: primaryPurple,
        labelStyle: const TextStyle(color: Colors.white),
        side: BorderSide(color: Colors.white.withOpacity(0.12)),
        shape: const StadiumBorder(),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF12122A),
        selectedItemColor: primaryPurple,
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
