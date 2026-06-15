// ============================================================
// splash_screen.dart — App Splash / Loading Screen
// ============================================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../themes/app_theme.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    Navigator.of(context).pushReplacementNamed(
      auth.isLoggedIn ? HomeScreen.routeName : LoginScreen.routeName,
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110, height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryPurple, AppTheme.accentCyan],
                    ),
                    boxShadow: [BoxShadow(
                      color: AppTheme.primaryPurple.withOpacity(0.6),
                      blurRadius: 40, spreadRadius: 8,
                    )],
                  ),
                  child: const Icon(Icons.checkroom_rounded, size: 54, color: Colors.white),
                ),
                const SizedBox(height: 24),
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [AppTheme.primaryPurple, AppTheme.accentCyan],
                  ).createShader(b),
                  child: const Text(
                    'Virtual Try-On AI',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('AI-Powered Fashion', style: TextStyle(color: Colors.white38, fontSize: 14)),
                const SizedBox(height: 48),
                const CircularProgressIndicator(color: AppTheme.primaryPurple),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
