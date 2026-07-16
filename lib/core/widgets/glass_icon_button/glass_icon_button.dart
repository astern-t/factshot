import 'package:flutter/material.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';

class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.active = false,
    this.size = 52,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool active;
  final double size;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return GlassSurface(
      width: size,
      height: size,
      radius: size / 2,
      level: active ? GlassLevel.strong : GlassLevel.subtle,
      tintColor: active ? accent : null,
      child: PressableScale(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: Center(
          child: Icon(
            icon,
            color: iconColor ?? (active ? accent : LiquidGlassTheme.foreground),
            size: 22,
          ),
        ),
      ),
    );
  }
}
