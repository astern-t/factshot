import 'package:flutter/material.dart';
import 'package:factshot/app/app_state.dart';
import 'package:factshot/data/models/article/article_model.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';
import 'package:factshot/core/widgets/article_image/article_image.dart';
import 'package:factshot/core/utils/translations.dart';
import 'package:factshot/core/utils/article_translations.dart';

class ArticleGridCard extends StatelessWidget {
  const ArticleGridCard({
    super.key,
    required this.article,
    required this.onTap,
    this.onBookmarkTap,
    this.isBookmarked = false,
  });

  final NewsArticle article;
  final VoidCallback onTap;
  final VoidCallback? onBookmarkTap;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final state = AppScope.of(context);
    final effLang = state.contentLanguage;

    return GlassSurface(
      radius: LiquidGlassTheme.radius20,
      padding: EdgeInsets.zero,
      child: PressableScale(
        onTap: onTap,
        borderRadius: BorderRadius.circular(LiquidGlassTheme.radius20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image fills 52% of card height
            Expanded(
              flex: 52,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ArticleImage(imageUrl: article.imageUrl),
                  // Category Tag Chip
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Text(
                        AppTranslations.translate(
                          context,
                          'cat_${article.category.toLowerCase()}',
                        ).toUpperCase(),
                        style: TextStyle(
                          color: accent,
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Bookmark Icon
                  if (onBookmarkTap != null)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: onBookmarkTap,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.65),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Icon(
                            isBookmarked
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: isBookmarked ? accent : Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Text Content fills remaining 48% of card height with source & time at bottom
            Expanded(
              flex: 48,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      article.getLocalizedTitle(effLang),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: LiquidGlassTheme.bodyStrong.copyWith(
                        fontSize: 11.5,
                        height: 1.25,
                      ),
                    ),
                    Text(
                      '${article.source} • ${article.timestamp}',
                      style: LiquidGlassTheme.caption.copyWith(
                        fontSize: 9.5,
                        color: LiquidGlassTheme.foregroundSoft,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
