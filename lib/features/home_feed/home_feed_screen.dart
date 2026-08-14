import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:factshot/app/app_state.dart';
import 'package:factshot/data/models/article/article_model.dart';
import 'package:factshot/core/services/news_api_service.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/utils/transition_helper.dart';
import 'package:factshot/core/utils/translations.dart';
import 'package:factshot/core/utils/article_translations.dart';
import 'package:factshot/features/article_detail/article_detail_screen.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/widgets/article_list_tile_card/article_list_tile_card.dart';
import 'package:factshot/core/widgets/glass_message/glass_message.dart';
import 'package:factshot/core/widgets/skeleton_block/skeleton_block.dart';
import 'package:factshot/features/profile/profile_screen.dart';
import 'package:video_player/video_player.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => HomeFeedScreenState();
}

class HomeFeedScreenState extends State<HomeFeedScreen> {
  final List<String> _categories = const [
    'All',
    'Breaking',
    'Trending',
    'Tech',
    'Science',
    'History',
    'India',
    'Business',
    'Sports',
    'Entertainment',
  ];

  late final PageController _horizontalPageController;
  late final ScrollController _categoryScrollController;
  int _selectedCategoryIndex = 0;

  final double _headerFontSize = 19.5;
  final double _contentFontSize = 18.0;

