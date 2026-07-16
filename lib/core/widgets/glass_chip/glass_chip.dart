import 'package:flutter/material.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';

class GlassChip extends StatelessWidget {
  const GlassChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return GlassSurface(
      radius: LiquidGlassTheme.radius16,
      level: selected ? GlassLevel.strong : GlassLevel.subtle,
      tintColor: selected ? accent : null,
      child: PressableScale(
        onTap: onTap,
        borderRadius: BorderRadius.circular(LiquidGlassTheme.radius16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LiquidGlassTheme.space16,
            vertical: LiquidGlassTheme.space12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: selected ? accent : LiquidGlassTheme.foregroundSoft,
                ),
                const SizedBox(width: LiquidGlassTheme.space8),
              ],
              Text(
                label,
                style: LiquidGlassTheme.caption.copyWith(
                  color: selected
                      ? Colors.white
                      : LiquidGlassTheme.foregroundMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
