import 'package:flutter/material.dart';
import 'package:period_record/period.dart';
import 'package:period_record/utils/date_util.dart';

/// 生理期状态枚举
enum PeriodStatus { noPeriod, startedToday, inProgress, endedToday, ended }

class CareTip {
  final IconData icon;
  final String label;
  final String description;
  final String moreDetail;

  const CareTip(
    this.icon,
    this.label, [
    this.description = '',
    this.moreDetail = '',
  ]);
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
          title: '恢复活力期',
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

  /// 计算基于历史数据的平均周期长度
  /// 返回null表示无法计算（如历史数据不足）
  static int? calculateAverageCycleLength(List<Period> periods) {
    // 只考虑已完成的周期
    final finishedPeriods =
        periods.where((p) => p.start != null && p.end != null).toList();
    if (finishedPeriods.length < 2) return null; // 至少需要2个周期才能计算

    // 按开始时间排序
    finishedPeriods.sort((a, b) => a.start!.compareTo(b.start!));

    // 计算所有周期间隔
    List<int> intervals = [];
    for (int i = 1; i < finishedPeriods.length; i++) {
      final prev = finishedPeriods[i - 1];
      final curr = finishedPeriods[i];
      final interval = curr.start!.difference(prev.start!).inDays;
      if (interval > 0) {
        intervals.add(interval);
      }
    }

    if (intervals.isEmpty) return null;

    // 返回平均周期长度
    return (intervals.reduce((a, b) => a + b) / intervals.length).round();
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
          CareTip(
            Icons.bedtime,
            '多休息',
            '保证每天7-8小时的充足睡眠，避免熬夜。可以尝试午休20-30分钟来补充体力。',
          ),
          CareTip(
            Icons.local_cafe,
            '暖热饮',
            '饮用温热的红糖姜茶、桂圆红枣茶等，避免冷饮和咖啡因。温热饮品有助于缓解腹部不适。',
          ),
          CareTip(
            Icons.hot_tub,
            '热敷腹部',
            '使用热水袋或暖宝宝在腹部热敷15-20分钟，温度控制在40-45℃。热敷能有效缓解痛经。',
          ),
          CareTip(Icons.favorite, '温暖陪伴', '与家人朋友多交流，获得情感支持。温暖的陪伴能减轻经期的不适感。'),
        ];
      case PeriodStatus.inProgress:
        return _inProgressCareTips(days);
      case PeriodStatus.endedToday:
        return const [
          CareTip(
            Icons.emoji_emotions,
            '放松心情',
            '经期结束后情绪容易波动，可以听听音乐、看看书，或者进行冥想练习来放松心情。',
          ),
          CareTip(
            Icons.self_improvement,
            '轻柔拉伸',
            '进行一些轻柔的瑜伽拉伸动作，如猫式、婴儿式，帮助身体恢复柔韧性。',
          ),
          CareTip(Icons.spa, '舒缓护理', '可以泡个温水澡，加入几滴薰衣草精油，帮助身心放松和恢复。'),
          CareTip(Icons.local_florist, '香薰放松', '使用薰衣草、洋甘菊等舒缓香薰，帮助改善睡眠质量和情绪状态。'),
        ];
      case PeriodStatus.ended:
        return const [
          CareTip(
            Icons.directions_walk,
            '保持运动',
            '每天坚持30分钟的有氧运动，如快走、慢跑、游泳等，有助于提高新陈代谢。',
            '运动能促进盆腔血液循环，改善卵巢功能，调节激素平衡。有氧运动可提高内啡肽水平，缓解经期不适症状。规律运动还能增强盆底肌肉力量，预防妇科疾病。建议选择中等强度运动，避免剧烈运动导致身体过度疲劳。',
          ),
          CareTip(
            Icons.restaurant,
            '营养均衡',
            '多摄入富含铁质、蛋白质和维生素的食物，如瘦肉、豆类、绿叶蔬菜等。',
            '生理期后身体需要补充铁质来恢复血红蛋白水平。蛋白质是组织修复的基础，维生素B族和维生素C有助于铁质吸收。钙和镁能缓解经前紧张症状。建议增加深色蔬菜、坚果、全谷物摄入，避免高糖、高脂食物影响激素平衡。',
          ),
          CareTip(
            Icons.nightlight_round,
            '规律作息',
            '保持规律的睡眠时间，每晚10点前入睡，保证7-8小时的优质睡眠。',
            '充足睡眠对调节下丘脑-垂体-卵巢轴功能至关重要。深度睡眠时身体分泌生长激素，促进组织修复。规律的生物钟有助于稳定雌激素和孕激素水平，预防月经紊乱。睡眠不足会增加皮质醇水平，影响排卵和月经周期。',
          ),
          CareTip(
            Icons.water_drop,
            '补充水分',
            '每天饮用至少8杯水，可以适量饮用温热的柠檬水或花草茶。',
            '充足水分能维持血液容量，促进代谢废物排出，缓解经期水肿。水分不足会导致血液黏稠度增加，影响卵巢血液供应。温热的饮品能促进盆腔血液循环，缓解经期不适。避免含咖啡因饮料，因其可能加重经前紧张症状。',
          ),
        ];
      case PeriodStatus.noPeriod:
        return const [
          CareTip(
            Icons.edit_calendar,
            '记录周期',
            '定期记录月经周期，了解自己的身体规律，有助于及时发现异常情况。',
          ),
          CareTip(Icons.lightbulb, '了解身体', '学习月经周期的相关知识，了解不同阶段的身体变化和应对方法。'),
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
        CareTip(Icons.bedtime, '多休息', '经期前2天身体最需要休息，避免剧烈运动，保证充足睡眠。'),
        CareTip(Icons.local_cafe, '暖热饮', '饮用温热的姜茶、红糖水等，避免咖啡因和冷饮，缓解腹部不适。'),
        CareTip(Icons.hot_tub, '热敷腹部', '使用热水袋在腹部热敷15-20分钟，温度适宜，缓解痛经症状。'),
        CareTip(Icons.music_note, '舒缓音乐', '听一些轻柔的音乐，帮助放松心情，减轻经期紧张感。'),
      ];
    } else if (days <= 4) {
      return const [
        CareTip(Icons.local_drink, '补充水分', '经期第3-4天需要多补充水分，避免脱水，促进新陈代谢。'),
        CareTip(Icons.self_improvement, '深呼吸', '进行深呼吸练习，每次5-10分钟，帮助缓解经期焦虑和不适。'),
        CareTip(Icons.spa, '轻柔拉伸', '进行轻柔的瑜伽拉伸，避免剧烈运动，帮助缓解肌肉紧张。'),
        CareTip(Icons.health_and_safety, '贴心呵护', '注意个人卫生，选择舒适的卫生用品，保持清洁干燥。'),
      ];
    }
    return const [
      CareTip(Icons.emoji_emotions, '保持好心情', '经期后期情绪容易波动，保持积极心态，避免情绪波动影响身体。'),
      CareTip(Icons.air, '舒展舒气', '进行深呼吸和舒展运动，帮助身体放松，促进血液循环。'),
      CareTip(Icons.directions_walk, '缓步散心', '适当进行缓步散步，促进血液循环，缓解经期不适。'),
      CareTip(Icons.self_improvement, '柔和伸展', '进行柔和的伸展运动，帮助身体恢复，避免剧烈运动。'),
    ];
  }
}

extension PeriodStatusPredictionExt on PeriodStatus {
  bool get isShowPrediction =>
      this == PeriodStatus.ended ||
      this == PeriodStatus.endedToday ||
      this == PeriodStatus.noPeriod;
}
