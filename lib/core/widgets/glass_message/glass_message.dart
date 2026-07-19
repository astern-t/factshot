import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';

class GlassMessage {
  static void show(BuildContext context, String text, {IconData? icon}) {
    HapticFeedback.lightImpact();

    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _GlassMessageNotification(
        text: text,
        icon: icon,
        onDismiss: () {
          overlayEntry.remove();
        },
      ),
    );

    overlayState.insert(overlayEntry);
  }
}

class _GlassMessageNotification extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onDismiss;

  const _GlassMessageNotification({
    required this.text,
    this.icon,
    required this.onDismiss,
  });

  @override
  State<_GlassMessageNotification> createState() => _GlassMessageNotificationState();
}

class _GlassMessageNotificationState extends State<_GlassMessageNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _yOffset;
  late Animation<double> _opacity;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 375),
    );

    _yOffset = Tween<double>(begin: -80.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    _dismissTimer = Timer(const Duration(milliseconds: 2300), () {
      if (mounted) {
        _controller.reverse().then((_) {
          widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 16.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final accent = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: topPadding + _yOffset.value,
          left: 16,
          right: 16,
          child: Opacity(
            opacity: _opacity.value,
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenWidth - 32),
                  child: GlassSurface(
                    radius: LiquidGlassTheme.radius16,
                    level: GlassLevel.strong,
                    borderColor: accent.withValues(alpha: 0.25),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.icon ?? Icons.info_outline_rounded,
                          color: accent,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            widget.text,
                            style: LiquidGlassTheme.bodyStrong.copyWith(
                              fontSize: 13,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
