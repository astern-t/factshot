import 'package:flutter/material.dart';

class FactShotBackground extends StatelessWidget {
  const FactShotBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF05070B),
                  const Color(0xFF09111D),
                  const Color(0xFF05070B),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -120,
          right: -80,
          child: _GlowOrb(color: accent.withValues(alpha: 0.22), size: 280),
        ),
        Positioned(
          bottom: -130,
          left: -100,
          child: _GlowOrb(color: accent.withValues(alpha: 0.16), size: 320),
        ),
        Positioned(
          top: 220,
          left: -140,
          child: _GlowOrb(
            color: Colors.white.withValues(alpha: 0.06),
            size: 260,
          ),
        ),
        child,
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: size * 0.36,
              spreadRadius: size * 0.08,
            ),
          ],
        ),
      ),
    );
  }
}
