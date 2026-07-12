import 'package:flutter/material.dart';

import '../models/news_article.dart';
import '../theme/liquid_glass_theme.dart';
import 'factshot_controls.dart';
import 'glass_surface.dart';

class ArticleImage extends StatelessWidget {
  const ArticleImage({super.key, required this.imageUrl, this.height});

  final String imageUrl;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(LiquidGlassTheme.radius20),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                }
                return Container(color: Colors.white10);
              },
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.white10),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.28),
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

class ArticleMetaRow extends StatelessWidget {
  const ArticleMetaRow({
    super.key,
    required this.category,
    required this.trailingText,
  });

  final String category;
  final String trailingText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GlassChip(label: category, selected: true),
        const SizedBox(width: LiquidGlassTheme.space12),
        Expanded(
          child: Text(
            trailingText,
            style: LiquidGlassTheme.caption,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

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
