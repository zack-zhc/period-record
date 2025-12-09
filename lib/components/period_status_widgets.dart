import 'package:flutter/material.dart';
import 'package:period_record/theme/app_colors.dart';
export 'period_in_progress_widget.dart';
export 'period_started_today_widget.dart';
export 'period_ended_widget.dart';
export 'default_period_status_widget.dart';
export 'days_display_widget.dart';

/// 无记录状态组件 - Material 3 Expressive 风格
class NoPeriodWidget extends StatelessWidget {
  const NoPeriodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(
        color: isDark ? colors.surfaceContainer : colors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: colors.outline.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withValues(alpha: isDark ? 0.1 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 装饰性背景图形
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: colors.secondary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildExpressiveIcon(colors),
                const SizedBox(height: 24),
                Text(
                  '还没有记录',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  '记录生理期不仅是关注身体，\n更是爱自己的开始',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _buildFeatureRow(context, colors),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpressiveIcon(ThemeColors colors) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        Icons.volunteer_activism_rounded,
        size: 40,
        color: colors.onPrimaryContainer,
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, ThemeColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFeatureItem(context, colors, Icons.calendar_today_rounded, '记录'),
        _buildDivider(colors),
        _buildFeatureItem(context, colors, Icons.insights_rounded, '分析'),
        _buildDivider(colors),
        _buildFeatureItem(context, colors, Icons.spa_rounded, '呵护'),
      ],
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    ThemeColors colors,
    IconData icon,
    String label,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: colors.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(ThemeColors colors) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: colors.outline.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
    );
  }
}

// `PeriodStartedTodayWidget` 已抽离到
// `lib/components/period_started_today_widget.dart`
