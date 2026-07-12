import 'package:flutter/material.dart';

import '../theme/liquid_glass_theme.dart';
import '../widgets/glass_surface.dart';
import 'bookmarks_screen.dart';
import 'explore_screen.dart';
import 'home_feed_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

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
    ExploreScreen(
      onCategorySelected: (category) {
        setState(() {
          _currentTab = 0;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _homeFeedKey.currentState?.setCategory(category);
        });
      },
    ),
    const SearchScreen(),
    BookmarksScreen(
      onNavigateToFeed: () {
        setState(() {
          _currentTab = 0;
        });
      },
    ),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: LiquidGlassTheme.regular,
              switchInCurve: LiquidGlassTheme.emphasizedDecelerate,
              switchOutCurve: LiquidGlassTheme.emphasizedAccelerate,
              child: KeyedSubtree(
                key: ValueKey(_currentTab),
                child: _screens[_currentTab],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: GlassSurface(
              radius: LiquidGlassTheme.radius32,
              level: GlassLevel.regular,
              height: 66,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Stack(
                children: [
                  AnimatedAlign(
                    duration: LiquidGlassTheme.regular,
                    curve: LiquidGlassTheme.emphasizedDecelerate,
                    alignment: Alignment(-1 + (_currentTab * 0.5), 0),
                    child: FractionallySizedBox(
                      widthFactor: 0.2,
                      child: Container(
                        height: 42,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: accent.withValues(alpha: 0.14),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.2),
                              blurRadius: 16,
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      _NavItem(
                        icon: Icons.bolt_rounded,
                        label: 'Feed',
                        active: _currentTab == 0,
                        accent: accent,
                        onTap: () => setState(() => _currentTab = 0),
                      ),
                      _NavItem(
                        icon: Icons.dashboard_customize_rounded,
                        label: 'Explore',
                        active: _currentTab == 1,
                        accent: accent,
                        onTap: () => setState(() => _currentTab = 1),
                      ),
                      _NavItem(
                        icon: Icons.search_rounded,
                        label: 'Search',
                        active: _currentTab == 2,
                        accent: accent,
                        onTap: () => setState(() => _currentTab = 2),
                      ),
                      _NavItem(
                        icon: Icons.bookmark_rounded,
                        label: 'Saved',
                        active: _currentTab == 3,
                        accent: accent,
                        onTap: () => setState(() => _currentTab = 3),
                      ),
                      _NavItem(
                        icon: Icons.tune_rounded,
                        label: 'Settings',
                        active: _currentTab == 4,
                        accent: accent,
                        onTap: () => setState(() => _currentTab = 4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(LiquidGlassTheme.radius24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  duration: LiquidGlassTheme.quick,
                  scale: active ? 1.12 : 1,
                  child: Icon(
                    icon,
                    color: active ? accent : Colors.white54,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: LiquidGlassTheme.caption.copyWith(
                    fontSize: 10,
                    color: active ? Colors.white : Colors.white38,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
