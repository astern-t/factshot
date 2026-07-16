import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryAccent = theme.colorScheme.primary;

    // Ambient background colors adapt dynamically to theme
    final bgGradientColors = isDark
        ? [
            const Color(0xFF040609),
            const Color(0xFF080C14),
            const Color(0xFF040609),
          ]
        : [
            const Color(0xFFF8FAFC),
            const Color(0xFFF1F5F9),
            const Color(0xFFF8FAFC),
          ];

    final glow1Color = primaryAccent.withValues(alpha: isDark ? 0.14 : 0.10);
    final glow2Color =
        const Color(0xFF6366F1).withValues(alpha: isDark ? 0.08 : 0.05);
    final glow3Color =
        (isDark ? Colors.white : Colors.black).withValues(alpha: 0.02);

    return Stack(
      children: [
        // Base Ambient Gradient
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: bgGradientColors,
              ),
            ),
          ),
        ),

        // Glowing Ambient Orb - Top Center (Primary Accent Blue Glow)
        Positioned(
          top: -200,
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          child: IgnorePointer(
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: glow1Color,
                    blurRadius: 180,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Glowing Ambient Orb - Bottom Left (Soft Indigo/Purple Accent Glow)
        Positioned(
          bottom: -180,
          left: -120,
          child: IgnorePointer(
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: glow2Color,
                    blurRadius: 160,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Glowing Ambient Orb - Middle Right (Ultra Soft Contrast Glow)
        Positioned(
          top: MediaQuery.of(context).size.height * 0.35,
          right: -160,
          child: IgnorePointer(
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: glow3Color,
                    blurRadius: 140,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Foreground Content
        child,
      ],
    );
  }
}
