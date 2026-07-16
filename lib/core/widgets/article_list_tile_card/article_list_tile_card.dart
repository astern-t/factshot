import 'package:flutter/material.dart';
import 'package:factshot/data/models/article/article_model.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';
import 'package:factshot/core/widgets/article_image/article_image.dart';
import 'package:factshot/core/widgets/glass_icon_button/glass_icon_button.dart';

class ArticleListTileCard extends StatelessWidget {
  const ArticleListTileCard({
    super.key,
    required this.article,
    required this.onTap,
    this.onSecondaryTap,
    this.secondaryIcon,
  });

  final NewsArticle article;
  final VoidCallback onTap;
  final VoidCallback? onSecondaryTap;
  final IconData? secondaryIcon;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
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
                    article.category,
                    style: LiquidGlassTheme.overline.copyWith(color: accent),
                  ),
                  const SizedBox(height: LiquidGlassTheme.space8),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: LiquidGlassTheme.bodyStrong,
                  ),
                  const SizedBox(height: LiquidGlassTheme.space8),
                  Text(
                    '${article.source} • ${article.timestamp}',
                    style: LiquidGlassTheme.caption,
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
