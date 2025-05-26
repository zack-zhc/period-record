import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/period.dart';
import 'package:test_1/period_provider.dart';
import 'package:test_1/components/period_table_calendar.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  Future<void> _showAddPeriodDialog(BuildContext context) async {
    final dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(hours: 1)),
      ),
      locale: Localizations.localeOf(context), // 确保使用当前语言环境
    );

    if (dateRange != null && context.mounted) {
      await Provider.of<PeriodProvider>(
        context,
        listen: false,
      ).addPeriod(dateRange.start, dateRange.end);
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

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              '生理期记录统计',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () => _showAddPeriodDialog(context),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SafeArea(
                child: _buildContentLayout(context, periods, constraints),
              );
            },
          ),
        );
      },
    );
  }

  /// 构建页面内容布局
  ///
  /// [context] 构建上下文
  /// [periods] 生理期记录列表
  /// [constraints] 布局约束条件
  Widget _buildContentLayout(
    BuildContext context,
    List<Period> periods,
    BoxConstraints constraints,
  ) {
    // 检查是否有生理期记录
    if (periods.isEmpty) {
      return Center(
        child: Text('没有生理期记录', style: Theme.of(context).textTheme.bodyLarge),
      );
    }

    // 判断当前是否为横屏模式
    final isLandscape = constraints.maxWidth > constraints.maxHeight;

    // 根据屏幕方向返回不同的布局
    return isLandscape
        ? Row(
          // 横屏布局 - 左右排列
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.5, // 日历占50%宽度
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight, // 限制最大高度为屏幕高度
                ),
                child: SingleChildScrollView(
                  child: PeriodTableCalendar(periods: periods),
                ),
              ),
            ),
            Expanded(
              // 列表占据剩余空间
              child: PeriodListView(periods: periods),
            ),
          ],
        )
        : Column(
          // 竖屏布局 - 上下排列
          children: [
            PeriodTableCalendar(periods: periods), // 日历在上方
            Expanded(
              // 列表占据剩余空间
              child: PeriodListView(periods: periods),
            ),
          ],
        );
  }
}

// 列表组件
class PeriodListView extends StatelessWidget {
  final List<Period> periods;

  const PeriodListView({super.key, required this.periods});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: periods.length,
      itemBuilder: (context, index) {
        final period = periods[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _buildPeriodCard(context, period),
        );
      },
    );
  }

  Widget _buildPeriodCard(BuildContext context, Period period) {
    var startDate = period.start?.toString().substring(0, 10);
    var endDate = period.end?.toString().substring(0, 10);

    var title = '周期： $startDate';
    if (endDate != null) {
      title += ' - $endDate';
    }

    var days = 0;
    if (period.start != null && period.end != null) {
      // 转换为本地时区后再计算天数差
      final localStart = period.start!.toLocal();
      final localEnd = period.end!.toLocal();
      days = localEnd.difference(localStart).inDays + 1;
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

    return Card(
      child: InkWell(
        onTap: () => showEditDialog(context, period),
        onLongPress: () => showDeleteDialog(context, period),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
