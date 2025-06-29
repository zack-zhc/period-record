import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/period.dart';
import 'package:test_1/period_provider.dart';
import 'package:test_1/components/stats_overview_card.dart';
import 'package:test_1/components/calendar_view_card.dart';
import 'package:test_1/components/record_list_card.dart';

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
      locale: Localizations.localeOf(context),
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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final sortedPeriods = periodProvider.sortedPeriods;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: _buildModernAppBar(context),
          body: _buildBody(context, sortedPeriods),
          floatingActionButton: _buildFloatingActionButton(context),
        );
      },
    );
  }

  /// 构建现代化的AppBar
  PreferredSizeWidget _buildModernAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      title: Text(
        '生理期统计',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  /// 构建页面主体内容
  Widget _buildBody(BuildContext context, List<Period> periods) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // 统计概览卡片
          if (periods.isNotEmpty) StatsOverviewCard(periods: periods),

          // 日历视图卡片
          CalendarViewCard(periods: periods),

          // 记录列表卡片
          RecordListCard(periods: periods),

          // 添加底部间距，避免FloatingActionButton遮挡内容
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  /// 构建浮动按钮
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddPeriodDialog(context),
      icon: const Icon(Icons.add),
      label: const Text('添加记录'),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
    );
  }
}
