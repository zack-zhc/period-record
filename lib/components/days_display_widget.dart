import 'package:flutter/material.dart';
import 'package:period_record/theme/app_colors.dart';

class DaysDisplayWidget extends StatelessWidget {
  final int days;
  final TextStyle? numberStyle;
  final TextStyle? labelStyle;
  final Color? color;

  const DaysDisplayWidget({
    super.key,
    required this.days,
    this.numberStyle,
    this.labelStyle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultNumberStyle = Theme.of(context).textTheme.headlineLarge
        ?.copyWith(fontWeight: FontWeight.bold, color: color);

    final defaultLabelStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: color);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getDaysDisplayBackgroundColor(colors, isDark, color),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getDaysDisplayBorderColor(colors, isDark, color),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$days', style: numberStyle ?? defaultNumberStyle),
          const SizedBox(width: 4),
          Text('天', style: labelStyle ?? defaultLabelStyle),
        ],
      ),
    );
  }

  Color _getDaysDisplayBackgroundColor(
    ThemeColors colors,
    bool isDark,
    Color? color,
  ) {
    if (color != null) {
      return color.withValues(alpha: isDark ? 0.15 : 0.1);
    }
    return colors.primaryWithAlpha(isDark ? 0.15 : 0.1);
  }

  Color _getDaysDisplayBorderColor(
    ThemeColors colors,
    bool isDark,
    Color? color,
  ) {
    if (color != null) {
      return color.withValues(alpha: isDark ? 0.4 : 0.3);
    }
    return colors.primaryWithAlpha(isDark ? 0.4 : 0.3);
  }
}
