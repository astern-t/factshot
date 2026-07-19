import 'package:flutter/material.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';

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
                return Container(color: Colors.white.withValues(alpha: 0.04));
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
