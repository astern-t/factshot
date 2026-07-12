import 'dart:ui';

import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../theme/liquid_glass_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final accentColor = tintColor ?? state.accentColor;
    final blur = switch (level) {
      GlassLevel.subtle => state.blurSigma - 8,
      GlassLevel.regular => state.blurSigma,
      GlassLevel.strong => state.blurSigma + 8,
    };
    final opacityScale = switch (level) {
      GlassLevel.subtle => 0.82,
      GlassLevel.regular => 1.0,
      GlassLevel.strong => 1.14,
    };
    final baseColor = Colors.white.withValues(
      alpha: state.glassOpacity * opacityScale,
    );
    final tint = accentColor.withValues(
      alpha: state.accentTintOpacity * opacityScale,
    );
    final fillColor = Color.alphaBlend(tint, baseColor);
    final effectiveShadowColor = shadowColor ?? Colors.black;
    final effectiveBorderColor =
        borderColor ??
        Color.alphaBlend(
          accentColor.withValues(alpha: 0.18),
          Colors.white.withValues(alpha: 0.24),
        );

    return Container(
      width: width,
      height: height,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: effectiveShadowColor.withValues(alpha: 0.34),
            blurRadius: 36,
            spreadRadius: -14,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: accentColor.withValues(
              alpha: level == GlassLevel.strong ? 0.18 : 0.1,
            ),
            blurRadius: 32,
            spreadRadius: -20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: const SizedBox.expand(),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(radius),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.18),
                      Colors.white.withValues(alpha: 0.06),
                      Colors.black.withValues(alpha: 0.08),
                    ],
                  ),
                  border: Border.all(color: effectiveBorderColor, width: 1),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.12),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.05),
                      ],
                      stops: const [0, 0.2, 1],
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: padding ?? EdgeInsets.zero, child: child),
          ],
        ),
      ),
    );
  }
}
