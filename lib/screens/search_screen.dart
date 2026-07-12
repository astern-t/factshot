import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../models/news_article.dart';
import '../theme/liquid_glass_theme.dart';
import '../widgets/article_components.dart';
import '../widgets/factshot_background.dart';
import '../widgets/factshot_controls.dart';
import '../widgets/factshot_feedback.dart';
import '../widgets/glass_surface.dart';
import '../widgets/transition_helper.dart';
import 'article_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

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
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.white54,
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
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white54,
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

class _SuggestionsView extends StatelessWidget {
  const _SuggestionsView({
    required this.trendingTopics,
    required this.recentSearches,
    required this.onTopicTap,
    required this.onClearRecent,
  });

  final List<String> trendingTopics;
  final List<String> recentSearches;
  final ValueChanged<String> onTopicTap;
  final VoidCallback onClearRecent;

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
                  icon: Icons.trending_up_rounded,
                  onTap: () => onTopicTap(topic),
                ),
              )
              .toList(),
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
            icon: Icons.history_toggle_off_rounded,
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
                      const Icon(Icons.history_rounded, color: Colors.white38),
                      const SizedBox(width: LiquidGlassTheme.space12),
                      Expanded(
                        child: Text(term, style: LiquidGlassTheme.bodyStrong),
                      ),
                      const Icon(
                        Icons.arrow_outward_rounded,
                        color: Colors.white24,
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
            icon: Icons.search_off_rounded,
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
