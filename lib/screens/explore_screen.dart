import 'package:flutter/material.dart';

import '../theme/liquid_glass_theme.dart';
import '../widgets/factshot_background.dart';
import '../widgets/factshot_controls.dart';
import '../widgets/glass_surface.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key, required this.onCategorySelected});

  final ValueChanged<String> onCategorySelected;

  final List<_ExploreItem> _items = const [
    _ExploreItem(
      title: 'Technology',
      description:
          'Quantum stacks, AI launches, spatial computing, and platform bets.',
      imageUrl:
          'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&q=80&w=1200',
      category: 'TECH',
    ),
    _ExploreItem(
      title: 'India',
      description:
          'Domestic policy, infra, deep space, and fast-moving national stories.',
      imageUrl:
          'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&q=80&w=1200',
      category: 'INDIA',
    ),
    _ExploreItem(
      title: 'Business',
      description:
          'Capital rotation, transition economics, and global market pressure points.',
      imageUrl:
          'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&q=80&w=1200',
      category: 'BUSINESS',
    ),
    _ExploreItem(
      title: 'Sports',
      description:
          'Breakthrough performances, competitive swings, and tournament snapshots.',
      imageUrl:
          'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&q=80&w=1200',
      category: 'SPORTS',
    ),
    _ExploreItem(
      title: 'Entertainment',
      description:
          'Film, streaming, cultural flashpoints, and creator economy signals.',
      imageUrl:
          'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&q=80&w=1200',
      category: 'ENTERTAINMENT',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: FactShotBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Explore', style: LiquidGlassTheme.display),
                      const SizedBox(height: LiquidGlassTheme.space12),
                      Text(
                        'Jump directly into a category and hand the selection back to the feed.',
                        style: LiquidGlassTheme.body,
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                sliver: SliverList.separated(
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return GlassSurface(
                      radius: LiquidGlassTheme.radius32,
                      child: PressableScale(
                        onTap: () => onCategorySelected(item.category),
                        borderRadius: BorderRadius.circular(
                          LiquidGlassTheme.radius32,
                        ),
                        child: SizedBox(
                          height: 188,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  LiquidGlassTheme.radius32,
                                ),
                                child: Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) {
                                      return child;
                                    }
                                    return Container(
                                      color:
                                          LiquidGlassTheme.backgroundSecondary,
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color:
                                          LiquidGlassTheme.backgroundSecondary,
                                    );
                                  },
                                ),
                              ),
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      LiquidGlassTheme.radius32,
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.1),
                                        Colors.black.withValues(alpha: 0.66),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(
                                  LiquidGlassTheme.space20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      item.category,
                                      style: LiquidGlassTheme.overline.copyWith(
                                        color: accent,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: LiquidGlassTheme.space8,
                                    ),
                                    Text(
                                      item.title,
                                      style: LiquidGlassTheme.headline,
                                    ),
                                    const SizedBox(
                                      height: LiquidGlassTheme.space8,
                                    ),
                                    Text(
                                      item.description,
                                      style: LiquidGlassTheme.body,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: LiquidGlassTheme.space16),
                  itemCount: _items.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreItem {
  const _ExploreItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
  });

  final String title;
  final String description;
  final String imageUrl;
  final String category;
}
