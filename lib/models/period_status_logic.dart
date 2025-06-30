import 'package:test_1/period.dart';

/// 生理期状态枚举
enum PeriodStatus { noPeriod, startedToday, inProgress, endedToday, ended }

/// 生理期状态信息模型
class PeriodStatusInfo {
  final PeriodStatus status;
  final String title;
  final int days;

  const PeriodStatusInfo({
    required this.status,
    required this.title,
    required this.days,
  });
}

/// 生理期状态业务逻辑模型
class PeriodStatusLogic {
  /// 计算生理期状态信息
  static PeriodStatusInfo calculateStatus(Period? lastPeriod) {
    if (lastPeriod == null) {
      return const PeriodStatusInfo(
        status: PeriodStatus.noPeriod,
        title: '',
        days: 0,
      );
    }

    final today = DateTime.now();

    // 如果生理期还未结束
    if (lastPeriod.end == null) {
      final startDate = lastPeriod.start!;
      final isStartedToday = _isSameDay(startDate, today);

      if (isStartedToday) {
        return const PeriodStatusInfo(
          status: PeriodStatus.startedToday,
          title: '生理期今天刚开始',
          days: 0,
        );
      } else {
        final days = today.difference(startDate).inDays;
        return PeriodStatusInfo(
          status: PeriodStatus.inProgress,
          title: '生理期进行中',
          days: days,
        );
      }
    } else {
      // 生理期已结束
      final days = lastPeriod.start!.difference(today).inDays * -1;

      if (days == 0) {
        return const PeriodStatusInfo(
          status: PeriodStatus.endedToday,
          title: '上次生理期刚刚结束',
          days: 0,
        );
      } else {
        return PeriodStatusInfo(
          status: PeriodStatus.ended,
          title: '上一次生理期开始之后',
          days: days,
        );
      }
    }
  }

  /// 判断两个日期是否为同一天
  static bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// 判断是否应该显示添加按钮
  static bool shouldShowAddButton(Period? lastPeriod) {
    if (lastPeriod == null) return true;
    return lastPeriod.end != null;
  }

  /// 判断是否应该显示结束按钮
  static bool shouldShowEndButton(Period? lastPeriod) {
    return lastPeriod != null && lastPeriod.end == null;
  }

  /// 预测距离下次生理期还有多少天
  /// 返回null表示无法预测（如历史数据不足）
  static int? calculateNextPeriodPrediction(List<Period> periods) {
    // 只考虑已完成的周期，按开始时间升序排列
    final finished =
        periods.where((p) => p.start != null && p.end != null).toList();
    if (finished.length < 2) return null; // 至少需要2个周期
    finished.sort((a, b) => a.start!.compareTo(b.start!));

    // 计算所有周期间隔（本次start - 上次start）
    List<int> intervals = [];
    for (int i = 1; i < finished.length; i++) {
      final prev = finished[i - 1];
      final curr = finished[i];
      final interval = curr.start!.difference(prev.start!).inDays;
      if (interval > 0) {
        intervals.add(interval);
      }
    }
    if (intervals.isEmpty) return null;
    final avgInterval =
        (intervals.reduce((a, b) => a + b) / intervals.length).round();

    // 预测下次生理期开始日 = 最近一次start + 平均间隔
    final lastStart = finished.last.start!;
    final nextStart = lastStart.add(Duration(days: avgInterval));
    final today = DateTime.now();
    final daysLeft = nextStart.difference(today).inDays;
    return daysLeft >= 0 ? daysLeft : 0;
  }
}

extension PeriodStatusPredictionExt on PeriodStatus {
  bool get isShowPrediction =>
      this == PeriodStatus.ended ||
      this == PeriodStatus.endedToday ||
      this == PeriodStatus.noPeriod;
}
