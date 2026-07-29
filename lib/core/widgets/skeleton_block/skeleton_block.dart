import 'package:flutter/material.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';

class SkeletonBlock extends StatefulWidget {
  const SkeletonBlock({
    super.key,
    this.height = 14,
    this.width,
    this.radius = LiquidGlassTheme.radius12,
    this.baseColor,
    this.highlightColor,
  });

  final double height;
  final double? width;
  final double radius;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  State<SkeletonBlock> createState() => _SkeletonBlockState();
}

class _SkeletonBlockState extends State<SkeletonBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = LiquidGlassTheme.isDark;
    final base = widget.baseColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.07));
    final highlight = widget.highlightColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.18)
            : Colors.black.withValues(alpha: 0.16));

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1.2 + (_controller.value * 2.4), -0.2),
              end: Alignment(1.2 + (_controller.value * 2.4), 0.2),
              colors: [
                base,
                highlight,
                base,
              ],
            ),
          ),
        );
      },
    );
  }
}
