import 'package:flutter/material.dart';

import 'package:factshot/core/theme/liquid_glass_theme.dart';

class GlassPageRoute<T> extends PageRouteBuilder<T> {
  GlassPageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: LiquidGlassTheme.slow,
        reverseTransitionDuration: LiquidGlassTheme.regular,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: LiquidGlassTheme.emphasizedDecelerate,
            reverseCurve: LiquidGlassTheme.emphasizedAccelerate,
          );
          final slide = Tween<Offset>(
            begin: const Offset(0, 0.025),
            end: Offset.zero,
          ).animate(curved);
          final fade = Tween<double>(begin: 0, end: 1).animate(curved);
          final scale = Tween<double>(begin: 0.985, end: 1).animate(curved);

          return FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: ScaleTransition(scale: scale, child: child),
            ),
          );
        },
      );

  final Widget page;
}
