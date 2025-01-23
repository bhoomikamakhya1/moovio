import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

import '../../../../router/app_route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation for text
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();

    // Navigate to the main screen after the animation ends
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.pushReplacementNamed(AppRouterName.main);  // Navigate using named route
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie animation
            SizedBox(
              width: 300,
              height: 300,
              child: Lottie.asset(
                'assets/animation.json',
                repeat: true,
                animate: true,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            // Fading text
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'Moovio',
                style: const TextStyle(
                  fontFamily: 'Courier New',
                  color: Colors.purple,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
