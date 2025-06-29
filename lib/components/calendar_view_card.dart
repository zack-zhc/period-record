import 'package:flutter/material.dart';
import 'package:test_1/period.dart';
import 'package:test_1/components/period_table_calendar.dart';

/// 日历视图卡片组件
class CalendarViewCard extends StatelessWidget {
  final List<Period> periods;

  const CalendarViewCard({super.key, required this.periods});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '日历视图',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PeriodTableCalendar(periods: periods),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
