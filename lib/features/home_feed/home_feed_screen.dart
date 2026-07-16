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
    // Calculate approximate target offset to bring selected category pill to center
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            // Top Premium Category Filter Bar
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
            // Main Feed PageView (Swiping horizontally switches categories, swiping vertically switches articles)
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageView.builder(
      controller: _verticalPageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.articles.length,
      itemBuilder: (context, index) {
        final article = widget.articles[index];
        final isBookmarked = widget.appState.isBookmarked(article.id);

        return GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).push(GlassPageRoute(page: ArticleDetailScreen(article: article)));
          },
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
              // Bottom aligned content
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 110.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Category Badge (translucent primary color)
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
                    // Headline (maxLines: 2)
                    Text(
                      article.getLocalizedTitle(
                        widget.appState.contentLanguage,
                      ),
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
                    // Summary (maxLines: 3)
                    Text(
                      article.getLocalizedSummary(
                        widget.appState.contentLanguage,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14.0,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Bottom row: Source & Time, Bookmark & Share buttons
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
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                            child: Icon(
                              isBookmarked
                                  ? CupertinoIcons.bookmark_fill
                                  : CupertinoIcons.bookmark,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Share button
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Sharing "${article.title}"'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                            child: const Icon(
                              CupertinoIcons.share,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
                  fontSize: isSelected ? 17 : 16, // Subtle scale
                  letterSpacing: -0.5,
                ),
                child: Text(category),
              ),
              const SizedBox(height: 6),
              // Minimalist animated indicator dot
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic, // Fixed overshooting which caused negative blurRadius crash
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
