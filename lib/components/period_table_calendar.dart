import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test_1/period.dart';
import 'package:test_1/utils/date_util.dart';

class PeriodTableCalendar extends StatelessWidget {
  final List<Period> periods;

  const PeriodTableCalendar({super.key, required this.periods});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: Localizations.localeOf(context).languageCode,
      firstDay: DateTime(1900),
      lastDay: DateTime(2100),
      focusedDay: DateTime.now(),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle:
            Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ) ??
            const TextStyle(),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendTextStyle: TextStyle(color: Theme.of(context).colorScheme.error),
        holidayTextStyle: TextStyle(color: Theme.of(context).colorScheme.error),
        defaultTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        todayDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
        markerDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
      ),
      calendarFormat: CalendarFormat.month,
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      eventLoader: (day) => [],
      calendarBuilders: CalendarBuilders(
        rangeStartBuilder:
            (context, day, focusedDay) =>
                _buildDayCell(context, day, focusedDay),
        rangeEndBuilder:
            (context, day, focusedDay) =>
                _buildDayCell(context, day, focusedDay),
        rangeHighlightBuilder:
            (context, day, _) => _buildHighlight(context, day),
        defaultBuilder:
            (context, day, focusedDay) =>
                _buildDayCell(context, day, focusedDay),
      ),
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
  ) {
    final localDay = day.toLocal();
    bool isPeriodDay = false;
    bool isRangeStart = false;
    bool isRangeEnd = false;

    for (var period in periods) {
      if (period.start != null && period.end != null) {
        if (DateUtil.isDayBetween(localDay, period.start, period.end)) {
          isPeriodDay = true;
          if (DateUtil.isSameDay(localDay, period.start!)) {
            isRangeStart = true;
          }
          if (DateUtil.isSameDay(localDay, period.end!)) {
            isRangeEnd = true;
          }
        }
      }
    }

    return _buildCellContent(
      context,
      day,
      isPeriodDay: isPeriodDay,
      isRangeStart: isRangeStart,
      isRangeEnd: isRangeEnd,
    );
  }

  Widget? _buildHighlight(BuildContext context, DateTime day) {
    final localDay = day.toLocal();
    bool isPeriodDay = false;
    bool isRangeStart = false;
    bool isRangeEnd = false;

    for (var period in periods) {
      if (period.start != null && period.end != null) {
        if (DateUtil.isDayBetween(localDay, period.start, period.end)) {
          isPeriodDay = true;
          if (DateUtil.isSameDay(localDay, period.start!)) {
            isRangeStart = true;
          }
          if (DateUtil.isSameDay(localDay, period.end!)) {
            isRangeEnd = true;
          }
        }
      }
    }

    return isPeriodDay
        ? _buildCellContent(
          context,
          day,
          isPeriodDay: isPeriodDay,
          isRangeStart: isRangeStart,
          isRangeEnd: isRangeEnd,
          isHighlight: true,
        )
        : null;
  }

  Widget _buildCellContent(
    BuildContext context,
    DateTime day, {
    bool isPeriodDay = false,
    bool isRangeStart = false,
    bool isRangeEnd = false,
    bool isHighlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
      decoration: BoxDecoration(
        color:
            isHighlight
                ? Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.8)
                : null,
        borderRadius: BorderRadius.horizontal(
          left: isRangeStart ? const Radius.circular(16) : Radius.zero,
          right: isRangeEnd ? const Radius.circular(16) : Radius.zero,
        ),
      ),
      child: Center(
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color:
                isRangeStart || isRangeEnd
                    ? Theme.of(context).colorScheme.primary
                    : null,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${day.day}',
              style: TextStyle(
                color:
                    isPeriodDay
                        ? (isRangeStart || isRangeEnd
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onPrimaryContainer)
                        : null,
                fontWeight: isRangeStart || isRangeEnd ? FontWeight.bold : null,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
