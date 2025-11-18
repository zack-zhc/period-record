import 'package:flutter/material.dart';
import 'package:period_record/period.dart';
import 'package:period_record/utils/date_util.dart';

/// 统计概览卡片组件
class StatsOverviewCard extends StatelessWidget {
  final List<Period> periods;

  const StatsOverviewCard({super.key, required this.periods});

  @override
  Widget build(BuildContext context) {
    final completedPeriods = periods.where((p) => p.end != null).toList();
    final totalDays = completedPeriods.fold<int>(
      0,
      (sum, period) =>
          sum + DateUtil.calculateDurationDays(period.start!, period.end!),
    );
    final averageDays =
        completedPeriods.isNotEmpty
            ? (totalDays / completedPeriods.length).round()
            : 0;

    // 计算最长周期（用于第四个卡片）
    final longestDays =
        completedPeriods.isNotEmpty
            ? completedPeriods
                .map((p) => DateUtil.calculateDurationDays(p.start!, p.end!))
                .reduce((a, b) => a > b ? a : b)
            : 0;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 使用 2x2 网格显示四个纯色卡片，风格参考示例
    final tiles = [
      _buildColorTile(
        context,
        title: '总记录',
        value: '${periods.length}',
        background: colorScheme.primaryContainer,
        onBackground: colorScheme.onPrimaryContainer,
      ),
      _buildColorTile(
        context,
        title: '已完成',
        value: '${completedPeriods.length}',
        background: colorScheme.errorContainer,
        onBackground: colorScheme.onErrorContainer,
      ),
      _buildColorTile(
        context,
        title: '平均天数',
        value: '$averageDays',
        background: colorScheme.tertiaryContainer,
        onBackground: colorScheme.onTertiaryContainer,
      ),
      _buildColorTile(
        context,
        title: '最长周期',
        value: '$longestDays',
        background: colorScheme.secondaryContainer,
        onBackground: colorScheme.onSecondaryContainer,
      ),
    ];

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题（移除左侧图标，保持对齐与样式）
            Text(
              '统计概览',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              children: tiles,
            ),
          ],
        ),
      ),
    );
  }

  // 单个纯色卡片（标题 + 大数字 + 可选子文本）
  Widget _buildColorTile(
    BuildContext context, {
    required String title,
    required String value,
    required Color background,
    required Color onBackground,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(
              color: onBackground.withOpacity(0.95),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: textTheme.headlineMedium?.copyWith(
              color: onBackground,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          // 可选副文本（目前留空，占位）
          Text(
            '',
            style: textTheme.bodySmall?.copyWith(
              color: onBackground.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}
