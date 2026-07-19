import 'package:flutter/material.dart';
import 'package:factshot/app/app_state.dart';
import 'package:factshot/data/models/article/article_model.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';
import 'package:factshot/core/widgets/article_image/article_image.dart';
import 'package:factshot/core/widgets/glass_icon_button/glass_icon_button.dart';
import 'package:factshot/core/utils/translations.dart';
import 'package:factshot/core/utils/article_translations.dart';

class ArticleListTileCard extends StatelessWidget {
  const ArticleListTileCard({
    super.key,
    required this.article,
    required this.onTap,
    this.onSecondaryTap,
    this.secondaryIcon,
    this.language,
    this.onLanguageChanged,
  });

  final NewsArticle article;
  final VoidCallback onTap;
  final VoidCallback? onSecondaryTap;
  final IconData? secondaryIcon;
  final String? language;
  final ValueChanged<String>? onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final state = AppScope.of(context);
    final effLang = language ?? state.contentLanguage;

    return GlassSurface(
      radius: LiquidGlassTheme.radius24,
      padding: const EdgeInsets.all(LiquidGlassTheme.space16),
      child: PressableScale(
        onTap: onTap,
        borderRadius: BorderRadius.circular(LiquidGlassTheme.radius24),
        child: Row(
          children: [
            const SizedBox(width: 0),
            SizedBox(
              width: 84,
              height: 84,
              child: ArticleImage(imageUrl: article.imageUrl),
            ),
            const SizedBox(width: LiquidGlassTheme.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslations.translate(
                      context,
                      'cat_${article.category.toLowerCase()}',
                    ).toUpperCase(),
                    style: LiquidGlassTheme.overline.copyWith(color: accent),
                  ),
                  const SizedBox(height: LiquidGlassTheme.space8),
                  Text(
                    article.getLocalizedTitle(effLang),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: LiquidGlassTheme.bodyStrong,
                  ),
                  const SizedBox(height: LiquidGlassTheme.space8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${article.source} • ${article.timestamp}',
                          style: LiquidGlassTheme.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onLanguageChanged != null) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            final current = effLang;
                            final next = current == 'English'
                                ? 'Hindi'
                                : (current == 'Hindi' ? 'Both' : 'English');
                            onLanguageChanged!(next);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.06),
                              ),
                            ),
                            child: Text(
                              effLang == 'Both'
                                  ? 'Both'
                                  : effLang == 'Hindi'
                                      ? 'हिंदी'
                                      : 'EN',
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (secondaryIcon != null) ...[
              const SizedBox(width: LiquidGlassTheme.space12),
              GlassIconButton(
                icon: secondaryIcon!,
                onTap: onSecondaryTap,
                size: 42,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
