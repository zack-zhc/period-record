import 'package:flutter/material.dart';
import 'package:period_record/period.dart';
import 'package:period_record/utils/date_util.dart';

/// 生理期状态枚举
enum PeriodStatus { noPeriod, startedToday, inProgress, endedToday, ended }

class CareTip {
  final IconData icon;
  final String label;

  const CareTip(this.icon, this.label);
}

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
        final days = DateUtil.calculateDaysFromStart(startDate, today);
        return PeriodStatusInfo(
          status: PeriodStatus.inProgress,
          title: '生理期进行中',
          days: days,
        );
      }
    } else {
      // 生理期已结束
      final days = DateUtil.calculateDaysSinceStart(lastPeriod.start!, today);

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
    return DateUtil.isSameDay(date1, date2);
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

  static String supportMessage(PeriodStatus status, int days) {
    switch (status) {
      case PeriodStatus.startedToday:
        return '今天刚刚开始，经期的第一天，多聆听身体的节奏。';
      case PeriodStatus.inProgress:
        return _inProgressMessage(days);
      case PeriodStatus.endedToday:
        return '今天顺利结束，给自己一点奖励，保持轻松。';
      case PeriodStatus.ended:
        return '距离上次生理期已经 $days 天，保持平衡的作息很重要。';
      case PeriodStatus.noPeriod:
        return '开始记录与关怀，让自己对身体更有掌控感。';
    }
  }

  static List<CareTip> careTips(PeriodStatus status, int days) {
    switch (status) {
      case PeriodStatus.startedToday:
        return const [
          CareTip(Icons.bedtime, '多休息'),
          CareTip(Icons.local_cafe, '暖热饮'),
          CareTip(Icons.hot_tub, '热敷腹部'),
          CareTip(Icons.favorite, '温暖陪伴'),
        ];
      case PeriodStatus.inProgress:
        return _inProgressCareTips(days);
      case PeriodStatus.endedToday:
        return const [
          CareTip(Icons.emoji_emotions, '放松心情'),
          CareTip(Icons.self_improvement, '轻柔拉伸'),
          CareTip(Icons.spa, '舒缓护理'),
          CareTip(Icons.local_florist, '香薰放松'),
        ];
      case PeriodStatus.ended:
        return const [
          CareTip(Icons.directions_walk, '保持运动'),
          CareTip(Icons.restaurant, '营养均衡'),
          CareTip(Icons.nightlight_round, '规律作息'),
          CareTip(Icons.water_drop, '补充水分'),
        ];
      case PeriodStatus.noPeriod:
        return const [
          CareTip(Icons.edit_calendar, '记录周期'),
          CareTip(Icons.lightbulb, '了解身体'),
        ];
    }
  }

  static String _inProgressMessage(int days) {
    if (days <= 2) {
      return '刚开始的这几天最容易疲惫，放慢脚步、让身体好好休息。';
    } else if (days <= 4) {
      return '已经第 $days 天了，适度热敷和补水能帮助舒缓不适。';
    }
    return '已进入第 $days 天，快到尾声，保持轻松心情与柔和拉伸。';
  }

  static List<CareTip> _inProgressCareTips(int days) {
    if (days <= 2) {
      return const [
        CareTip(Icons.bedtime, '多休息'),
        CareTip(Icons.local_cafe, '暖热饮'),
        CareTip(Icons.hot_tub, '热敷腹部'),
        CareTip(Icons.music_note, '舒缓音乐'),
      ];
    } else if (days <= 4) {
      return const [
        CareTip(Icons.local_drink, '补充水分'),
        CareTip(Icons.self_improvement, '深呼吸'),
        CareTip(Icons.spa, '轻柔拉伸'),
        CareTip(Icons.health_and_safety, '贴心呵护'),
      ];
    }
    return const [
      CareTip(Icons.emoji_emotions, '保持好心情'),
      CareTip(Icons.air, '舒展舒气'),
      CareTip(Icons.directions_walk, '缓步散心'),
      CareTip(Icons.self_improvement, '柔和伸展'),
    ];
  }
}

extension PeriodStatusPredictionExt on PeriodStatus {
  bool get isShowPrediction =>
      this == PeriodStatus.ended ||
      this == PeriodStatus.endedToday ||
      this == PeriodStatus.noPeriod;
}
