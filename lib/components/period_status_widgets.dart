import 'package:flutter/material.dart';
import 'package:test_1/theme/app_colors.dart';

/// 显示天数的通用组件
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: _getDaysDisplayBackgroundColor(colors, isDark, color),
        borderRadius: BorderRadius.circular(20),
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

/// 生理期今天开始组件
class PeriodStartedTodayWidget extends StatelessWidget {
  final String title;

  const PeriodStartedTodayWidget({super.key, required this.title});

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
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors.periodStartedGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getPeriodStartedShadowColor(colors, isDark),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(Icons.favorite, size: 70, color: AppColors.white),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors.periodStartedGradient),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: _getPeriodStartedShadowColor(colors, isDark),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '今天是生理期第一天',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceWithAlpha(ThemeColors.alpha70),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPeriodStartedShadowColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return const Color(0xFFE57373).withValues(alpha: 0.4);
    } else {
      return colors.errorWithAlpha(0.3);
    }
  }
}

/// 生理期进行中组件
class PeriodInProgressWidget extends StatelessWidget {
  final String title;
  final int days;

  const PeriodInProgressWidget({
    super.key,
    required this.title,
    required this.days,
  });

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
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors.periodInProgressGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getPeriodInProgressShadowColor(colors, isDark),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.favorite, size: 70, color: AppColors.white),
                Positioned(
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '第$days天',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getPeriodInProgressBadgeTextColor(
                          colors,
                          isDark,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors.periodInProgressGradient),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: _getPeriodInProgressShadowColor(colors, isDark),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          DaysDisplayWidget(
            days: days,
            color: _getPeriodInProgressDaysColor(colors, isDark),
          ),
        ],
      ),
    );
  }

  Color _getPeriodInProgressShadowColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return const Color(0xFFF06292).withValues(alpha: 0.4);
    } else {
      return colors.errorWithAlpha(0.3);
    }
  }

  Color _getPeriodInProgressBadgeTextColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return const Color(0xFFEC407A);
    } else {
      return colors.error;
    }
  }

  Color _getPeriodInProgressDaysColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return const Color(0xFFEC407A);
    } else {
      return colors.error;
    }
  }
}

/// 生理期结束组件
class PeriodEndedWidget extends StatelessWidget {
  final String title;

  const PeriodEndedWidget({super.key, required this.title});

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
                colors: colors.periodEndedGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getPeriodEndedShadowColor(colors, isDark),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 60,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors.periodEndedGradient),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: _getPeriodEndedShadowColor(colors, isDark),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '生理期已结束',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceWithAlpha(ThemeColors.alpha70),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPeriodEndedShadowColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return const Color(0xFF81C784).withValues(alpha: 0.4);
    } else {
      return colors.primaryWithAlpha(0.3);
    }
  }
}

/// 默认状态显示组件
class DefaultPeriodStatusWidget extends StatelessWidget {
  final String title;
  final int days;

  const DefaultPeriodStatusWidget({
    super.key,
    required this.title,
    required this.days,
  });

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
                colors: colors.defaultStatusGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getDefaultStatusShadowColor(colors, isDark),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              size: 60,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors.defaultStatusGradient),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: _getDefaultStatusShadowColor(colors, isDark),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          DaysDisplayWidget(
            days: days,
            color: _getDefaultStatusDaysColor(colors, isDark),
          ),
        ],
      ),
    );
  }

  Color _getDefaultStatusShadowColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return const Color(0xFF9575CD).withValues(alpha: 0.4);
    } else {
      return colors.primaryWithAlpha(0.2);
    }
  }

  Color _getDefaultStatusDaysColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return const Color(0xFF7E57C2);
    } else {
      return colors.primary;
    }
  }
}
