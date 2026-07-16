import 'package:flutter/material.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.action,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return GlassSurface(
      radius: LiquidGlassTheme.radius28,
      padding: const EdgeInsets.all(LiquidGlassTheme.space24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.16),
            ),
            child: Icon(icon, color: accent, size: 32),
          ),
          const SizedBox(height: LiquidGlassTheme.space20),
          Text(
            title,
            style: LiquidGlassTheme.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: LiquidGlassTheme.space12),
          Text(
            description,
            style: LiquidGlassTheme.body,
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            const SizedBox(height: LiquidGlassTheme.space24),
            action!,
          ],
        ],
      ),
    );
  }
}
