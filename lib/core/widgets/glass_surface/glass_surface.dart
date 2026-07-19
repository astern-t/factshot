import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';

enum GlassLevel { subtle, regular, strong }

class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius = LiquidGlassTheme.radius24,
    this.level = GlassLevel.regular,
    this.tintColor,
    this.alignment,
    this.width,
    this.height,
    this.borderColor,
    this.shadowColor,
    this.customFillColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final GlassLevel level;
  final Color? tintColor;
  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? shadowColor;
  final Color? customFillColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Frosted colors with correct opacity to let background peek through with high readability
    final defaultFillColor = isDark
        ? const Color(0xC512141A) // Frosted deep charcoal
        : const Color(0xCCF8FAFC); // Frosted soft slate white

    final fillColor = customFillColor ??
        (tintColor != null
            ? tintColor!.withValues(alpha: isDark ? 0.15 : 0.25)
            : defaultFillColor);

    final effectiveBorderColor =
        borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.black.withValues(alpha: 0.08));

    final effectiveShadowColor =
        shadowColor ??
        (isDark
            ? Colors.black.withValues(alpha: 0.25)
            : Colors.black.withValues(alpha: 0.05));

    return Container(
      width: width,
      height: height,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: level == GlassLevel.subtle
            ? null
            : [
                BoxShadow(
                  color: effectiveShadowColor,
                  blurRadius: level == GlassLevel.strong ? 32 : 16,
                  spreadRadius: level == GlassLevel.strong ? 4 : 0,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
          child: Container(
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: effectiveBorderColor, width: 1.0),
            ),
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}
