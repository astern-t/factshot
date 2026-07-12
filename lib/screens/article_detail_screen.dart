import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../models/news_article.dart';
import '../theme/liquid_glass_theme.dart';
import '../widgets/article_components.dart';
import '../widgets/factshot_feedback.dart';
import '../widgets/factshot_controls.dart';
import '../widgets/glass_surface.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final isBookmarked = state.isBookmarked(article.id);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              article.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                }
                return Container(color: LiquidGlassTheme.backgroundSecondary);
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(color: LiquidGlassTheme.backgroundSecondary);
              },
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    LiquidGlassTheme.background.withValues(alpha: 0.22),
                    LiquidGlassTheme.background.withValues(alpha: 0.55),
                    LiquidGlassTheme.background,
                  ],
                  stops: const [0, 0.38, 1],
                ),
              ),
            ),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 320)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                sliver: SliverList.list(
                  children: [
                    GlassSurface(
                      radius: LiquidGlassTheme.radius32,
                      padding: const EdgeInsets.all(LiquidGlassTheme.space24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ArticleMetaRow(
                            category: article.category,
                            trailingText:
                                '${article.readTimeMinutes} min read • ${article.source}',
                          ),
                          const SizedBox(height: LiquidGlassTheme.space20),
                          Text(article.title, style: LiquidGlassTheme.display),
                          const SizedBox(height: LiquidGlassTheme.space20),
                          GlassSurface(
                            radius: LiquidGlassTheme.radius24,
                            level: GlassLevel.subtle,
                            padding: const EdgeInsets.all(
                              LiquidGlassTheme.space20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'KEY TAKE',
                                  style: LiquidGlassTheme.overline.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(
                                  height: LiquidGlassTheme.space12,
                                ),
                                Text(
                                  article.summary,
                                  style: LiquidGlassTheme.bodyStrong,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: LiquidGlassTheme.space24),
                          Text(article.body, style: LiquidGlassTheme.body),
                          const SizedBox(height: LiquidGlassTheme.space24),
                          GlassSurface(
                            radius: LiquidGlassTheme.radius20,
                            level: GlassLevel.subtle,
                            padding: const EdgeInsets.all(
                              LiquidGlassTheme.space16,
                            ),
                            child: Text(
                              'Source access, sharing, and bookmarking are mocked but stateful in this prototype so every visible control stays honest.',
                              style: LiquidGlassTheme.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(LiquidGlassTheme.space16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlassIconButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  Row(
                    children: [
                      GlassIconButton(
                        icon: Icons.language_rounded,
                        onTap: () => GlassMessage.show(
                          context,
                          'Mock source view: ${article.source}.',
                        ),
                      ),
                      const SizedBox(width: LiquidGlassTheme.space8),
                      GlassIconButton(
                        icon: Icons.ios_share_rounded,
                        onTap: () => GlassMessage.show(
                          context,
                          'Share sheet staged for "${article.title}".',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: GlassSurface(
              radius: LiquidGlassTheme.radius28,
              level: GlassLevel.strong,
              padding: const EdgeInsets.symmetric(
                horizontal: LiquidGlassTheme.space16,
                vertical: LiquidGlassTheme.space12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Estimated read: ${article.readTimeMinutes} min',
                      style: LiquidGlassTheme.caption,
                    ),
                  ),
                  GlassIconButton(
                    icon: isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    active: isBookmarked,
                    onTap: () => state.toggleBookmark(article.id),
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
