import 'package:flutter/material.dart';
import 'package:period_record/models/period_status_logic.dart';
import 'package:period_record/theme/app_colors.dart';

/// 默认状态组件（非生理期、非预测期等常规状态）
/// 采用 Material 3 Expressive 设计风格
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
    final supportMessage = PeriodStatusLogic.supportMessage(
      PeriodStatus.ended,
      days,
    );
    final careTips = PeriodStatusLogic.careTips(PeriodStatus.ended, days);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),
          _buildSupportCard(context, supportMessage),
          const SizedBox(height: 32),
          _buildCareSection(context, careTips),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.spa_rounded,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildDaysDisplay(context),
                ],
              ),

              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '持续记录与关怀，让身体保持平衡。',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        // const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildDaysDisplay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            '$days',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '天',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.self_improvement_rounded,
            color: AppColors.white,
            size: 24,
          ),
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
          '日常建议',
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
