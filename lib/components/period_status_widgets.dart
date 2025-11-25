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

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getNoPeriodGradient(colors, isDark),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 60,
              color: _getNoPeriodIconColor(colors, isDark),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '还没有记录生理期',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击下方按钮开始记录',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceWithAlpha(ThemeColors.alpha60),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getNoPeriodGradient(ThemeColors colors, bool isDark) {
    return colors.noPeriodGradient;
  }

  Color _getNoPeriodIconColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return colors.onPrimaryContainer;
    } else {
      return colors.primary;
    }
  }
}

// `PeriodStartedTodayWidget` 已抽离到
// `lib/components/period_started_today_widget.dart`
