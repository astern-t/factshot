import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../models/news_article.dart';
import '../theme/liquid_glass_theme.dart';
import '../widgets/factshot_controls.dart';
import '../widgets/factshot_feedback.dart';
import '../widgets/glass_surface.dart';
import '../widgets/transition_helper.dart';
import 'article_detail_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => HomeFeedScreenState();
}

class HomeFeedScreenState extends State<HomeFeedScreen>
    with TickerProviderStateMixin {
  final List<String> _categories = const [
    'ALL',
    'TECH',
    'INDIA',
    'BUSINESS',
    'SPORTS',
    'ENTERTAINMENT',
  ];

  late final PageController _pageController;
  late final AnimationController _headerController;
  late final Animation<double> _headerScale;
  late final Animation<double> _headerOpacity;

  String _selectedCategory = 'ALL';
  int _activeIndex = 0;
  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_handleScroll);
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _headerScale = Tween<double>(begin: 1, end: 0.92).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
    );
    _headerOpacity = Tween<double>(begin: 1, end: 0.42).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
    );
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_handleScroll);
    _pageController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  List<NewsArticle> get _articles {
    if (_selectedCategory == 'ALL') {
      return mockArticles;
    }
    return mockArticles
        .where((article) => article.category == _selectedCategory)
        .toList();
  }

  void setCategory(String category) {
    if (!_categories.contains(category)) {
      return;
    }
    setState(() {
      _selectedCategory = category;
      _activeIndex = 0;
    });
    if (_pageController.hasClients && _articles.isNotEmpty) {
      _pageController.jumpToPage(0);
    }
  }

  void _handleScroll() {
    if (!_pageController.hasClients) {
      return;
    }
    final page = _pageController.page ?? 0;
    final progress = (page - page.floor()).abs();
    if (progress > 0.04 && progress < 0.96) {
      if (_headerController.status != AnimationStatus.forward &&
          _headerController.value == 0) {
        _headerController.forward();
      }
    } else {
      if (_headerController.status != AnimationStatus.reverse &&
          _headerController.value == 1) {
        _headerController.reverse();
      }
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _isRefreshing = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 850));
    if (!mounted) {
      return;
    }
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final accent = Theme.of(context).colorScheme.primary;
    final articles = _articles;
    final activeArticle = articles.isEmpty
        ? null
        : articles[_activeIndex.clamp(0, articles.length - 1)];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: activeArticle == null
                ? Container(color: LiquidGlassTheme.background)
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        activeArticle.imageUrl,
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
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.22),
                                Colors.black.withValues(alpha: 0.64),
                                LiquidGlassTheme.background,
                              ],
                              stops: const [0, 0.5, 1],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          Positioned.fill(
            child: Container(
              color: LiquidGlassTheme.background.withValues(alpha: 0.18),
            ),
          ),
          Positioned.fill(
            child: _isLoading
                ? const _FeedLoadingState()
                : articles.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: EmptyStateCard(
                        icon: Icons.filter_alt_off_rounded,
                        title: 'No stories in this category',
                        description:
                            'Switch the lane or reset the filter to refill the feed.',
                        action: GlassButton(
                          label: 'Reset',
                          onTap: () => setCategory('ALL'),
                        ),
                      ),
                    ),
                  )
                : SafeArea(
                    child: RefreshIndicator.adaptive(
                      color: accent,
                      backgroundColor: LiquidGlassTheme.backgroundSecondary,
                      onRefresh: _refresh,
                      child: PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        onPageChanged: (index) {
                          setState(() {
                            _activeIndex = index;
                          });
                        },
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          final isBookmarked = state.isBookmarked(article.id);
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 88, 16, 100),
                            child: _FeedCard(
                              article: article,
                              isBookmarked: isBookmarked,
                              isRefreshing: _isRefreshing,
                              onBookmark: () =>
                                  state.toggleBookmark(article.id),
                              onOpen: () {
                                Navigator.of(context).push(
                                  GlassPageRoute(
                                    page: ArticleDetailScreen(article: article),
                                  ),
                                );
                              },
                              onShare: () => GlassMessage.show(
                                context,
                                'Share preview prepared for "${article.title}".',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: AnimatedBuilder(
                animation: _headerController,
                child: GlassSurface(
                  radius: LiquidGlassTheme.radius28,
                  level: GlassLevel.regular,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 6),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return GlassChip(
                          label: category,
                          selected: _selectedCategory == category,
                          onTap: () => setCategory(category),
                        );
                      },
                    ),
                  ),
                ),
                builder: (context, child) {
                  return Opacity(
                    opacity: _headerOpacity.value,
                    child: Transform.scale(
                      scale: _headerScale.value,
                      alignment: Alignment.topCenter,
                      child: child,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard({
    required this.article,
    required this.isBookmarked,
    required this.isRefreshing,
    required this.onOpen,
    required this.onShare,
    required this.onBookmark,
  });

  final NewsArticle article;
  final bool isBookmarked;
  final bool isRefreshing;
  final VoidCallback onOpen;
  final VoidCallback onShare;
  final VoidCallback onBookmark;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return GlassSurface(
      radius: LiquidGlassTheme.radius28,
      level: GlassLevel.regular,
      padding: const EdgeInsets.all(18),
      child: PressableScale(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(LiquidGlassTheme.radius28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                GlassChip(label: article.category, selected: true),
                const Spacer(),
                Text(
                  '${article.source} • ${article.timestamp}',
                  style: LiquidGlassTheme.caption.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(LiquidGlassTheme.radius20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      article.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) {
                          return child;
                        }
                        return Container(color: Colors.white10);
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.white10);
                      },
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.08),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              article.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: LiquidGlassTheme.title.copyWith(
                fontSize: 24,
                height: 1.08,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              article.summary,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: LiquidGlassTheme.body.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    isRefreshing ? 'Refreshing...' : 'Swipe up for more',
                    style: LiquidGlassTheme.caption,
                  ),
                ),
                GlassIconButton(icon: Icons.ios_share_rounded, onTap: onShare),
                const SizedBox(width: 10),
                GlassIconButton(
                  icon: isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  active: isBookmarked,
                  iconColor: isBookmarked ? accent : Colors.white,
                  onTap: onBookmark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedLoadingState extends StatelessWidget {
  const _FeedLoadingState();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 88, 16, 100),
        child: GlassSurface(
          radius: LiquidGlassTheme.radius28,
          level: GlassLevel.regular,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SkeletonBlock(width: 150, height: 28),
              SizedBox(height: 14),
              Expanded(
                flex: 3,
                child: SkeletonBlock(
                  height: double.infinity,
                  radius: LiquidGlassTheme.radius20,
                ),
              ),
              SizedBox(height: 18),
              SkeletonBlock(width: double.infinity, height: 24),
              SizedBox(height: 10),
              SkeletonBlock(width: double.infinity, height: 15),
              SizedBox(height: 8),
              SkeletonBlock(width: 220, height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
