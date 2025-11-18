import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:period_record/period.dart';
import 'package:period_record/period_provider.dart';
import 'package:period_record/utils/date_util.dart';

class PeriodGridView extends StatelessWidget {
  final List<Period> periods;

  const PeriodGridView({super.key, required this.periods});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 8,
      ),
      // padding: const EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(8),
      itemCount: periods.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final period = periods[index];
        return _buildPeriodCard(context, period);
      },
    );
  }

  Widget _buildPeriodCardWithEndDate(
    BuildContext context,
    Period period,
    Function(BuildContext context, Period period) onTap,
    Function(BuildContext context, Period period) onLongPress,
  ) {
    var days = 0;
    final localStart = period.start!.toLocal();
    final localEnd = period.end!.toLocal();
    days = DateUtil.calculateDurationDays(localStart, localEnd);

    final colorScheme = Theme.of(context).colorScheme;
    // 更紧凑的两列卡片布局：左侧显示开始/结束两行信息，右侧突出天数
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.surfaceVariant.withOpacity(0.95),
            colorScheme.surface.withOpacity(0.98),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onTap(context, period),
          onLongPress: () => onLongPress(context, period),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // 左侧：开始/结束 两行信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '开始',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.75),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateUtil.formatDate(period.start!),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '结束',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.75),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateUtil.formatDate(period.end!),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // 右侧：天数突出显示
                const SizedBox(width: 12),
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$days',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          '天',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimaryContainer.withOpacity(
                              0.95,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodCardWithoutEndDate(
    BuildContext context,
    Period period,
    Function(BuildContext context, Period period) onTap,
    Function(BuildContext context, Period period) onLongPress,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    // 紧凑两列样式：左侧为提示与开始日期，右侧为强调的进行中状态方块
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.error.withOpacity(0.12),
            colorScheme.errorContainer.withOpacity(0.98),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(width: 4, color: colorScheme.error)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onTap(context, period),
          onLongPress: () => onLongPress(context, period),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // 左侧信息：移除冗余标题，仅展示开始日期，允许换行完整显示
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '开始',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onErrorContainer.withOpacity(0.95),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateUtil.formatDate(period.start!),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),

                // 右侧进行中标识方块
                const SizedBox(width: 12),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 20,
                        color: colorScheme.onError,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '进行中',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onError,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 添加编辑对话框方法
  Future<void> showEditDialog(BuildContext context, Period period) async {
    final dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange:
          period.start != null && period.end != null
              ? DateTimeRange(start: period.start!, end: period.end!)
              : null,
      locale: Localizations.localeOf(context),
    );

    if (dateRange != null && context.mounted) {
      final updatedPeriod = Period.initialize(
        start: dateRange.start,
        end: dateRange.end,
        id: period.id,
      );
      await Provider.of<PeriodProvider>(
        context,
        listen: false,
      ).editPeriod(updatedPeriod);
    }
  }

  // 添加删除确认对话框方法
  void showDeleteDialog(BuildContext context, Period period) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('删除记录'),
            content: const Text('确定要删除这个生理期记录吗？此操作无法撤销。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () {
                  Provider.of<PeriodProvider>(
                    context,
                    listen: false,
                  ).deletePeriod(period.id);
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: const Text('删除'),
              ),
            ],
          ),
    );
  }

  Widget _buildPeriodCard(BuildContext context, Period period) {
    Widget card;

    if (period.start != null && period.end != null) {
      card = _buildPeriodCardWithEndDate(
        context,
        period,
        showEditDialog,
        showDeleteDialog,
      );
    } else {
      card = _buildPeriodCardWithoutEndDate(
        context,
        period,
        showEditDialog,
        showDeleteDialog,
      );
    }

    return card;
  }
}
