import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/period.dart';
import 'package:test_1/period_provider.dart';
import 'package:test_1/components/stats_overview_card.dart';
import 'package:test_1/components/calendar_view_card.dart';
import 'package:test_1/components/record_list_card.dart';
import 'package:test_1/theme/app_colors.dart';

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
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors.appBarGradient,
          ),
        ),
      ),
      title: Text(
        '生理期统计',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: _getTitleColor(colors, isDark),
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getIconBackgroundColor(colors, isDark),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back,
            color: _getIconColor(colors, isDark),
            size: 20,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// 获取图标背景颜色
  Color _getIconBackgroundColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return colors.onPrimaryContainer.withValues(alpha: 0.2);
    } else {
      return AppColors.white.withValues(alpha: 0.2);
    }
  }

  /// 获取图标颜色
  Color _getIconColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return colors.onPrimaryContainer;
    } else {
      return AppColors.white;
    }
  }

  /// 获取标题颜色
  Color _getTitleColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return colors.onPrimaryContainer;
    } else {
      return AppColors.white;
    }
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
