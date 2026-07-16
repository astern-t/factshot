import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/utils/transition_helper.dart';
import 'package:factshot/features/language/language_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  late final PageController _pageController;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      icon: CupertinoIcons.doc_plaintext,
      title: '60-Word News',
      description:
          'Absorb the daily news brief in short-form cards built for quick scanning and reading on the go.',
      orbColor: Color(0xFF5AB2FF),
    ),
    _OnboardingPageData(
      icon: CupertinoIcons.arrow_up_down,
      title: 'Swipe to Read',
      description:
          'Swipe up or down to read through articles smoothly, one story at a time with fluid transitions.',
      orbColor: Color(0xFF6366F1),
    ),
    _OnboardingPageData(
      icon: CupertinoIcons.slider_horizontal_3,
      title: 'Filter Topics',
      description:
          'Instantly filter articles by your favorite categories like Tech, Business, Sports, and India.',
      orbColor: Color(0xFFE879F9),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    HapticFeedback.lightImpact();
    if (_currentIndex == _pages.length - 1) {
      Navigator.of(
        context,
      ).pushReplacement(GlassPageRoute(page: const LanguageScreen()));
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _skip() {
    HapticFeedback.mediumImpact();
    Navigator.of(
      context,
    ).pushReplacement(GlassPageRoute(page: const LanguageScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final page = _pages[_currentIndex];

    return Scaffold(
      backgroundColor: LiquidGlassTheme.background,
      body: Stack(
        children: [
          // Dynamic immersive ambient background
          AnimatedPositioned(
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            top: _currentIndex == 0 ? -100 : (_currentIndex == 1 ? 200 : -50),
            right: _currentIndex == 0 ? -100 : (_currentIndex == 1 ? -200 : 50),
            child: _AnimatedAmbientOrb(
              color: page.orbColor,
              size: 400,
              isDark: isDark,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1100),
            curve: Curves.easeOutCubic,
            bottom: _currentIndex == 0
                ? -150
                : (_currentIndex == 1 ? -50 : -200),
            left: _currentIndex == 0 ? -100 : (_currentIndex == 1 ? 100 : -150),
            child: _AnimatedAmbientOrb(
              color: _pages[(_currentIndex + 1) % _pages.length].orbColor,
              size: 350,
              isDark: isDark,
            ),
          ),

          // Core content layer
          SafeArea(
            child: Column(
              children: [
                // Top skip button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: _skip,
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: LiquidGlassTheme.foregroundSoft,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final item = _pages[index];
                      return Center(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Premium glowing icon badge
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (isDark ? Colors.white : Colors.black)
                                      .withValues(alpha: 0.03),
                                  border: Border.all(
                                    color:
                                        (isDark ? Colors.white : Colors.black)
                                            .withValues(alpha: 0.05),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: item.orbColor.withValues(
                                        alpha: isDark ? 0.2 : 0.08,
                                      ),
                                      blurRadius: 24,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    item.icon,
                                    size: 36,
                                    color: isDark
                                        ? Colors.white
                                        : LiquidGlassTheme.foreground,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              // Title
                              Text(
                                item.title,
                                style: LiquidGlassTheme.display.copyWith(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1.8,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Description
                              Text(
                                item.description,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: LiquidGlassTheme.foregroundMuted,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom control row (Indicator + FAB)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    right: 32,
                    bottom: 48,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Smooth fluid page indicator
                      Row(
                        children: List.generate(_pages.length, (index) {
                          final isActive = index == _currentIndex;
                          return GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOutCubic,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              margin: const EdgeInsets.only(right: 8),
                              width: isActive ? 32 : 12,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? LiquidGlassTheme.foreground
                                    : LiquidGlassTheme.foregroundSoft.withValues(
                                        alpha: 0.3,
                                      ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          );
                        }),
                      ),

                      // Premium dynamic glass FAB
                      GestureDetector(
                        onTap: _next,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          width: _currentIndex == _pages.length - 1 ? 160 : 72,
                          height: 72,
                          child: GlassSurface(
                            radius: 36,
                            padding: EdgeInsets.zero,
                            tintColor: page.orbColor,
                            level: GlassLevel.strong,
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: _currentIndex == _pages.length - 1
                                    ? Text(
                                        'Get Started',
                                        key: const ValueKey('start'),
                                        style: TextStyle(
                                          color: LiquidGlassTheme.foreground,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          letterSpacing: -0.5,
                                        ),
                                      )
                                    : Icon(
                                        CupertinoIcons.arrow_right,
                                        key: const ValueKey('arrow'),
                                        color: LiquidGlassTheme.foreground,
                                        size: 28,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedAmbientOrb extends StatelessWidget {
  const _AnimatedAmbientOrb({
    required this.color,
    required this.size,
    required this.isDark,
  });

  final Color color;
  final double size;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeInOutCubic,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: isDark ? 0.22 : 0.12),
              blurRadius: size * 0.4,
              spreadRadius: size * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.orbColor,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color orbColor;
}
