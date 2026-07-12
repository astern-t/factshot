import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../theme/liquid_glass_theme.dart';
import '../widgets/factshot_background.dart';
import '../widgets/glass_surface.dart';
import '../widgets/transition_helper.dart';
import 'main_navigation.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _timer = Timer(const Duration(milliseconds: 2200), () {
      if (!mounted) {
        return;
      }
      final state = AppScope.of(context);
      final next = state.hasCompletedOnboarding
          ? const MainNavigation()
          : const OnboardingScreen();
      Navigator.of(context).pushReplacement(GlassPageRoute(page: next));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: FactShotBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.98 + (_controller.value * 0.03),
                      child: GlassSurface(
                        width: 152,
                        height: 152,
                        radius: LiquidGlassTheme.radius32,
                        level: GlassLevel.strong,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: accent.withValues(alpha: 0.14),
                              ),
                            ),
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  begin: Alignment(
                                    -1 + (_controller.value * 2),
                                    -0.4,
                                  ),
                                  end: Alignment(
                                    1 + (_controller.value * 2),
                                    0.4,
                                  ),
                                  colors: const [
                                    Colors.transparent,
                                    Colors.white38,
                                    Colors.white,
                                    Colors.transparent,
                                  ],
                                ).createShader(bounds);
                              },
                              child: const Icon(
                                Icons.bolt_rounded,
                                color: Colors.white,
                                size: 76,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: LiquidGlassTheme.space32),
                Text('FACTSHOT', style: LiquidGlassTheme.display),
                const SizedBox(height: LiquidGlassTheme.space12),
                Text(
                  'FAST SIGNAL. ZERO CLUTTER.',
                  style: LiquidGlassTheme.overline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
