import 'package:flutter/material.dart';
import 'package:period_record/theme/app_colors.dart';
export 'period_in_progress_widget.dart';
export 'period_started_today_widget.dart';
export 'period_ended_widget.dart';
export 'default_period_status_widget.dart';
export 'days_display_widget.dart';

/// 无记录状态组件
class NoPeriodWidget extends StatelessWidget {
  const NoPeriodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildBadge(context, colors, isDark),
          const SizedBox(height: 20),
          _buildIconHalo(colors, isDark),
          const SizedBox(height: 20),
          Text(
            '还没有记录生理期',
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '记录下每一次生理期，帮助自己更好地了解身体节奏。准备好时，点击下方按钮开始吧。',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceWithAlpha(ThemeColors.alpha70),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBadgeColor(ThemeColors colors, bool isDark) {
    return isDark ? colors.primaryWithAlpha(0.4) : colors.primary;
  }

  Color _getIconContainerColor(ThemeColors colors, bool isDark) {
    return isDark
        ? colors.surfaceContainerWithAlpha(0.4)
        : colors.surfaceWithAlpha(0.8);
  }

  Color _getNoPeriodIconColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return colors.onPrimaryContainer;
    } else {
      return colors.primary;
    }
  }

  Widget _buildBadge(BuildContext context, ThemeColors colors, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: _getBadgeColor(colors, isDark),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '温馨提示',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: colors.onPrimary,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _buildIconHalo(ThemeColors colors, bool isDark) {
    return SizedBox(
      width: 96,
      height: 96,
      // decoration: BoxDecoration(
      //   shape: BoxShape.circle,
      //   color: _getIconContainerColor(colors, isDark),
      //   border: Border.all(
      //     color: colors.onSurfaceWithAlpha(ThemeColors.alpha10),
      //     width: 1.5,
      //   ),
      //   boxShadow: [
      //     BoxShadow(
      //       color: colors.primaryWithAlpha(isDark ? 0.25 : 0.18),
      //       blurRadius: 32,
      //     ),
      //   ],
      // ),
      child: Icon(
        Icons.favorite_border,
        size: 80,
        color: _getNoPeriodIconColor(colors, isDark),
      ),
    );
  }
}

// `PeriodStartedTodayWidget` 已抽离到
// `lib/components/period_started_today_widget.dart`
