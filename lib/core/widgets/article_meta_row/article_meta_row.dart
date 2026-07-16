import 'package:flutter/material.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/glass_chip/glass_chip.dart';

class ArticleMetaRow extends StatelessWidget {
  const ArticleMetaRow({
    super.key,
    required this.category,
    required this.trailingText,
  });

  final String category;
  final String trailingText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GlassChip(label: category, selected: true),
        const SizedBox(width: LiquidGlassTheme.space12),
        Expanded(
          child: Text(
            trailingText,
            style: LiquidGlassTheme.caption,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
