import 'package:flutter/material.dart';
import 'package:period_record/models/period_status_logic.dart';
import 'package:period_record/theme/app_colors.dart';

/// 生理期今天开始组件（已从 `period_status_widgets.dart` 抽离）
class PeriodStartedTodayWidget extends StatelessWidget {
  final String title;

  const PeriodStartedTodayWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final supportMessage = PeriodStatusLogic.supportMessage(
      PeriodStatus.startedToday,
      0,
    );
    final careTips = PeriodStatusLogic.careTips(PeriodStatus.startedToday, 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroHeader(context, colors, isDark),
          const SizedBox(height: 20),
          _buildSupportCard(context, supportMessage, colors, isDark),
          const SizedBox(height: 18),
          Text(
            '温柔提示',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.white,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                careTips
                    .map(
                      (tip) => _buildCareChip(
                        context,
                        icon: tip.icon,
                        label: tip.label,
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(
    BuildContext context,
    ThemeColors colors,
    bool isDark,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.favorite, color: AppColors.white, size: 44),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '迎接新的周期，放慢节奏，好好照顾自己。',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportCard(
    BuildContext context,
    String message,
    ThemeColors colors,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: isDark ? 0.08 : 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.2),
            ),
            child: const Icon(Icons.auto_awesome, color: AppColors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.25)),
        color: AppColors.white.withValues(alpha: 0.14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
