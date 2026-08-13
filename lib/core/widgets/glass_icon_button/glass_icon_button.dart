import 'package:flutter/material.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';

class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    this.icon,
    this.customIcon,
    this.onTap,
    this.active = false,
    this.size = 52,
    this.iconColor,
    this.borderColor,
    this.customFillColor,
  });

  final IconData? icon;
  final Widget? customIcon;
  final VoidCallback? onTap;
  final bool active;
  final double size;
  final Color? iconColor;
  final Color? borderColor;
  final Color? customFillColor;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return GlassSurface(
      width: size,
      height: size,
      radius: size / 2,
      level: active ? GlassLevel.strong : GlassLevel.subtle,
      tintColor: active ? accent : null,
      borderColor: borderColor,
      customFillColor: customFillColor,
      child: PressableScale(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: Center(
          child: customIcon ?? Icon(
            icon!,
            color: iconColor ?? (active ? Colors.white : LiquidGlassTheme.foreground),
            size: 22,
          ),
        ),
      ),
    );
  }
}
