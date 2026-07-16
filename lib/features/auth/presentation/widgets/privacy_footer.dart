import 'package:flutter/material.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/glass_message/glass_message.dart';

class PrivacyFooter extends StatelessWidget {
  const PrivacyFooter({
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: crossAxisAlignment == CrossAxisAlignment.end
              ? MainAxisAlignment.end
              : MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () =>
                  GlassMessage.show(context, 'Privacy Policy is coming soon.'),
              child: Text(
                'Privacy Policy',
                style: LiquidGlassTheme.caption.copyWith(
                  color: LiquidGlassTheme.foregroundSoft,
                  decoration: TextDecoration.underline,
                  decorationColor: LiquidGlassTheme.foregroundSoft.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(width: LiquidGlassTheme.space12),
            Text(
              '•',
              style: TextStyle(
                color: LiquidGlassTheme.foregroundSoft.withValues(alpha: 0.4),
                fontSize: 10,
              ),
            ),
            const SizedBox(width: LiquidGlassTheme.space12),
            GestureDetector(
              onTap: () => GlassMessage.show(
                context,
                'Terms of Service is coming soon.',
              ),
              child: Text(
                'Terms of Use',
                style: LiquidGlassTheme.caption.copyWith(
                  color: LiquidGlassTheme.foregroundSoft,
                  decoration: TextDecoration.underline,
                  decorationColor: LiquidGlassTheme.foregroundSoft.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: LiquidGlassTheme.space8),
        Text(
          'FactShot v1.0.0',
          style: LiquidGlassTheme.caption.copyWith(
            color: LiquidGlassTheme.foregroundSoft.withValues(alpha: 0.5),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
