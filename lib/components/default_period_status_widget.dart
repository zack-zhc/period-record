import 'package:flutter/material.dart';
import 'package:period_record/models/period_status_logic.dart';
import 'package:period_record/theme/app_colors.dart';
import 'package:period_record/components/days_display_widget.dart';

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
    final gradientColors =
        colors.defaultStatusGradient
            .map(
              (color) =>
                  Color.lerp(color, AppColors.white, isDark ? 0.08 : 0.2) ??
                  color,
            )
            .toList();
    final supportMessage = PeriodStatusLogic.supportMessage(
      PeriodStatus.ended,
      days,
    );
    final careTips = PeriodStatusLogic.careTips(PeriodStatus.ended, days);

    return Container(
      margin: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: _getDefaultStatusShadowColor(colors, isDark),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Icon(
                      Icons.calendar_month_outlined,
                      size: 30,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
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
                        const SizedBox(height: 4),
                        Text(
                          '持续记录与关怀，让身体保持平衡。',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  DaysDisplayWidget(
                    days: days,
                    color: AppColors.white,
                    numberStyle: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    labelStyle: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.self_improvement,
                      color: AppColors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        supportMessage,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
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
        ),
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

  Widget _buildCareChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.22)),
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
