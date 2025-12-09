import 'package:flutter/material.dart';
import 'package:period_record/models/period_status_logic.dart';
import 'package:period_record/theme/app_colors.dart';

/// 生理期今天开始组件（已从 `period_status_widgets.dart` 抽离）
/// 采用 Material 3 Expressive 设计风格
class PeriodStartedTodayWidget extends StatelessWidget {
  final String title;

  const PeriodStartedTodayWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final supportMessage = PeriodStatusLogic.supportMessage(
      PeriodStatus.startedToday,
      0,
    );
    final careTips = PeriodStatusLogic.careTips(PeriodStatus.startedToday, 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroHeader(context),
          const SizedBox(height: 32),
          _buildSupportCard(context, supportMessage, isDark),
          const SizedBox(height: 32),
          _buildCareSection(context, careTips),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite_rounded,
            color: AppColors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: textTheme.headlineMedium?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '迎接新的周期，放慢节奏，好好照顾自己。',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.white.withValues(alpha: 0.9),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSupportCard(BuildContext context, String message, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: isDark ? 0.1 : 0.15),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.white, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.white,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareSection(BuildContext context, List<CareTip> careTips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '温柔提示',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 12.0;
            final maxWidth = constraints.maxWidth;
            // 使用两列布局
            final tileWidth = (maxWidth - spacing) / 2;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
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
    );
  }

  Widget _buildCareChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.white.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: AppColors.white),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
