import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test_1/period.dart';
import 'package:test_1/period_provider.dart';

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
              final isLandscape = constraints.maxWidth > constraints.maxHeight;

              return SafeArea(
                child:
                    periods.isEmpty
                        ? Center(
                          child: Text(
                            '没有生理期记录',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                        : isLandscape
                        ? Row(
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * 0.5,
                              child: PeriodCalendar(periods: periods),
                            ),
                            Expanded(child: PeriodListView(periods: periods)),
                          ],
                        )
                        : Column(
                          children: [
                            PeriodCalendar(periods: periods),
                            Expanded(child: PeriodListView(periods: periods)),
                          ],
                        ),
              );
            },
          ),
        );
      },
    );
  }
}

// 日历组件

class PeriodCalendar extends StatelessWidget {
  final List<Period> periods;

  const PeriodCalendar({super.key, required this.periods});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: constraints.maxHeight, // 限制最大高度
          ),
          child: SingleChildScrollView(
            // 添加滚动以防内容过多
            child: TableCalendar(
              locale: Localizations.localeOf(context).languageCode,
              firstDay: DateTime(1900),
              lastDay: DateTime(2100),
              focusedDay: DateTime.now(),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              eventLoader: (day) => [],
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final localDay = day.toLocal();

                  final period = periods.firstWhere(
                    (p) {
                      if (p.start == null || p.end == null) return false;
                      return (localDay.isAfter(p.start!) ||
                              DateUtils.isSameDay(localDay, p.start!)) &&
                          (localDay.isBefore(p.end!) ||
                              DateUtils.isSameDay(localDay, p.end!));
                    },
                    orElse:
                        () => Period.initialize(start: null, end: null, id: -1),
                  );
                  // print(period.start);
                  final isFirstDay =
                      period.start != null &&
                      DateUtils.isSameDay(localDay, period.start!);
                  final isLastDay =
                      period.end != null &&
                      DateUtils.isSameDay(localDay, period.end!);
                  final isPeriodDay =
                      period.start != null && period.end != null;

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isPeriodDay
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                      borderRadius: BorderRadius.horizontal(
                        left:
                            isFirstDay
                                ? const Radius.circular(16)
                                : Radius.zero,
                        right:
                            isLastDay ? const Radius.circular(16) : Radius.zero,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color:
                              isPeriodDay
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer
                                  : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
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
