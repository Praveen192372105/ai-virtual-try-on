// ============================================================
// profile_screen.dart — User Profile Screen (Stub)
// ============================================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/glass_card.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(title: const Text('My Profile'), backgroundColor: Colors.transparent),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryPurple,
              child: Text(
                user?.name[0].toUpperCase() ?? 'U',
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(user?.name ?? 'User', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(user?.email ?? '', style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 32),
            GlassCard(child: Column(children: [
              _menuItem(Icons.shopping_bag_outlined, 'My Orders', () {}),
              _menuItem(Icons.favorite_border, 'Wishlist', () {}),
              _menuItem(Icons.history, 'Try-On History', () {}),
              _menuItem(Icons.settings_outlined, 'Settings', () {}),
              _menuItem(Icons.logout, 'Logout', () async {
                await auth.logout();
                if (context.mounted) Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              }, color: AppTheme.errorColor),
            ])),
          ]),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white70),
      title: Text(label, style: TextStyle(color: color ?? Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
      onTap: onTap,
    );
  }
}
