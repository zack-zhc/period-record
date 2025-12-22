import 'package:flutter/material.dart';
import 'package:period_record/models/period_status_logic.dart';
import 'package:period_record/period.dart';

/// 重新设计的生理期状态组件
/// 采用 Material Design 3 设计规范，提供更好的视觉层次和用户体验
class DefaultPeriodStatusWidget extends StatefulWidget {
  final String title;
  final int days;
  final List<Period> periods;

  const DefaultPeriodStatusWidget({
    super.key,
    required this.title,
    required this.days,
    required this.periods,
  });

  @override
  State<DefaultPeriodStatusWidget> createState() =>
      _DefaultPeriodStatusWidgetState();
}

class _DefaultPeriodStatusWidgetState extends State<DefaultPeriodStatusWidget> {
  @override
  Widget build(BuildContext context) {
    final supportMessage = PeriodStatusLogic.supportMessage(
      PeriodStatus.ended,
      widget.days,
    );
    final careTips = PeriodStatusLogic.careTips(
      PeriodStatus.ended,
      widget.days,
    );

    return _buildMainCard(context, supportMessage, careTips);
  }

  Widget _buildMainCard(
    BuildContext context,
    String supportMessage,
    List<CareTip> careTips,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            const SizedBox(height: 16),
            _buildProgressIndicator(context),
            const SizedBox(height: 20),
            _buildSupportMessage(context, supportMessage),
            const SizedBox(height: 24),
            _buildCareTipsSection(context, careTips),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧图标区域
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.self_improvement_rounded,
            color: colors.onPrimaryContainer,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        // 右侧内容区域
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: textTheme.titleLarge?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '生理期结束已${widget.days}天，身体正在恢复活力',
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 基于历史数据计算平均周期长度
    final averageCycleLength = PeriodStatusLogic.calculateAverageCycleLength(
      widget.periods,
    );
    final nextPeriodPrediction =
        PeriodStatusLogic.calculateNextPeriodPrediction(widget.periods);

    // 如果无法预测，显示默认值
    final cycleLength = averageCycleLength ?? 28;
    final daysUntilNext = nextPeriodPrediction ?? (cycleLength - widget.days);

    // 计算进度，确保不超出100%
    final progress = widget.days / cycleLength;
    final safeProgress = progress > 1.0 ? 1.0 : progress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '周期进度',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(safeProgress * 100).toInt()}%',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: safeProgress,
          backgroundColor: colors.surfaceVariant,
          color: colors.primary,
          borderRadius: BorderRadius.circular(4),
          minHeight: 6,
        ),
        const SizedBox(height: 4),
        Text(
          _buildProgressText(
            daysUntilNext,
            cycleLength,
            nextPeriodPrediction != null,
          ),
          style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }

  /// 构建进度文本
  String _buildProgressText(
    int daysUntilNext,
    int cycleLength,
    bool hasPrediction,
  ) {
    if (daysUntilNext <= 0) {
      return '预计生理期即将开始';
    } else if (hasPrediction) {
      return '基于历史数据，距离下次生理期还有$daysUntilNext天';
    } else {
      return '基于$cycleLength天周期，距离下次生理期还有$daysUntilNext天';
    }
  }

  Widget _buildSupportMessage(BuildContext context, String message) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.secondaryContainer.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            color: colors.secondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurface,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareTipsSection(BuildContext context, List<CareTip> careTips) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline_rounded,
              color: colors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '今日关怀建议',
              style: textTheme.titleMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...careTips.asMap().entries.map((entry) {
          final index = entry.key;
          final tip = entry.value;

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == careTips.length - 1 ? 0 : 12,
            ),
            child: _buildCareTipItem(context, tip),
          );
        }),
      ],
    );
  }

  Widget _buildCareTipItem(BuildContext context, CareTip tip) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => _showCareTipDialog(context, tip),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surfaceVariant.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(tip.icon, color: colors.primary, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip.label,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tip.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: colors.outline,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCareTipDialog(BuildContext context, CareTip tip) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题区域
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(tip.icon, color: colors.primary, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        tip.label,
                        style: textTheme.headlineSmall?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // 详细描述
                Text(
                  tip.description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                // 操作按钮
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '好的，我知道了',
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
