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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: _getDefaultStatusShadowColor(colors, isDark),
              blurRadius: 32,
              offset: const Offset(0, 12),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '持续记录与关怀，让身体保持平衡。',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: AppColors.white.withValues(alpha: 0.82),
                              height: 1.4,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    DaysDisplayWidget(
                      days: days,
                      color: AppColors.white,
                      numberStyle: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                      labelStyle: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.25),
                    ),
                    color: AppColors.white.withValues(alpha: 0.08),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white.withValues(alpha: 0.2),
                        ),
                        child: const Icon(
                          Icons.self_improvement,
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
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
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
          ],
        ),
      ),
    );
  }

  Color _getDefaultStatusShadowColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return const Color(0xFF9575CD).withValues(alpha: 0.32);
    } else {
      return colors.primaryWithAlpha(0.18);
    }
  }

  Widget _buildGlowCircle({
    required double size,
    double? top,
    double? left,
    double? right,
    double? bottom,
    required Color color,
    double opacity = 0.2,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: opacity), AppColors.transparent],
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.white.withValues(alpha: 0.15),
            ),
            child: Icon(icon, size: 16, color: AppColors.white),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.25,
            ),
          ),
        ],
      ),
    );
  }
}
