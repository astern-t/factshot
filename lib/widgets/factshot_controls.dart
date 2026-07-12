import 'package:flutter/material.dart';

import '../theme/liquid_glass_theme.dart';
import 'glass_surface.dart';

class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) {
      return;
    }
    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: LiquidGlassTheme.quick,
      curve: LiquidGlassTheme.emphasized,
      scale: _pressed ? 0.98 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: widget.borderRadius,
          onTap: widget.onTap,
          onTapDown: (_) => _setPressed(true),
          onTapCancel: () => _setPressed(false),
          onTapUp: (_) => _setPressed(false),
          child: widget.child,
        ),
      ),
    );
  }
}

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
    final accent = Theme.of(context).colorScheme.primary;
    final child = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isPrimary ? LiquidGlassTheme.background : accent,
              ),
            ),
          )
        else if (icon != null)
          Icon(
            icon,
            size: 18,
            color: isPrimary ? LiquidGlassTheme.background : Colors.white,
          ),
        if (isLoading || icon != null)
          const SizedBox(width: LiquidGlassTheme.space12),
        Text(
          label,
          style: LiquidGlassTheme.bodyStrong.copyWith(
            color: isPrimary ? LiquidGlassTheme.background : Colors.white,
          ),
        ),
      ],
    );

    return GlassSurface(
      radius: LiquidGlassTheme.radius20,
      level: isPrimary ? GlassLevel.strong : GlassLevel.regular,
      tintColor: isPrimary ? accent : null,
      child: PressableScale(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(LiquidGlassTheme.radius20),
        child: Container(
          width: expanded ? double.infinity : null,
          padding: const EdgeInsets.symmetric(
            horizontal: LiquidGlassTheme.space20,
            vertical: LiquidGlassTheme.space16,
          ),
          decoration: BoxDecoration(
            color: isPrimary
                ? accent.withValues(alpha: 0.82)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(LiquidGlassTheme.radius20),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.active = false,
    this.size = 52,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool active;
  final double size;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return GlassSurface(
      width: size,
      height: size,
      radius: size / 2,
      level: active ? GlassLevel.strong : GlassLevel.subtle,
      tintColor: active ? accent : null,
      child: PressableScale(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: Center(
          child: Icon(
            icon,
            color: iconColor ?? (active ? accent : Colors.white),
            size: 22,
          ),
        ),
      ),
    );
  }
}

class GlassChip extends StatelessWidget {
  const GlassChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return GlassSurface(
      radius: LiquidGlassTheme.radius16,
      level: selected ? GlassLevel.strong : GlassLevel.subtle,
      tintColor: selected ? accent : null,
      child: PressableScale(
        onTap: onTap,
        borderRadius: BorderRadius.circular(LiquidGlassTheme.radius16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LiquidGlassTheme.space16,
            vertical: LiquidGlassTheme.space12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: selected ? accent : Colors.white70),
                const SizedBox(width: LiquidGlassTheme.space8),
              ],
              Text(
                label,
                style: LiquidGlassTheme.caption.copyWith(
                  color: selected
                      ? Colors.white
                      : LiquidGlassTheme.foregroundMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassTextField extends StatelessWidget {
  const GlassTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      radius: LiquidGlassTheme.radius20,
      level: GlassLevel.regular,
      padding: const EdgeInsets.symmetric(horizontal: LiquidGlassTheme.space16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        keyboardType: keyboardType,
        style: LiquidGlassTheme.body.copyWith(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: LiquidGlassTheme.body.copyWith(color: Colors.white38),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
