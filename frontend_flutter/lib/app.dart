// ============================================================
// app.dart — Root Application Widget
// AI-Based Virtual Try-On Application
// ============================================================
// PURPOSE:
//   Defines the MaterialApp root widget.
//   Handles global theme configuration, route definitions,
//   and authentication-aware navigation (splash → login → home).
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'themes/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_screen.dart';
import 'screens/tryon_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/onboarding_screen.dart';

class VirtualTryOnApp extends StatelessWidget {
  const VirtualTryOnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return MaterialApp(
          // ── App Identity ──────────────────────────────────
          title: 'Virtual Try-On AI',
          debugShowCheckedModeBanner: false,

          // ── Global Theme ──────────────────────────────────
          // Dark glassmorphic futuristic theme defined in themes/app_theme.dart
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,

          // ── Initial Route ─────────────────────────────────
          // Always start with splash; it decides where to navigate
          initialRoute: SplashScreen.routeName,

          // ── Named Route Table ─────────────────────────────
          routes: {
            SplashScreen.routeName:    (_) => const SplashScreen(),
            OnboardingScreen.routeName:(_) => const OnboardingScreen(),
            LoginScreen.routeName:     (_) => const LoginScreen(),
            HomeScreen.routeName:      (_) => const HomeScreen(),
            ProductScreen.routeName:   (_) => const ProductScreen(),
            TryOnScreen.routeName:     (_) => const TryOnScreen(),
            CartScreen.routeName:      (_) => const CartScreen(),
            ProfileScreen.routeName:   (_) => const ProfileScreen(),
          },

          // ── 404 Fallback ──────────────────────────────────
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      },
    );
  }
}
