import 'dart:math' as math;
import 'package:flutter/material.dart';

class FactListenWaveform extends StatefulWidget {
  const FactListenWaveform({
    super.key,
    required this.isPlaying,
    required this.color,
    this.barCount = 19,
    this.barWidth = 3.5,
    this.spacing = 3.0,
  });

  final bool isPlaying;
  final Color color;
  final int barCount;
  final double barWidth;
  final double spacing;

  @override
  State<FactListenWaveform> createState() => _FactListenWaveformState();
}

class _FactListenWaveformState extends State<FactListenWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant FactListenWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(widget.barCount, (index) {
            double amplitude = 0.15; // default static height multiplier when paused
            
            if (widget.isPlaying) {
              // Generate clean wave shapes using sine/cosine offsets
              final double t = _controller.value * 2 * math.pi;
              final double phase = (index / widget.barCount) * 3 * math.pi;
              
              // Multi-frequency wave formula to make the sound wave look more natural
              amplitude = 0.2 + 0.8 * (
                (math.sin(t + phase).abs() * 0.7) +
                (math.cos(t * 1.5 + phase * 0.5).abs() * 0.3)
              );
            }

            // Center bars are taller, side bars are shorter for a nice symmetrically curved envelope
            final double centerFactor = 1.0 - ( (index - (widget.barCount / 2)).abs() / (widget.barCount / 2) );
            final double finalHeight = 8.0 + (32.0 * amplitude * (0.4 + 0.6 * centerFactor));

            return AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
              width: widget.barWidth,
              height: finalHeight,
              decoration: BoxDecoration(
                color: widget.color.withValues(
                  alpha: widget.isPlaying ? (0.4 + 0.6 * amplitude) : 0.4,
                ),
                borderRadius: BorderRadius.circular(widget.barWidth / 2),
              ),
            );
          }),
        );
      },
    );
  }
}
