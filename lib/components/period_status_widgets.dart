import 'package:flutter/material.dart';
import 'package:period_record/theme/app_colors.dart';
export 'period_in_progress_widget.dart';
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
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.favorite, size: 70, color: AppColors.white),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.25),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors.periodStartedGradient,
                  ),
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
              const SizedBox(height: 12),
              // Text(
              //   '今天是生理期第一天',
              //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //     color: colors.onSurfaceWithAlpha(ThemeColors.alpha70),
              //   ),
              // ),
              // const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colors.errorWithAlpha(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '第1天',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
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
