import 'package:flutter/material.dart';

class FactShotBackground extends StatelessWidget {
  const FactShotBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF000000) // Pure black for Apple/Premium dark mode
        : const Color(0xFFF2F2F7); // Apple standard light gray background

    return Container(
      color: backgroundColor,
      child: child,
    );
  }
}
