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
import 'package:factshot/core/widgets/skeleton_block/skeleton_card.dart';
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
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              16.0,
              20.0,
              16.0,
              LiquidGlassTheme.space20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassSurface(
                  radius: 24,
                  level: GlassLevel.subtle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      controller: _controller,
                      onSubmitted: _runSearch,
                      style: LiquidGlassTheme.body.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search titles, categories, sources...',
                        hintStyle: LiquidGlassTheme.body.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white54
                              : Colors.black54,
                          fontSize: 14.5,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            CupertinoIcons.search,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
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
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  CupertinoIcons.clear,
                                  color: LiquidGlassTheme.foregroundSoft,
                                  size: 18,
                                ),
                              ),
                      ),
                    ),
                  ),
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
                            onRemoveRecent: state.removeRecentSearch,
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
    title: 'Breaking',
    imageUrl:
        'https://images.unsplash.com/photo-1504711434969-e33886168f5c?auto=format&fit=crop&q=80&w=300',
    category: 'BREAKING',
  ),
  _ExploreItem(
    title: 'Trending',
    imageUrl:
        'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&q=80&w=300',
    category: 'TRENDING',
  ),
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
    required this.onRemoveRecent,
    this.onCategorySelected,
  });

  final List<String> trendingTopics;
  final List<String> recentSearches;
  final ValueChanged<String> onTopicTap;
  final VoidCallback onClearRecent;
  final ValueChanged<String> onRemoveRecent;
  final ValueChanged<String>? onCategorySelected;

  void _showDeleteConfirmDialog(BuildContext context, String term) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Search History'),
        content: Text('Do you want to delete "$term" from your history?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              onRemoveRecent(term);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return ListView(
      padding: const EdgeInsets.only(bottom: 110),
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          children: [
            Icon(
              CupertinoIcons.flame_fill,
              color: accent,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              'TRENDING TOPICS',
              style: LiquidGlassTheme.overline.copyWith(
                color: accent,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
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
        Row(
          children: [
            Icon(
              CupertinoIcons.compass_fill,
              color: accent,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              'EXPLORE CATEGORIES',
              style: LiquidGlassTheme.overline.copyWith(
                color: accent,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: LiquidGlassTheme.space12),
        SizedBox(
          height: 136,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _exploreCategories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = _exploreCategories[index];
              return GlassSurface(
                width: 180,
                radius: LiquidGlassTheme.radius20,
                borderColor: Colors.transparent,
                child: PressableScale(
                  onTap: () {
                    if (onCategorySelected != null) {
                      onCategorySelected!(item.category);
                    }
                  },
                  borderRadius: BorderRadius.circular(
                    LiquidGlassTheme.radius20,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image background
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          LiquidGlassTheme.radius20,
                        ),
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const SkeletonBlock(
                              radius: LiquidGlassTheme.radius20,
                            );
                          },
                        ),
                      ),
                      // Dark gradient overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              LiquidGlassTheme.radius20,
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
                                color: item.category == 'BREAKING'
                                    ? const Color(0xFFFF3B30)
                                    : accent,
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
                                fontSize: 15.0,
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
            Row(
              children: [
                Icon(
                  CupertinoIcons.time,
                  color: LiquidGlassTheme.foregroundSoft,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text('RECENT SEARCHES', style: LiquidGlassTheme.overline),
              ],
            ),
            if (recentSearches.isNotEmpty)
              GestureDetector(
                onTap: onClearRecent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
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
          GlassSurface(
            radius: LiquidGlassTheme.radius24,
            padding: const EdgeInsets.symmetric(vertical: 6),
            borderColor: Colors.white.withValues(alpha: 0.04),
            child: Column(
              children: recentSearches.asMap().entries.map((entry) {
                final idx = entry.key;
                final term = entry.value;
                return Column(
                  children: [
                    if (idx > 0)
                      Divider(
                        color: Colors.white.withValues(alpha: 0.05),
                        height: 1,
                      ),
                    GestureDetector(
                      onLongPress: () => _showDeleteConfirmDialog(context, term),
                      child: PressableScale(
                        onTap: () => onTopicTap(term),
                        borderRadius: BorderRadius.circular(LiquidGlassTheme.radius24),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.time,
                                color: LiquidGlassTheme.foregroundSoft,
                                size: 16,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  term,
                                  style: LiquidGlassTheme.bodyStrong.copyWith(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Icon(
                                CupertinoIcons.arrow_up_right,
                                color: LiquidGlassTheme.foregroundSoft,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
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
        borderColor: Colors.transparent,
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
      itemBuilder: (context, index) => const SkeletonArticleTileCard(),
    );
  }
}
