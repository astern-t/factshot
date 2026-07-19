import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/features/home_feed/home_feed_screen.dart';
import 'package:factshot/features/profile/profile_screen.dart';
import 'package:factshot/features/search/search_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final GlobalKey<HomeFeedScreenState> _homeFeedKey =
      GlobalKey<HomeFeedScreenState>();
  int _currentTab = 0;

  late final List<Widget> _screens = [
    HomeFeedScreen(key: _homeFeedKey),
    SearchScreen(
      onCategorySelected: (category) {
        setState(() {
          _currentTab = 0;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _homeFeedKey.currentState?.setCategory(category);
        });
      },
    ),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color activeAccent = Color(
      0xFF1E88E5,
    ); // Apple-like vibrant blue from the reference image
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: LiquidGlassTheme.regular,
              switchInCurve: LiquidGlassTheme.emphasizedDecelerate,
              switchOutCurve: LiquidGlassTheme.emphasizedAccelerate,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.02),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey(_currentTab),
                child: _screens[_currentTab],
              ),
            ),
          ),

          // Protective bottom gradient scrim
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 120,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      LiquidGlassTheme.background.withValues(alpha: 0.5),
                      LiquidGlassTheme.background.withValues(alpha: 0.95),
                      LiquidGlassTheme.background,
                    ],
                    stops: const [0.0, 0.4, 0.8, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Ultra-Premium Floating Nav Bar exactly matching the reference image
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: GlassSurface(
                width: 340,
                height: 60,
                radius: 36,
                level: GlassLevel.subtle, // No shadow/elevation
                customFillColor: isDark
                    ? const Color(0xFF1C1C1E)
                    : const Color(0xFFFFFFFF),
                borderColor: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06),
                shadowColor: Colors.transparent, // Zero elevation
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Stack(
                  children: [
                    // The Blue Circular Indicator perfectly contained inside
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves
                          .easeInOutBack, // smoother, slightly curved slide
                      alignment: Alignment(-1 + (_currentTab * 1.0), 0),
                      child: FractionallySizedBox(
                        widthFactor: 1 / 3, // Since there are 3 tabs
                        child: Center(
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: activeAccent,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Icons Row
                    Row(
                      children: [
                        _NavItem(
                          icon: CupertinoIcons
                              .house, // Using standard outline icons like the image
                          active: _currentTab == 0,
                          onTap: () {
                            if (_currentTab != 0) {
                              HapticFeedback.lightImpact();
                            }
                            setState(() => _currentTab = 0);
                          },
                        ),
                        _NavItem(
                          icon: CupertinoIcons.compass,
                          active: _currentTab == 1,
                          onTap: () {
                            if (_currentTab != 1) {
                              HapticFeedback.lightImpact();
                            }
                            setState(() => _currentTab = 1);
                          },
                        ),
                        _NavItem(
                          icon: CupertinoIcons.person,
                          active: _currentTab == 2,
                          onTap: () {
                            if (_currentTab != 2) {
                              HapticFeedback.lightImpact();
                            }
                            setState(() => _currentTab = 2);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _springController;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(
      vsync: this,
      lowerBound: 0.85,
      upperBound: 1.0,
      value: 1.0,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _springController.reverse(),
        onTapUp: (_) {
          _springController.forward();
          widget.onTap();
        },
        onTapCancel: () => _springController.forward(),
        child: Center(
          child: ScaleTransition(
            scale: _springController,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              scale: widget.active
                  ? 1.15
                  : 1.0, // Slight scale effect when active
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Icon(
                  widget.icon,
                  key: ValueKey<bool>(widget.active),
                  color: widget.active
                      ? Colors
                            .white // White icon inside the solid blue circle
                      : LiquidGlassTheme.foreground.withValues(
                          alpha: isDark
                              ? 0.45
                              : 0.4, // Muted gray/soft for inactive
                        ),
                  size: 24, // Minimalist sizing
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
