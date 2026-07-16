import 'package:flutter/material.dart';
import 'package:factshot/app/app_state.dart';
import 'package:factshot/data/models/article/article_model.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/article_meta_row/article_meta_row.dart';
import 'package:factshot/core/widgets/glass_message/glass_message.dart';
import 'package:factshot/core/widgets/glass_icon_button/glass_icon_button.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/utils/translations.dart';
import 'package:factshot/core/utils/article_translations.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final isBookmarked = state.isBookmarked(article.id);
    final isHindiApp = state.appLanguage == 'Hindi';

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
                            category: AppTranslations.translate(context, 'cat_${article.category.toLowerCase()}').toUpperCase(),
                            trailingText: isHindiApp
                                ? '${article.readTimeMinutes} मिनट पठन • ${article.source}'
                                : '${article.readTimeMinutes} min read • ${article.source}',
                          ),
                          const SizedBox(height: LiquidGlassTheme.space20),
                          Text(
                            article.getLocalizedTitle(state.contentLanguage),
                            style: LiquidGlassTheme.display,
                          ),
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
                                  isHindiApp ? 'मुख्य बिंदु' : 'KEY TAKE',
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
                                  article.getLocalizedSummary(state.contentLanguage),
                                  style: LiquidGlassTheme.bodyStrong,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: LiquidGlassTheme.space24),
                          Text(
                            article.getLocalizedBody(state.contentLanguage),
                            style: LiquidGlassTheme.body,
                          ),
                          const SizedBox(height: LiquidGlassTheme.space24),
                          GlassSurface(
                            radius: LiquidGlassTheme.radius20,
                            level: GlassLevel.subtle,
                            padding: const EdgeInsets.all(
                              LiquidGlassTheme.space16,
                            ),
                            child: Text(
                              isHindiApp
                                  ? 'इस प्रोटोटाइप में स्रोत पहुंच, साझाकरण और बुकमार्किंग नकली लेकिन राज्य-आधारित हैं ताकि प्रत्येक नियंत्रण सुचारू रूप से कार्य करे।'
                                  : 'Source access, sharing, and bookmarking are mocked but stateful in this prototype so every visible control stays honest.',
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
                          isHindiApp
                              ? 'स्रोत दृश्य: ${article.source}।'
                              : 'Mock source view: ${article.source}.',
                        ),
                      ),
                      const SizedBox(width: LiquidGlassTheme.space8),
                      GlassIconButton(
                        icon: Icons.ios_share_rounded,
                        onTap: () => GlassMessage.show(
                          context,
                          isHindiApp
                              ? '"${article.getLocalizedTitle(state.contentLanguage)}" के लिए शेयर शीट।'
                              : 'Share sheet staged for "${article.getLocalizedTitle(state.contentLanguage)}".',
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
                      isHindiApp
                          ? 'अनुमानित पठन: ${article.readTimeMinutes} मिनट'
                          : 'Estimated read: ${article.readTimeMinutes} min',
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

