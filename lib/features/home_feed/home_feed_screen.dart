import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:factshot/app/app_state.dart';
import 'package:factshot/data/models/article/article_model.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/utils/transition_helper.dart';
import 'package:factshot/core/utils/translations.dart';
import 'package:factshot/core/utils/article_translations.dart';
import 'package:factshot/features/article_detail/article_detail_screen.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/widgets/glass_icon_button/glass_icon_button.dart';
import 'package:factshot/core/widgets/article_list_tile_card/article_list_tile_card.dart';
import 'package:factshot/core/widgets/glass_message/glass_message.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => HomeFeedScreenState();
}

class HomeFeedScreenState extends State<HomeFeedScreen> {
  final List<String> _categories = const [
    'All',
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
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                // Top Premium Category Filter Bar (takes full width now)
                Builder(
                  builder: (context) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final screenHeight = MediaQuery.of(context).size.height;
                    final navHeight = (screenHeight * 0.065).clamp(48.0, 64.0);

                    return SizedBox(
                      height: navHeight,
                      child: ListView.builder(
                        controller: _categoryScrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                        ),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = _selectedCategoryIndex == index;

                          return _AnimatedCategoryPill(
                            category: _translateCategory(context, category),
                            isSelected: isSelected,
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
                const SizedBox(height: 12),
                // Main Feed PageView
                Expanded(
                  child: PageView.builder(
                    controller: _horizontalPageController,
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
                        articles: articles,
                        appState: state,
                        iosBlue: iosBlue,
                      );
                    },
                  ),
                ),
              ],
            ),

            // Premium Floating Feed View Mode Selector Dock
            Positioned(
              bottom: 110, // Floats cleanly above standard floating shell bottom nav bar
              left: 0,
              right: 0,
              child: Center(
                child: FeedModeSelectorDock(
                  currentMode: state.feedMode == FeedMode.book ? FeedMode.slide : state.feedMode,
                  onModeChanged: (mode) {
                    state.setFeedMode(mode);
                  },
                ),
              ),
            ),
          ],
        ),
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
    required this.articles,
    required this.appState,
    required this.iosBlue,
  });

  final List<NewsArticle> articles;
  final AppState appState;
  final Color iosBlue;

  @override
  State<CategoryVerticalFeed> createState() => _CategoryVerticalFeedState();
}

class _CategoryVerticalFeedState extends State<CategoryVerticalFeed>
    with AutomaticKeepAliveClientMixin {
  late final PageController _verticalPageController;
  // Local language overrides per article ID
  final Map<String, String> _articleLanguages = {};

  @override
  void initState() {
    super.initState();
    _verticalPageController = PageController();
  }

  @override
  void dispose() {
    _verticalPageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildFeedCard(NewsArticle article, bool isBookmarked) {
    final effLang = _articleLanguages[article.id] ?? widget.appState.contentLanguage;

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image (Cover)
            Image.network(
              article.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(color: const Color(0xFF1B1B1F));
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF1B1B1F),
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.exclamationmark_triangle,
                      color: Colors.white30,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
            // Dark gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black,
                  ],
                  stops: const [0.0, 0.4, 0.75, 1.0],
                ),
              ),
            ),
            // Top Right Language Toggle Bar for Slide view
            Positioned(
              top: 24,
              right: 24,
              child: _CardLanguageToggle(
                currentLanguage: effLang,
                onChanged: (lang) {
                  setState(() {
                    _articleLanguages[article.id] = lang;
                  });
                  HapticFeedback.selectionClick();
                },
              ),
            ),
            // Bottom aligned content
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 110.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: widget.iosBlue.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      AppTranslations.translate(
                        context,
                        'cat_${article.category.toLowerCase()}',
                      ).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  // Headline
                  Text(
                    article.getLocalizedTitle(effLang),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Summary
                  Text(
                    article.getLocalizedSummary(effLang),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14.0,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Bottom row: source & time, bookmark & share
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${article.source.toUpperCase()} • ${article.timestamp.toUpperCase()}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      // Bookmark button
                      GestureDetector(
                        onTap: () {
                          widget.appState.toggleBookmark(article.id);
                        },
                        child: Icon(
                          isBookmarked
                              ? CupertinoIcons.bookmark_fill
                              : CupertinoIcons.bookmark,
                          color: isBookmarked
                              ? Colors.white
                              : Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Share button
                      GestureDetector(
                        onTap: () {
                          GlassMessage.show(
                            context,
                            widget.appState.appLanguage == 'Hindi'
                                ? '"${article.getLocalizedTitle(effLang)}" के लिए शेयर शीट।'
                                : 'Share sheet staged for "${article.getLocalizedTitle(effLang)}".',
                          );
                        },
                        child: const Icon(
                          CupertinoIcons.share,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
        return PageView.builder(
          controller: _verticalPageController,
          scrollDirection: Axis.vertical,
          itemCount: widget.articles.length,
          itemBuilder: (context, index) {
            final article = widget.articles[index];
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
              child: _buildFeedCard(article, isBookmarked),
            );
          },
        );

      case FeedMode.grid:
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 160),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: widget.articles.length,
          itemBuilder: (context, index) {
            final article = widget.articles[index];
            final effLang = _articleLanguages[article.id] ?? widget.appState.contentLanguage;

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
                          return Container(color: const Color(0xFF1B1B1F));
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
                                      : (effLang == 'Hindi' ? 'Both' : 'English');
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
        );

      case FeedMode.list:
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 160),
          itemCount: widget.articles.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final article = widget.articles[index];
            final effLang = _articleLanguages[article.id] ?? widget.appState.contentLanguage;

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
        );
    }
  }
}

class _CardLanguageToggle extends StatelessWidget {
  const _CardLanguageToggle({
    required this.currentLanguage,
    required this.onChanged,
  });

  final String currentLanguage;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSegment('English', 'EN'),
          _buildSegment('Hindi', 'हिंदी'),
          _buildSegment('Both', 'Both'),
        ],
      ),
    );
  }

  Widget _buildSegment(String lang, String label) {
    final isSelected = currentLanguage == lang;
    return GestureDetector(
      onTap: () => onChanged(lang),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
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
  });

  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = theme.colorScheme.primary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  color: isSelected
                      ? (isDark ? Colors.white : Colors.black)
                      : (isDark ? Colors.white54 : Colors.black54),
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: isSelected ? 17 : 16,
                  letterSpacing: -0.5,
                ),
                child: Text(category),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                height: 4,
                width: isSelected ? 16 : 0,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
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
