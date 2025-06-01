import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/period.dart';
import 'package:test_1/period_provider.dart';
import 'package:test_1/utils/date_util.dart';

class PeriodGridView extends StatelessWidget {
  final List<Period> periods;

  const PeriodGridView({super.key, required this.periods});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2列布局
        childAspectRatio: 1, // 调整卡片宽高比
        crossAxisSpacing: 8, // 列间距
        mainAxisSpacing: 8, // 行间距
      ),
      padding: const EdgeInsets.all(8),
      itemCount: periods.length,
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

    return Card(
      child: InkWell(
        onTap: () => onTap(context, period),
        onLongPress: () => onLongPress(context, period),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end, // 改为底部对齐
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '$days',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontSize: 48),
                  ),
                  if (days > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        ' 天',
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(fontSize: 16),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${DateUtil.formatDate(period.start!)} - ${DateUtil.formatDate(period.end!)}',
              ),
              // Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
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
    final title = '该周期还未结束';
    return Card(
      color: Theme.of(context).colorScheme.error,
      child: InkWell(
        onTap: () => onTap(context, period),
        onLongPress: () => onLongPress(context, period),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
              Text(
                '开始于：'
                '${DateUtil.formatDate(period.start!)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
            ],
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
      locale: Localizations.localeOf(context), // 确保使用当前语言环境
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
            title: const Text('要删除这个周期记录吗？'),
            content: const Text('这将永久删除该记录。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),

              TextButton(
                onPressed: () {
                  Provider.of<PeriodProvider>(
                    context,
                    listen: false,
                  ).deletePeriod(period.id);
                  Navigator.pop(context);
                },
                child: Text('删除'),
              ),
            ],
          ),
    );
  }

  Widget _buildPeriodCard(BuildContext context, Period period) {
    // var startDate = period.start?.toString().substring(0, 10);
    // var endDate = period.end?.toString().substring(0, 10);

    // var title = '周期： $startDate';
    // if (endDate != null) {
    //   title += ' - $endDate';
    // }

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
