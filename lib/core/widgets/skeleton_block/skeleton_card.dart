import 'package:flutter/material.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/widgets/skeleton_block/skeleton_block.dart';

class SkeletonArticleTileCard extends StatelessWidget {
  const SkeletonArticleTileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      radius: LiquidGlassTheme.radius24,
      padding: const EdgeInsets.all(LiquidGlassTheme.space16),
      child: Row(
        children: [
          const SkeletonBlock(
            height: 84,
            width: 84,
            radius: LiquidGlassTheme.radius20,
          ),
          const SizedBox(width: LiquidGlassTheme.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBlock(width: 70, height: 12),
                SizedBox(height: LiquidGlassTheme.space12),
                SkeletonBlock(width: double.infinity, height: 16),
                SizedBox(height: LiquidGlassTheme.space8),
                SkeletonBlock(width: 140, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonFeedCard extends StatelessWidget {
  const SkeletonFeedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: LiquidGlassTheme.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(LiquidGlassTheme.space20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top category badge skeleton
              const SkeletonBlock(
                width: 100,
                height: 28,
                radius: LiquidGlassTheme.radius16,
              ),
              const SizedBox(height: LiquidGlassTheme.space20),
              // Main Hero Image Skeleton
              Expanded(
                flex: 5,
                child: SkeletonBlock(
                  width: double.infinity,
                  height: double.infinity,
                  radius: LiquidGlassTheme.radius28,
                ),
              ),
              const SizedBox(height: LiquidGlassTheme.space24),
              // Article Title Skeleton
              const SkeletonBlock(width: double.infinity, height: 24),
              const SizedBox(height: LiquidGlassTheme.space8),
              const SkeletonBlock(width: 220, height: 24),
              const SizedBox(height: LiquidGlassTheme.space16),
              // Article Summary Paragraph Skeleton
              const SkeletonBlock(width: double.infinity, height: 14),
              const SizedBox(height: LiquidGlassTheme.space8),
              const SkeletonBlock(width: double.infinity, height: 14),
              const SizedBox(height: LiquidGlassTheme.space8),
              const SkeletonBlock(width: 180, height: 14),
              const SizedBox(height: LiquidGlassTheme.space24),
              // Footer metadata row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  SkeletonBlock(width: 120, height: 14),
                  SkeletonBlock(width: 80, height: 14),
                ],
              ),
              const SizedBox(height: LiquidGlassTheme.space16),
            ],
          ),
        ),
      ),
    );
  }
}
