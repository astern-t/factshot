import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:factshot/app/app_state.dart';
import 'package:factshot/data/models/article/article_model.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/article_list_tile_card/article_list_tile_card.dart';
import 'package:factshot/core/widgets/factshot_background/factshot_background.dart';
import 'package:factshot/core/widgets/glass_text_field/glass_text_field.dart';
import 'package:factshot/core/widgets/glass_chip/glass_chip.dart';
import 'package:factshot/core/widgets/glass_button/glass_button.dart';
import 'package:factshot/core/widgets/empty_state_card/empty_state_card.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/widgets/skeleton_block/skeleton_block.dart';
import 'package:factshot/core/utils/transition_helper.dart';
import 'package:factshot/features/article_detail/article_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.onCategorySelected});

  final ValueChanged<String>? onCategorySelected;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _trendingTopics = const [
    'Quantum computing',
    'ISRO',
    'Energy transition',
    'Chess',
    'AR wearables',
  ];
  Timer? _debounce;
  String _query = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onChanged() {
    _debounce?.cancel();
    setState(() {
      _isSearching = true;
    });
    _debounce = Timer(const Duration(milliseconds: 220), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _query = _controller.text.trim();
        _isSearching = false;
      });
    });
  }

  List<NewsArticle> get _results {
    if (_query.isEmpty) {
      return const [];
    }
    final normalized = _query.toLowerCase();
    return mockArticles.where((article) {
      return article.title.toLowerCase().contains(normalized) ||
          article.summary.toLowerCase().contains(normalized) ||
          article.category.toLowerCase().contains(normalized) ||
          article.source.toLowerCase().contains(normalized);
    }).toList();
  }

  void _runSearch(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    AppScope.of(context).addRecentSearch(value);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      body: FactShotBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(LiquidGlassTheme.space20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Search', style: LiquidGlassTheme.display),
                const SizedBox(height: LiquidGlassTheme.space16),
                GlassTextField(
                  controller: _controller,
                  hintText: 'Titles, categories, sources',
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: LiquidGlassTheme.foregroundSoft,
                  ),
                  suffixIcon: _query.isEmpty && _controller.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _controller.clear();
                            setState(() {
                              _query = '';
                              _isSearching = false;
                            });
                          },
                          icon: Icon(
                            CupertinoIcons.clear,
                            color: LiquidGlassTheme.foregroundSoft,
                          ),
                        ),
                  onSubmitted: _runSearch,
                ),
                const SizedBox(height: LiquidGlassTheme.space20),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: LiquidGlassTheme.regular,
                    child: _query.isEmpty && _controller.text.isEmpty
                        ? _SuggestionsView(
                            trendingTopics: _trendingTopics,
                            recentSearches: state.recentSearches,
                            onTopicTap: _runSearch,
                            onClearRecent: state.clearRecentSearches,
                            onCategorySelected: widget.onCategorySelected,
                          )
                        : _isSearching
                        ? const _SearchLoading()
                        : _ResultsView(
                            query: _query,
                            results: _results,
                            onOpen: (article) {
                              state.addRecentSearch(article.title);
                              Navigator.of(context).push(
                                GlassPageRoute(
                                  page: ArticleDetailScreen(article: article),
                                ),
                              );
                            },
                          ),
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

class _ExploreItem {
  const _ExploreItem({
    required this.title,
    required this.imageUrl,
    required this.category,
  });

  final String title;
  final String imageUrl;
  final String category;
}

const List<_ExploreItem> _exploreCategories = [
  _ExploreItem(
    title: 'Technology',
    imageUrl:
        'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&q=80&w=300',
    category: 'TECH',
  ),
  _ExploreItem(
    title: 'India',
    imageUrl:
        'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format&fit=crop&q=80&w=300',
    category: 'INDIA',
  ),
  _ExploreItem(
    title: 'Business',
    imageUrl:
        'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&q=80&w=300',
    category: 'BUSINESS',
  ),
  _ExploreItem(
    title: 'Sports',
    imageUrl:
        'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&q=80&w=300',
    category: 'SPORTS',
  ),
  _ExploreItem(
    title: 'Entertainment',
    imageUrl:
        'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&q=80&w=300',
    category: 'ENTERTAINMENT',
  ),
];

class _SuggestionsView extends StatelessWidget {
  const _SuggestionsView({
    required this.trendingTopics,
    required this.recentSearches,
    required this.onTopicTap,
    required this.onClearRecent,
    this.onCategorySelected,
  });

