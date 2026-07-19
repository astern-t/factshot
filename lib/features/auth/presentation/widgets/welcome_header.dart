import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/utils/translations.dart';
import 'login_logo.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({
    super.key,
    required this.isLogin,
    required this.onToggleMode,
  });

  final bool isLogin;
  final VoidCallback onToggleMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left-aligned brand logo
        const Align(alignment: Alignment.centerLeft, child: LoginLogo()),
        const SizedBox(height: LiquidGlassTheme.space32),

        // Bold editorial title with smooth animated switching
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Text(
            isLogin
                ? AppTranslations.translate(context, 'login')
                : AppTranslations.translate(context, 'register'),
            key: ValueKey<bool>(isLogin),
            style: LiquidGlassTheme.display.copyWith(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              color: LiquidGlassTheme.foreground,
            ),
          ),
        ),
        const SizedBox(height: LiquidGlassTheme.space12),

        // Interactive toggle subtitle
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Row(
            key: ValueKey<bool>(isLogin),
            children: [
              Text(
                isLogin
                    ? AppTranslations.translate(context, 'dont_have_account')
                    : AppTranslations.translate(context, 'have_account'),
                style: LiquidGlassTheme.body.copyWith(
                  color: LiquidGlassTheme.foregroundSoft,
                  fontSize: 15,
                ),
              ),
              GestureDetector(
                onTap: onToggleMode,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLogin
                          ? AppTranslations.translate(context, 'register_here')
                          : AppTranslations.translate(context, 'login_here'),
                      style: LiquidGlassTheme.bodyStrong.copyWith(
                        color: accent,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(CupertinoIcons.arrow_right, size: 14, color: accent),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
