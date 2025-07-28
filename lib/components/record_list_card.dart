import 'package:flutter/material.dart';
import 'package:period_record/period.dart';
import 'package:period_record/components/period_grid_view.dart';

/// 记录列表卡片组件
class RecordListCard extends StatelessWidget {
  final List<Period> periods;

  const RecordListCard({super.key, required this.periods});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PeriodGridView(periods: periods),
          ),
        ),
      ),
    );
  }
}