  @override
  void initState() {
    super.initState();
    _horizontalPageController = PageController();
    _categoryScrollController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalPageController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _scrollToCategory(int index) {
    if (!_categoryScrollController.hasClients) return;
    final double targetOffset = (index * 96.0) - 100.0;
    final double maxScroll = _categoryScrollController.position.maxScrollExtent;
    final double clampedOffset = targetOffset.clamp(0.0, maxScroll);

    _categoryScrollController.animateTo(
      clampedOffset,
      duration: LiquidGlassTheme.regular,
      curve: LiquidGlassTheme.emphasizedDecelerate,
    );
  }

  void setCategory(String categoryName) {
    final index = _categories.indexWhere(
      (cat) => cat.toLowerCase() == categoryName.toLowerCase(),
    );
    if (index != -1) {
      if (_horizontalPageController.hasClients) {
        _horizontalPageController.jumpToPage(index);
      } else {
        setState(() {
          _selectedCategoryIndex = index;
        });
      }
    }
  }

  List<NewsArticle> _getArticlesForCategory(String category) {
    final catUpper = category.toUpperCase();
    if (catUpper == 'ALL') {
      return mockArticles;
    }
    return mockArticles
        .where((article) => article.category.toUpperCase() == catUpper)
        .toList();
  }

  String _translateCategory(BuildContext context, String category) {
    final key = 'cat_${category.toLowerCase()}';
    return AppTranslations.translate(context, key);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    const Color iosBlue = Color(0xFF007AFF);

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF000000)
          : const Color(0xFFF2F2F7),
      body: Column(
        children: [
          // Top Bar Container (Solid black and thin)
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Filter Bar inside Top Bar
                  Builder(
                    builder: (context) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      final isMobile = screenWidth < 600;
                      final navHeight = isMobile ? 22.0 : 30.0;

                      return SizedBox(
                        height: navHeight,
                        child: ListView.builder(
                          controller: _categoryScrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                          ),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            final isSelected = _selectedCategoryIndex == index;

                            final isBreaking = category.toUpperCase() == 'BREAKING';
                            final isTrending = category.toUpperCase() == 'TRENDING';

                            return _AnimatedCategoryPill(
                              category: _translateCategory(context, category),
                              isSelected: isSelected,
                              showBlinkingDot: isBreaking || isTrending,
                              dotColor: isBreaking
                                  ? const Color(0xFFFF3B30)
                                  : const Color(0xFFFF9500),
                              onTap: () {
                                HapticFeedback.lightImpact();
                                _horizontalPageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOutCubic,
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
          ),

          // Main Body Stack
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  controller: _horizontalPageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                    _scrollToCategory(index);
                  },
                  itemCount: _categories.length,
                  itemBuilder: (context, catIndex) {
                    final category = _categories[catIndex];
                    final articles = _getArticlesForCategory(category);

                    if (articles.isEmpty) {
                      return Center(
                        child: Text(
                          AppTranslations.translate(context, 'no_articles'),
                          style: TextStyle(
                            color: LiquidGlassTheme.foregroundSoft,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return CategoryVerticalFeed(
                      category: category,
                      articles: articles,
                      appState: state,
                      iosBlue: iosBlue,
                      headerFontSize: _headerFontSize,
                      contentFontSize: _contentFontSize,
                    );
                  },
                ),

                // Premium Floating Feed View Mode Selector Dock
                if (state.showFeedModeSelector)
                  Positioned(
                    bottom: MediaQuery.of(context).size.width < 600
                        ? (50.0 +
                              MediaQuery.of(context).padding.bottom +
                              88.0 +
                              16.0)
                        : 162.0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: FeedModeSelectorDock(
                        currentMode: state.feedMode == FeedMode.book
                            ? FeedMode.slide
                            : state.feedMode,
                        onModeChanged: (mode) {
                          state.setFeedMode(mode);
                        },
                      ),
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

class FeedModeSelectorDock extends StatelessWidget {
  const FeedModeSelectorDock({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  final FeedMode currentMode;
  final ValueChanged<FeedMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final modes = [FeedMode.slide, FeedMode.grid, FeedMode.list];
    final selectedIndex = modes.indexOf(currentMode);

    return GlassSurface(
      width: 170,
      height: 46,
      radius: 23,
      level: GlassLevel.strong,
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          // Sliding highlighter pill
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            alignment: Alignment(-1.0 + (selectedIndex * 1.0), 0.0),
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Interactive Buttons
          Row(
            children: modes.map((mode) {
              final isSelected = currentMode == mode;
              final icon = switch (mode) {
                FeedMode.slide => CupertinoIcons.arrow_up_down,
                FeedMode.grid => CupertinoIcons.square_grid_2x2_fill,
                FeedMode.list => CupertinoIcons.list_bullet,
                _ => CupertinoIcons.arrow_up_down,
              };

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onModeChanged(mode);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Icon(
                      icon,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white54 : Colors.black45),
                      size: 20,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class CategoryVerticalFeed extends StatefulWidget {
  const CategoryVerticalFeed({
    super.key,
    required this.category,
    required this.articles,
    required this.appState,
    required this.iosBlue,
    required this.headerFontSize,
    required this.contentFontSize,
  });

  final String category;
  final List<NewsArticle> articles;
  final AppState appState;
  final Color iosBlue;
  final double headerFontSize;
  final double contentFontSize;

  @override
  State<CategoryVerticalFeed> createState() => _CategoryVerticalFeedState();
}

class _CategoryVerticalFeedState extends State<CategoryVerticalFeed>
    with AutomaticKeepAliveClientMixin {
  late final PageController _verticalPageController;
  // Local language overrides per article ID
  final Map<String, String> _articleLanguages = {};
  List<NewsArticle> _liveArticles = [];
  bool _isLoadingLive = false;

  @override
  void initState() {
    super.initState();
    _verticalPageController = PageController();
    _loadLiveNews();
  }

  Future<void> _loadLiveNews() async {
    if (mounted) {
      setState(() {
        _isLoadingLive = true;
        _liveArticles = [];
      });
    }
    try {
      final news = await NewsApiService.fetchNews(widget.category);
      if (mounted && news.isNotEmpty) {
        setState(() {
          _liveArticles = news;
        });
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLive = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(CategoryVerticalFeed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      _loadLiveNews();
    }
  }

  @override
  void dispose() {
    _verticalPageController.dispose();
    super.dispose();
  }

  List<NewsArticle> get _allArticles => [..._liveArticles, ...widget.articles];

  @override
  bool get wantKeepAlive => true;

  String _limitWordCount(String text, {int maxWords = 60}) {
    // Regex matches any characters lazily up to a punctuation mark followed by whitespace or end of string.
    final sentenceRegex = RegExp(r'[\s\S]+?[.!?](?=\s+|$)');
    final matches = sentenceRegex.allMatches(text);
    if (matches.isEmpty) return text;

    List<String> sentences = matches.map((m) => m.group(0)!).toList();
    String result = '';
    int currentWordCount = 0;

    for (final sentence in sentences) {
      final sentenceWords = sentence.trim().split(RegExp(r'\s+'));
      if (currentWordCount + sentenceWords.length <= maxWords) {
        result += sentence;
        currentWordCount += sentenceWords.length;
      } else {
        if (result.isEmpty) {
          // Fallback: If even the first sentence is too long, we take up to 60 words and end gracefully.
          result = '${sentenceWords.take(maxWords).join(' ')}.';
        }
        break;
      }
    }
    return result.trim();
  }

  Widget _buildFeedCard(NewsArticle article, bool isBookmarked, int index) {
    final effLang =
        _articleLanguages[article.id] ?? widget.appState.contentLanguage;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final isMobile = mediaQuery.size.width < 600;

    // Auto-scale font sizes dynamically and smoothly based on screen width
    // Base standard mobile width is 375 logical pixels. On mobile, we scale down by 20% to fit card boundaries.
    final double mobileFactor = isMobile ? 0.8 : 1.0;
    final double scaleFactor =
        mobileFactor * (mediaQuery.size.width / 375.0).clamp(0.8, 1.15);
    final double effectiveHeaderFontSize = widget.headerFontSize * scaleFactor;
    final double effectiveContentFontSize =
        widget.contentFontSize * scaleFactor;

    // Solid theme-adaptive background (white for light mode, dark navy/slate for dark mode)
    final cardBgColor = isDark
        ? const Color(0xFF16181D)
        : const Color(0xFFFFFFFF);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF475569);

    final fullSummary = article.getLocalizedSummary(effLang);
    final truncatedSummary = _limitWordCount(fullSummary, maxWords: 70);

    // On Mobile: Edge-to-edge full width (no card margins/border lines). On Tablet: Floating card layout.
    const outerPadding = EdgeInsets.zero;
    final cardBorderRadius = BorderRadius.zero;
    const cardBorder = null;
    const cardShadow = null;

    const double ribbonHeight = 60;
    final contentPadding = isMobile
        ? const EdgeInsets.fromLTRB(
            16.0,
            14.0,
            16.0,
            ribbonHeight + 12.0,
          )
        : const EdgeInsets.all(18.0);

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.of(context).push(
          GlassPageRoute(
            page: ArticleDetailScreen(
              article: article,
              initialLanguage: effLang,
            ),
          ),
        );
        if (result is String && mounted) {
          setState(() {
            _articleLanguages[article.id] = result;
          });
        }
      },
      child: Padding(
        padding: outerPadding,
        child: Container(
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: cardBorderRadius,
            border: cardBorder,
            boxShadow: cardShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Column(
                children: [
                  // ─── TOP 40%: MEDIA / IMAGE ───
                  Expanded(
                    flex: 40,
                    child: Stack(
                      fit: StackFit.expand,
                      clipBehavior: Clip.none,
                      children: [
                        if (article.hasVideo)
                          _SlideVideoPlayer(
                            videoUrl: article.videoUrl!,
                            imageUrl: article.imageUrl,
                            isDark: isDark,
                          )
                        else
                          Image.network(
                            article.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const SkeletonBlock(radius: 0);
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: isDark
                                    ? const Color(0xFF22262F)
                                    : const Color(0xFFE2E8F0),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.photo,
                                    color: isDark
                                        ? Colors.white38
                                        : Colors.black26,
                                    size: 40,
                                  ),
                                ),
                              );
                            },
                          ),

                        // Gentle top scrim for badge contrast
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.55),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.45],
                            ),
                          ),
                        ),

                        // Bottom-Left: Source/Category Tab (Inshorts style)
                        Positioned(
                          bottom: -10,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: cardBgColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  article.hasVideo
                                      ? CupertinoIcons.videocam_fill
                                      : CupertinoIcons.news_solid,
                                  color: article.hasVideo
                                      ? const Color(0xFFFF453A)
                                      : (isDark ? Colors.white70 : Colors.black54),
                                  size: 10,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  article.source.toLowerCase(),
                                  style: TextStyle(
                                    color: isDark ? Colors.white70 : Colors.black54,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (article.hasVideo) ...[
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF453A),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: const Text(
                                      'VIDEO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 7.5,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(width: 4),
                                Container(
                                  width: 3,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white30 : Colors.black26,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  AppTranslations.translate(
                                    context,
                                    'cat_${article.category.toLowerCase()}',
                                  ).toUpperCase(),
                                  style: TextStyle(
                                    color: widget.iosBlue,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bottom-Right: Bookmark & Share floating buttons
                        Positioned(
                          bottom: -14,
                          right: 12,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Bookmark
                              GestureDetector(
                                onTap: () {
                                  widget.appState.toggleBookmark(article.id);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: cardBgColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.08)
                                          : Colors.black.withValues(alpha: 0.08),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Icon(
                                    isBookmarked
                                        ? CupertinoIcons.bookmark_fill
                                        : CupertinoIcons.bookmark,
                                    color: isBookmarked
                                        ? widget.iosBlue
                                        : (isDark ? Colors.white70 : Colors.black54),
                                    size: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Share
                              GestureDetector(
                                onTap: () {
                                  GlassMessage.show(
                                    context,
                                    widget.appState.appLanguage == 'Hindi'
                                        ? '"${article.getLocalizedTitle(effLang)}" के लिए शेयर शीट।'
                                        : 'Share staged for "${article.getLocalizedTitle(effLang)}".',
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: cardBgColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.08)
                                          : Colors.black.withValues(alpha: 0.08),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Image.network(
                                    'https://img.icons8.com/ios-glyphs/30/share--v1.png',
                                    width: 14,
                                    height: 14,
                                    color: isDark ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ─── BOTTOM 60%: TEXT CONTENT ───
                  Expanded(
                    flex: 60,
                    child: Padding(
                      padding: contentPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                // Headline (Larger typography)
                                Text(
                                  article.getLocalizedTitle(effLang),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: effectiveHeaderFontSize,
                                    fontWeight: FontWeight.bold,
                                    height: 1.35,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Description (up to 70 words - Short news format)
                                Text(
                                  truncatedSummary,
                                  style: TextStyle(
                                    color: subTextColor,
                                    fontSize: effectiveContentFontSize,
                                    fontWeight: FontWeight.w400,
                                    height: 1.45,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Timestamp on a new line
                                Text(
                                  article.timestamp.toUpperCase(),
                                  style: TextStyle(
                                    color: subTextColor.withValues(alpha: 0.6),
                                    fontSize: isMobile ? 10.0 : 12.0,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _TapToKnowMoreBanner(
                  article: article,
                  effLang: effLang,
                  index: index,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final feedMode = widget.appState.feedMode;

    switch (feedMode) {
      case FeedMode.slide:
      case FeedMode.book: // Fall back to slide mode if legacy book is selected
        return RefreshIndicator(
          onRefresh: _loadLiveNews,
          color: widget.iosBlue,
          child: PageView.builder(
            controller: _verticalPageController,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(parent: PageScrollPhysics()),
            itemCount: _allArticles.length,
            onPageChanged: (index) {
              AppState.slideChangeNotifier.value++;
            },
            itemBuilder: (context, index) {
              final article = _allArticles[index];
              final isBookmarked = widget.appState.isBookmarked(article.id);

              return AnimatedBuilder(
                animation: _verticalPageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_verticalPageController.position.haveDimensions) {
                    value = (_verticalPageController.page ?? 0) - index;
                    value = (1 - value.abs()).clamp(0.0, 1.0);
                  }
                  final scale = 0.85 + (value * 0.15);
                  final opacity = 0.5 + (value * 0.5);

                  return Transform.scale(
                    scale: scale,
                    child: Opacity(opacity: opacity, child: child),
                  );
                },
                child: _buildFeedCard(article, isBookmarked, index),
              );
            },
          ),
        );

      case FeedMode.grid:
        return RefreshIndicator(
          onRefresh: _loadLiveNews,
          color: widget.iosBlue,
          child: GridView.builder(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            cacheExtent: 1000,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 160),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: _allArticles.length,
            itemBuilder: (context, index) {
              final article = _allArticles[index];
              final effLang =
                  _articleLanguages[article.id] ??
                  widget.appState.contentLanguage;

              return PressableScale(
                onTap: () async {
                  final result = await Navigator.of(context).push(
                    GlassPageRoute(
                      page: ArticleDetailScreen(
                        article: article,
                        initialLanguage: effLang,
                      ),
                    ),
                  );
                  if (result is String && mounted) {
                    setState(() {
                      _articleLanguages[article.id] = result;
                    });
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: GlassSurface(
                  radius: 16,
                  level: GlassLevel.subtle,
                  padding: EdgeInsets.zero,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          article.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const SkeletonBlock(radius: 16);
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.1),
                              Colors.black.withValues(alpha: 0.6),
                              Colors.black.withValues(alpha: 0.95),
                            ],
                            stops: const [0.0, 0.4, 0.7, 1.0],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppTranslations.translate(
                                    context,
                                    'cat_${article.category.toLowerCase()}',
                                  ).toUpperCase(),
                                  style: TextStyle(
                                    color: widget.iosBlue,
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Language Toggle selector for Grid view
                                GestureDetector(
                                  onTap: () {
                                    final next = effLang == 'English'
                                        ? 'Hindi'
                                        : (effLang == 'Hindi'
                                              ? 'Both'
                                              : 'English');
                                    setState(() {
                                      _articleLanguages[article.id] = next;
                                    });
                                    HapticFeedback.selectionClick();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.45),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      effLang == 'Both'
                                          ? 'BOTH'
                                          : effLang == 'Hindi'
                                          ? 'हिंदी'
                                          : 'EN',
                                      style: const TextStyle(
                                        fontSize: 8,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              article.getLocalizedTitle(effLang),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                height: 1.25,
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
        );

      case FeedMode.list:
        return RefreshIndicator(
          onRefresh: _loadLiveNews,
          color: widget.iosBlue,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            cacheExtent: 1000,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 160),
            itemCount: _allArticles.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final article = _allArticles[index];
              final effLang =
                  _articleLanguages[article.id] ??
                  widget.appState.contentLanguage;

              return ArticleListTileCard(
                article: article,
                language: effLang,
                onLanguageChanged: (nextLang) {
                  setState(() {
                    _articleLanguages[article.id] = nextLang;
                  });
                  HapticFeedback.selectionClick();
                },
                onTap: () async {
                  final result = await Navigator.of(context).push(
                    GlassPageRoute(
                      page: ArticleDetailScreen(
                        article: article,
                        initialLanguage: effLang,
                      ),
                    ),
                  );
                  if (result is String && mounted) {
                    setState(() {
                      _articleLanguages[article.id] = result;
                    });
                  }
                },
              );
            },
          ),
        );
    }
  }
}

class _BlinkingDot extends StatefulWidget {
  const _BlinkingDot({
    super.key,
    this.color = const Color(0xFFFF3B30),
  });

  final Color color;

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color,
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedCategoryPill extends StatelessWidget {
  const _AnimatedCategoryPill({
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.showBlinkingDot = false,
    this.dotColor = const Color(0xFFFF3B30),
  });

  final String category;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showBlinkingDot;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.of(context).size.width < 600;

    // The top navbar is now black, so we use white text for high contrast.
    final textColor = isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6);
    final indicatorColor = accent;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: isMobile ? 6.0 : 10.0),
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: isSelected
                      ? (isMobile ? 14 : 17)
                      : (isMobile ? 13 : 16),
                  letterSpacing: -0.5,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(category),
                    if (showBlinkingDot) ...[
                      const SizedBox(width: 4),
                      _BlinkingDot(color: dotColor),
                    ],
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 2 : 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                height: isMobile ? 2.0 : 3.0,
                width: isSelected ? (isMobile ? 12 : 20) : 0,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: indicatorColor.withValues(alpha: 0.8),
                            blurRadius: isMobile ? 3 : 6,
                            spreadRadius: isMobile ? 0.5 : 1,
                          ),
                        ]
                      : [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideVideoPlayer extends StatefulWidget {
  const _SlideVideoPlayer({
    required this.videoUrl,
    required this.imageUrl,
    required this.isDark,
  });

  final String videoUrl;
  final String imageUrl;
  final bool isDark;

  @override
  State<_SlideVideoPlayer> createState() => _SlideVideoPlayerState();
}

class _SlideVideoPlayerState extends State<_SlideVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isMuted = true;
  bool _showMuteIndicator = false;
  Timer? _indicatorTimer;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      await _controller!.initialize();
      _controller!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
      if (mounted) {
        final appState = AppState.instance;
        final autoPlay = appState?.autoplayEnabled ?? true;

        await _controller!.setVolume(0.0);
        await _controller!.setLooping(true);
        if (autoPlay) {
          await _controller!.play();
        }
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _indicatorTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  void _toggleMute() {
    if (_controller == null || !_isInitialized) return;
    HapticFeedback.lightImpact();
    final wasPlaying = _controller!.value.isPlaying;
    setState(() {
      _isMuted = !_isMuted;
      _controller!.setVolume(_isMuted ? 0.0 : 1.0);
      _showMuteIndicator = true;
    });
    if (!wasPlaying) {
      _controller!.play();
    }
    _indicatorTimer?.cancel();
    _indicatorTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _showMuteIndicator = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const SkeletonBlock(radius: 0);
        },
      );
    }

    return GestureDetector(
      onTap: _toggleMute,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),

          // Premium animated mute/unmute state indicator overlay
          AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: _showMuteIndicator ? 1.0 : 0.0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isMuted ? CupertinoIcons.volume_off : CupertinoIcons.volume_up,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),

          // Play overlay when paused
          if (!_controller!.value.isPlaying)
            IgnorePointer(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.play_fill,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TapToKnowMoreBanner extends StatelessWidget {
  final NewsArticle article;
  final String effLang;
  final int index;

  const _TapToKnowMoreBanner({
    required this.article,
    required this.effLang,
    required this.index,
  });

  static final List<Map<String, dynamic>> _ads = [
    {
      'tag': 'SPONSORED AD',
      'bannerUrl':
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800&auto=format&fit=crop&q=60',
      'color': const Color(0xFF007AFF),
    },
    {
      'tag': 'PREMIUM EXCLUSIVE',
      'bannerUrl':
          'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=800&auto=format&fit=crop&q=60',
      'color': const Color(0xFFFF3B30),
    },
  ];

  static final List<Map<String, dynamic>> _ribbons = [
    {
      'tag': 'MATCH SCORE',
      'text': 'IND 324/4 (50) vs AUS 280/10',
      'sub': 'India wins by 44 runs in a thrilling final match! 🏆',
      'icon': CupertinoIcons.sportscourt_fill,
      'color': const Color(0xFFFF9500),
      'mediaType': 'image',
    },
    {
      'tag': 'SUGGESTED STORY',
      'text': 'S&P 500 Reaches Historic Highs',
      'sub': 'Tech stocks rally pushes indexes to new records.',
      'icon': CupertinoIcons.graph_square_fill,
      'color': const Color(0xFF34C759),
      'mediaType': 'video',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final int formatType =
        index % 3; // 0 = Tap to know, 1 = Full Image Ad, 2 = Ribbon Content

    if (formatType == 1) {
      // ──────────────── FULL IMAGE SPONSORED AD format ────────────────
      final item = _ads[(index ~/ 3) % _ads.length];
      final bannerUrl = item['bannerUrl'] as String?;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          GlassMessage.show(context, 'Ad Staged: Opening sponsored link...');
        },
        child: GlassSurface(
          radius: 0,
          borderRadius: BorderRadius.zero,
          level: GlassLevel.subtle,
          customFillColor: const Color(0xFF0F172A).withValues(alpha: 0.35),
          borderColor: Colors.white.withValues(alpha: 0.06),
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: 60,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Stack(
                children: [
                  if (bannerUrl != null)
                    Positioned.fill(
                      child: Image.network(bannerUrl, fit: BoxFit.cover),
                    ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.45),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 0,
                    bottom: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: (item['color'] as Color).withValues(
                              alpha: 0.85,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['tag'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tap to visit sponsor link',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    right: 20,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Icon(
                        CupertinoIcons.chevron_right,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (formatType == 2) {
      // ──────────────── RIBBON CONTENT / MATCH SCORE format ────────────────
      final item = _ribbons[(index ~/ 3) % _ribbons.length];

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          GlassMessage.show(
            context,
            'Opening suggested detail page for "${item['text']}"...',
          );
        },
        child: GlassSurface(
          radius: 0,
          borderRadius: BorderRadius.zero,
          level: GlassLevel.subtle,
          customFillColor: const Color(0xFF0F172A).withValues(alpha: 0.35),
          borderColor: Colors.white.withValues(alpha: 0.06),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SizedBox(
            height: 52,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: item['color'] as Color,
                        size: 18,
                      ),
                    ),
                    if (item['mediaType'] == 'video')
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.play_fill,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: (item['color'] as Color).withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item['tag'] as String,
                              style: TextStyle(
                                color: item['color'] as Color,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['text'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        item['sub'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 10,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  CupertinoIcons.chevron_right,
                  color: Colors.white70,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // ──────────────── DYNAMIC ARTICLE TAP TO KNOW MORE format ────────────────
      final idHashCode = article.id.hashCode;
      final String titleText;
      final String subtitleText;

      if (idHashCode % 3 == 0) {
        titleText = 'Tap to read full article';
        subtitleText = 'Read the full story at ${article.source}';
      } else if (idHashCode % 3 == 1) {
        titleText = 'Tap to know more';
        subtitleText = 'View full coverage at ${article.source}';
      } else {
        titleText = 'Read more';
        subtitleText = 'Read full article at ${article.source}';
      }

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          await Navigator.of(context).push(
            GlassPageRoute(
              page: ArticleDetailScreen(
                article: article,
                initialLanguage: effLang,
              ),
            ),
          );
        },
        child: GlassSurface(
          radius: 0,
          borderRadius: BorderRadius.zero,
          level: GlassLevel.subtle,
          customFillColor: const Color(0xFF0F172A).withValues(alpha: 0.35),
          borderColor: Colors.white.withValues(alpha: 0.06),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SizedBox(
            height: 40, // (Total height including padding is 60)
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      titleText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitleText,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  CupertinoIcons.chevron_right,
                  color: Colors.white70,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
