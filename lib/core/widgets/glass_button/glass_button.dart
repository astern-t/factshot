import 'package:flutter/material.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';

class GlassButton extends StatelessWidget {
  const GlassButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.isPrimary = false,
    this.isLoading = false,
    this.expanded = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isPrimary;
  final bool isLoading;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    // Flat, solid colors
    final backgroundColor = isPrimary 
        ? accent 
        : (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7));
    
    final textColor = isPrimary 
        ? Colors.white 
        : (isDark ? Colors.white : Colors.black);

    final child = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null)
          Icon(
            icon,
            size: 18,
            color: textColor,
          ),
        if (icon != null)
          const SizedBox(width: LiquidGlassTheme.space12),
        Text(
          label,
          style: LiquidGlassTheme.bodyStrong.copyWith(
            color: textColor,
          ),
        ),
      ],
    );

    return PressableScale(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: expanded ? double.infinity : null,
        padding: const EdgeInsets.symmetric(
          horizontal: LiquidGlassTheme.space24,
          vertical: LiquidGlassTheme.space16,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
    );
  }
}
