import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../theme/liquid_glass_theme.dart';
import '../widgets/factshot_background.dart';
import '../widgets/factshot_controls.dart';
import '../widgets/glass_surface.dart';
import '../widgets/transition_helper.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_Slide> _slides = const [
    _Slide(
      title: 'Headline velocity, editorial restraint.',
      subtitle:
          'Absorb the day in disciplined short-form cards built for scanning, saving, and returning later.',
      imageUrl:
          'https://images.unsplash.com/photo-1504711434969-e33886168f5c?auto=format&fit=crop&q=80&w=1200',
      tag: 'SWIPE FEED',
      icon: Icons.auto_awesome_rounded,
    ),
    _Slide(
      title: 'Layered glass with real hierarchy.',
      subtitle:
          'Navigation, cards, tags, and controls now separate cleanly through blur depth, restrained tint, and motion.',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&q=80&w=1200',
      tag: 'LIQUID UI',
      icon: Icons.layers_rounded,
    ),
    _Slide(
      title: 'Personalize without losing focus.',
      subtitle:
          'Filter by category, search instantly, bookmark across screens, and switch the material mood app-wide.',
      imageUrl:
          'https://images.unsplash.com/photo-1457369804613-52c61a468e7d?auto=format&fit=crop&q=80&w=1200',
      tag: 'CONTROL LAYER',
      icon: Icons.tune_rounded,
    ),
  ];

  void _finish() {
    final state = AppScope.of(context);
    state.setOnboardingComplete();
    Navigator.of(
      context,
    ).pushReplacement(GlassPageRoute(page: const LoginScreen()));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: FactShotBackground(
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: LiquidGlassTheme.slow,
                child: Image.network(
                  _slides[_currentIndex].imageUrl,
                  key: ValueKey(_currentIndex),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) {
                      return child;
                    }
                    return Container(
                      color: LiquidGlassTheme.backgroundSecondary,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: LiquidGlassTheme.backgroundSecondary,
                    );
                  },
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      LiquidGlassTheme.background.withValues(alpha: 0.4),
                      LiquidGlassTheme.background.withValues(alpha: 0.72),
                      LiquidGlassTheme.background,
                    ],
                    stops: const [0, 0.45, 1],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(LiquidGlassTheme.space20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlassSurface(
                          radius: LiquidGlassTheme.radius20,
                          padding: const EdgeInsets.symmetric(
                            horizontal: LiquidGlassTheme.space16,
                            vertical: LiquidGlassTheme.space12,
                          ),
                          child: Text(
                            '${_currentIndex + 1}/${_slides.length}',
                            style: LiquidGlassTheme.caption,
                          ),
                        ),
                        GlassButton(label: 'Skip', onTap: _finish),
                      ],
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _slides.length,
                        onPageChanged: (value) {
                          setState(() {
                            _currentIndex = value;
                          });
                        },
                        itemBuilder: (context, index) {
                          final slide = _slides[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 56, bottom: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GlassSurface(
                                  width: 84,
                                  height: 84,
                                  radius: LiquidGlassTheme.radius24,
                                  level: GlassLevel.strong,
                                  child: Icon(
                                    slide.icon,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  slide.tag,
                                  style: LiquidGlassTheme.overline.copyWith(
                                    color: accent,
                                  ),
                                ),
                                const SizedBox(
                                  height: LiquidGlassTheme.space16,
                                ),
                                Text(
                                  slide.title,
                                  style: LiquidGlassTheme.display,
                                ),
                                const SizedBox(
                                  height: LiquidGlassTheme.space16,
                                ),
                                Text(
                                  slide.subtitle,
                                  style: LiquidGlassTheme.body,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        GlassSurface(
                          radius: LiquidGlassTheme.radius20,
                          padding: const EdgeInsets.symmetric(
                            horizontal: LiquidGlassTheme.space16,
                            vertical: LiquidGlassTheme.space16,
                          ),
                          child: Row(
                            children: List.generate(_slides.length, (index) {
                              final active = index == _currentIndex;
                              return AnimatedContainer(
                                duration: LiquidGlassTheme.regular,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: active ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: active
                                      ? accent
                                      : Colors.white.withValues(alpha: 0.24),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(width: LiquidGlassTheme.space12),
                        Expanded(
                          child: GlassButton(
                            label: _currentIndex == _slides.length - 1
                                ? 'Start Reading'
                                : 'Next',
                            icon: _currentIndex == _slides.length - 1
                                ? Icons.arrow_forward_rounded
                                : Icons.chevron_right_rounded,
                            isPrimary: true,
                            expanded: true,
                            onTap: () {
                              if (_currentIndex == _slides.length - 1) {
                                _finish();
                                return;
                              }
                              _pageController.nextPage(
                                duration: LiquidGlassTheme.slow,
                                curve: LiquidGlassTheme.emphasizedDecelerate,
                              );
                            },
                          ),
                        ),
                      ],
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

class _Slide {
  const _Slide({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tag,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final String tag;
  final IconData icon;
}
