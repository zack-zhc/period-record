import 'package:flutter/material.dart';
import 'package:period_record/models/period_status_logic.dart';
import 'package:provider/provider.dart';
import 'package:period_record/period.dart';
import 'package:period_record/period_provider.dart';
import 'package:period_record/components/stats_overview_card.dart';
import 'package:period_record/components/record_list_card.dart';
import 'package:period_record/theme/app_colors.dart';

/// 空状态组件 - 符合应用整体设计风格
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      // margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors.noPeriodGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 60,
              color: _getNoPeriodIconColor(colors, isDark),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '暂无生理期记录',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '添加您的第一条生理期记录，开始跟踪和统计',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceWithAlpha(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Color _getNoPeriodIconColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return colors.onPrimaryContainer;
    } else {
      return colors.primary;
    }
  }
}

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
          // backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(title: Text('生理期统计')),
          body: _buildBody(context, sortedPeriods),
          floatingActionButton: _buildFloatingActionButton(
            context,
            periodProvider,
          ),
        );
      },
    );
  }

  /// 构建页面主体内容
  Widget _buildBody(BuildContext context, List<Period> periods) {
    return SafeArea(
      child:
          periods.isNotEmpty
              ? CustomScrollView(
                slivers: [
                  // 统计概览卡片
                  StatsOverviewCard(periods: periods),

                  // 记录列表卡片
                  RecordListCard(periods: periods),
                ],
              )
              : const _EmptyState(),
    );
  }

  /// 构建浮动按钮
  Widget _buildFloatingActionButton(
    BuildContext context,
    PeriodProvider periodProvider,
  ) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lastPeriod = periodProvider.lastPeriod;
    final shouldShowAdd = PeriodStatusLogic.shouldShowAddButton(lastPeriod);

    // 根据Material 3规范，FAB按钮在深色模式下使用容器色，浅色模式下使用主色
    Color buttonBackgroundColor;
    Color buttonContentColor;

    if (shouldShowAdd) {
      // 开始记录按钮
      buttonBackgroundColor = isDark ? colors.primaryContainer : colors.primary;
      buttonContentColor =
          isDark ? colors.onPrimaryContainer : colors.onPrimary;
    } else {
      // 结束记录按钮
      buttonBackgroundColor = isDark ? colors.errorContainer : colors.error;
      buttonContentColor = isDark ? colors.onErrorContainer : colors.onError;
    }

    return FloatingActionButton.extended(
      onPressed: () => _showAddPeriodDialog(context),
      icon: const Icon(Icons.add),
      elevation: 6.0, // 使用标准阴影
      label: const Text('添加记录'),
      backgroundColor: buttonBackgroundColor,
      foregroundColor: buttonContentColor,
    );
  }
}
