import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/components/period_grid_view.dart';
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
        final sortedPeriods = periodProvider.sortedPeriods;

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
                child: _buildContentLayout(context, sortedPeriods, constraints),
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
              child: PeriodGridView(periods: periods),
            ),
          ],
        )
        : Column(
          // 竖屏布局 - 上下排列
          children: [
            PeriodTableCalendar(periods: periods), // 日历在上方
            Expanded(
              // 列表占据剩余空间
              child: PeriodGridView(periods: periods),
            ),
          ],
        );
  }
}
