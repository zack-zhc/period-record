import 'package:flutter/material.dart';
import 'package:period_record/models/period_status_logic.dart';
import 'package:period_record/theme/app_colors.dart';

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
    final supportMessage = PeriodStatusLogic.supportMessage(
      PeriodStatus.inProgress,
      days,
    );
    final careTips = PeriodStatusLogic.careTips(PeriodStatus.inProgress, days);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: _getPeriodInProgressShadowColor(colors, isDark),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: AppColors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '温柔地照顾自己，放慢脚步。',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: AppColors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.28),
                        ),
                      ),
                      child: Text(
                        '第$days天',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: AppColors.white.withValues(alpha: 0.1),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white.withValues(alpha: 0.18),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: AppColors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          supportMessage,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.white, height: 1.45),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    const spacing = 12.0;
                    final maxWidth = constraints.maxWidth;
                    final tileWidth = (maxWidth - spacing) / 2;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: 12,
                      children:
                          careTips
                              .map(
                                (tip) => SizedBox(
                                  width: tileWidth,
                                  child: _buildCareChip(
                                    context,
                                    icon: tip.icon,
                                    label: tip.label,
                                  ),
                                ),
                              )
                              .toList(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.2),
            ),
            child: Icon(icon, size: 16, color: AppColors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
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
}
