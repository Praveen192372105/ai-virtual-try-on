// ============================================================
// onboarding_screen.dart — App Onboarding (First Launch)
// ============================================================
import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _ctrl = PageController();
  int _page = 0;

  final _pages = [
    _PageData(icon: Icons.camera_alt_rounded,    color: AppTheme.primaryPurple, title: 'Try Before You Buy', body: 'Use your phone camera to virtually try on any outfit instantly using AI.'),
    _PageData(icon: Icons.style_rounded,         color: AppTheme.accentCyan,   title: 'Thousands of Styles', body: 'Browse tops, dresses, jackets, and more from premium brands worldwide.'),
    _PageData(icon: Icons.shopping_bag_rounded,  color: AppTheme.accentPink,   title: 'Shop with Confidence', body: 'Order knowing exactly how it looks — returns reduced by 80%.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _ctrl,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemCount: _pages.length,
                  itemBuilder: (_, i) => _buildPage(_pages[i]),
                ),
              ),

              // Dots indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _page ? 24 : 8, height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: i == _page ? AppTheme.primaryPurple : Colors.white24,
                  ),
                )),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_page < _pages.length - 1) {
                        _ctrl.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                      } else {
                        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                      }
                    },
                    child: Text(_page < _pages.length - 1 ? 'Next' : 'Get Started'),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(_PageData data) => Padding(
    padding: const EdgeInsets.all(40),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120, height: 120,
          decoration: BoxDecoration(shape: BoxShape.circle,
            gradient: LinearGradient(colors: [data.color, data.color.withOpacity(0.4)]),
            boxShadow: [BoxShadow(color: data.color.withOpacity(0.4), blurRadius: 30, spreadRadius: 5)],
          ),
          child: Icon(data.icon, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 40),
        Text(data.title, textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 16),
        Text(data.body, textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.white60, height: 1.6)),
      ],
    ),
  );
}

class _PageData {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  const _PageData({required this.icon, required this.color, required this.title, required this.body});
}
