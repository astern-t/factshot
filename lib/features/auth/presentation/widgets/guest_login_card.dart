import 'package:flutter/material.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';

class GuestLoginCard extends StatelessWidget {
  const GuestLoginCard({super.key, required this.onTap, this.disabled = false});

  final VoidCallback onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: disabled ? () {} : onTap,
      borderRadius: BorderRadius.circular(LiquidGlassTheme.radius28),
      child: Opacity(
        opacity: disabled ? 0.55 : 1.0,
        child: GlassSurface(
          radius: LiquidGlassTheme.radius28,
          padding: const EdgeInsets.all(LiquidGlassTheme.space20),
          level: GlassLevel.subtle,
          child: SizedBox(
            height: 125,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Guest Icon Container (at top-left)
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.04),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: LiquidGlassTheme.foregroundSoft,
                      size: 20,
                    ),
                  ),
                ),
                // Text Column at bottom-left
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'with',
                      style: LiquidGlassTheme.caption.copyWith(
                        color: LiquidGlassTheme.foregroundSoft,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Guest',
                      style: LiquidGlassTheme.bodyStrong.copyWith(
                        color: LiquidGlassTheme.foreground,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