  final List<String> trendingTopics;
  final List<String> recentSearches;
  final ValueChanged<String> onTopicTap;
  final VoidCallback onClearRecent;
  final ValueChanged<String>? onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 110),
      physics: const BouncingScrollPhysics(),
      children: [
        Text('TRENDING', style: LiquidGlassTheme.overline),
        const SizedBox(height: LiquidGlassTheme.space12),
        Wrap(
          spacing: LiquidGlassTheme.space8,
          runSpacing: LiquidGlassTheme.space8,
          children: trendingTopics
              .map(
                (topic) => GlassChip(
                  label: topic,
                  icon: CupertinoIcons.arrow_up_right,
                  onTap: () => onTopicTap(topic),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: LiquidGlassTheme.space24),
        Text('EXPLORE CATEGORIES', style: LiquidGlassTheme.overline),
        const SizedBox(height: LiquidGlassTheme.space12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _exploreCategories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = _exploreCategories[index];
              return GlassSurface(
                width: 180,
                radius: LiquidGlassTheme.radius24,
                child: PressableScale(
                  onTap: () {
                    if (onCategorySelected != null) {
                      onCategorySelected!(item.category);
                    }
                  },
                  borderRadius: BorderRadius.circular(
                    LiquidGlassTheme.radius24,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image background
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          LiquidGlassTheme.radius24,
                        ),
                        child: Image.network(item.imageUrl, fit: BoxFit.cover),
                      ),
                      // Dark gradient overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              LiquidGlassTheme.radius24,
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.1),
                                Colors.black.withValues(alpha: 0.75),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              item.category,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 9.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: LiquidGlassTheme.space24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('RECENT', style: LiquidGlassTheme.overline),
            if (recentSearches.isNotEmpty)
              GlassButton(label: 'Clear', onTap: onClearRecent),
          ],
        ),
        const SizedBox(height: LiquidGlassTheme.space12),
        if (recentSearches.isEmpty)
          const EmptyStateCard(
            icon: CupertinoIcons.time,
            title: 'No recent searches yet.',
            description:
                'Your recent queries will appear here for one-tap recall.',
          )
        else
          ...recentSearches.map(
            (term) => Padding(
              padding: const EdgeInsets.only(bottom: LiquidGlassTheme.space12),
              child: GlassSurface(
                radius: LiquidGlassTheme.radius24,
                padding: const EdgeInsets.all(LiquidGlassTheme.space16),
                child: PressableScale(
                  onTap: () => onTopicTap(term),
                  borderRadius: BorderRadius.circular(
                    LiquidGlassTheme.radius24,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.time,
                        color: LiquidGlassTheme.foregroundSoft,
                      ),
                      const SizedBox(width: LiquidGlassTheme.space12),
                      Expanded(
                        child: Text(term, style: LiquidGlassTheme.bodyStrong),
                      ),
                      Icon(
                        CupertinoIcons.arrow_up_right,
                        color: LiquidGlassTheme.foregroundSoft,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ResultsView extends StatelessWidget {
  const _ResultsView({
    required this.query,
    required this.results,
    required this.onOpen,
  });

  final String query;
  final List<NewsArticle> results;
  final ValueChanged<NewsArticle> onOpen;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 110),
          child: EmptyStateCard(
            icon: CupertinoIcons.search,
            title: 'No results for "$query".',
            description:
                'Try a broader source, topic, or category. The mock index is filtering live.',
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 110),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => ArticleListTileCard(
        article: results[index],
        onTap: () => onOpen(results[index]),
      ),
      separatorBuilder: (context, index) =>
          const SizedBox(height: LiquidGlassTheme.space12),
      itemCount: results.length,
    );
  }
}

class _SearchLoading extends StatelessWidget {
  const _SearchLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 110),
      itemCount: 4,
      separatorBuilder: (context, index) =>
          const SizedBox(height: LiquidGlassTheme.space12),
      itemBuilder: (context, index) => GlassSurface(
        radius: LiquidGlassTheme.radius24,
        padding: const EdgeInsets.all(LiquidGlassTheme.space16),
        child: const Row(
          children: [
            SkeletonBlock(
              height: 84,
              width: 84,
              radius: LiquidGlassTheme.radius20,
            ),
            SizedBox(width: LiquidGlassTheme.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBlock(width: 70),
                  SizedBox(height: LiquidGlassTheme.space12),
                  SkeletonBlock(width: double.infinity, height: 18),
                  SizedBox(height: LiquidGlassTheme.space8),
                  SkeletonBlock(width: 180, height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
