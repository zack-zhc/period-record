import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/period.dart';
import 'package:test_1/period_provider.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  // 添加删除确认对话框方法
  void _showDeleteDialog(BuildContext context, Period period) {
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

  // 添加编辑对话框方法
  Future<void> _showEditDialog(BuildContext context, Period period) async {
    final dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange:
          period.start != null && period.end != null
              ? DateTimeRange(start: period.start!, end: period.end!)
              : null,
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

  @override
  Widget build(BuildContext context) {
    return Consumer<PeriodProvider>(
      builder: (context, periodProvider, child) {
        if (periodProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final periods = periodProvider.periods;

        if (periods.isEmpty) {
          return Center(
            child: Text(
              '没有生理期记录',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return ListView.builder(
          itemCount: periods.length,
          itemBuilder: (context, index) {
            final period = periods[index];
            // YY-MM-dd
            var startDate = period.start?.toString().substring(0, 10);
            var endDate = period.end?.toString().substring(0, 10);

            var title = '周期： $startDate';
            if (endDate != null) {
              title += ' - $endDate';
            }

            var days = 0;
            if (period.start != null && period.end != null) {
              days = period.end!.difference(period.start!).inDays;
            }
            var subtitle = '';
            if (endDate == null) {
              subtitle = '该周期未结束';
            } else {
              subtitle = '该周期持续了 $days 天';
              if (days == 0) {
                subtitle = '该周期开始结束于同一天';
              }
            }

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: InkWell(
                onTap: () => _showEditDialog(context, period),
                onLongPress: () => _showDeleteDialog(context, period),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
