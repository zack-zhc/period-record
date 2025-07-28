import 'package:flutter/material.dart';

class DateUtil {
  /// 判断日期是否在开始和结束日期之间（包含边界）
  ///
  /// [day] 要判断的日期
  /// [start] 开始日期（可选）
  /// [end] 结束日期（可选）
  /// 返回true如果day在start和end之间（包含边界）
  /// 当start为null时，只判断day是否在end之前
  /// 当end为null时，只判断day是否在start之后
  /// 当start和end都为null时，返回false
  static bool isDayBetween(DateTime day, DateTime? start, DateTime? end) {
    // 转换为本地时区
    final localDay = day.toLocal();

    // 处理start和end都为null的情况
    if (start == null && end == null) return false;

    // 处理只有start的情况
    if (start != null && end == null) {
      final localStart = start.toLocal();
      return localDay.isAfter(localStart) ||
          DateUtils.isSameDay(localDay, localStart);
    }

    // 处理只有end的情况
    if (start == null && end != null) {
      final localEnd = end.toLocal();
      return localDay.isBefore(localEnd) ||
          DateUtils.isSameDay(localDay, localEnd);
    }

    // 处理start和end都存在的情况
    final localStart = start!.toLocal();
    final localEnd = end!.toLocal();
    return (localDay.isAfter(localStart) ||
            DateUtils.isSameDay(localDay, localStart)) &&
        (localDay.isBefore(localEnd) ||
            DateUtils.isSameDay(localDay, localEnd));
  }

  /// 判断两个日期是否为同一天
  ///
  /// [day] 第一个日期
  /// [target] 第二个日期（可选）
  /// 返回true如果两个日期在同一天，或者target为null时返回false
  static bool isSameDay(DateTime day, DateTime? target) {
    if (target == null) return false;
    return DateUtils.isSameDay(day.toLocal(), target.toLocal());
  }

  /// 格式化日期为"YYYY.M.D"格式的字符串
  ///
  /// [date] 要格式化的日期
  /// 返回格式化的字符串，例如"2025.3.20"
  static String formatDate(DateTime date) {
    final localDate = date.toLocal();
    return '${localDate.year}.${localDate.month}.${localDate.day}';
  }

  /// 计算两个日期之间的持续天数
  ///
  /// [start] 开始日期
  /// [end] 结束日期
  /// 返回持续天数（包含开始和结束日）
  static int calculateDurationDays(DateTime start, DateTime end) {
    final localStart = start.toLocal();
    final localEnd = end.toLocal();
    return localEnd.difference(localStart).inDays + 1;
  }

  /// 计算从开始日期到今天的天数
  ///
  /// [startDate] 开始日期
  /// [today] 今天的日期（可选，默认为当前日期）
  /// 返回从开始日期到今天的天数（第一天算作第1天）
  static int calculateDaysFromStart(DateTime startDate, [DateTime? today]) {
    final localStartDate = startDate.toLocal();
    final localToday = (today ?? DateTime.now()).toLocal();
    return localToday.difference(localStartDate).inDays + 1;
  }

  /// 计算从开始日期到今天的天数（用于已结束的周期）
  ///
  /// [startDate] 开始日期
  /// [today] 今天的日期（可选，默认为当前日期）
  /// 返回从开始日期到今天的天数
  static int calculateDaysSinceStart(DateTime startDate, [DateTime? today]) {
    final localStartDate = startDate.toLocal();
    final localToday = (today ?? DateTime.now()).toLocal();
    return localStartDate.difference(localToday).inDays * -1;
  }

  /// 测试天数计算是否正确
  /// 用于验证计算逻辑
  static void testDurationCalculation() {
    // 测试用例1：同一天
    final sameDay = DateTime(2024, 3, 15);
    final result1 = calculateDurationDays(sameDay, sameDay);
    // print('同一天测试: $result1 天 (期望: 1天)');

    // 测试用例2：相邻两天
    final day1 = DateTime(2024, 3, 15);
    final day2 = DateTime(2024, 3, 16);
    final result2 = calculateDurationDays(day1, day2);
    // print('相邻两天测试: $result2 天 (期望: 2天)');

    // 测试用例3：跨多天
    final start = DateTime(2024, 3, 15);
    final end = DateTime(2024, 3, 17);
    final result3 = calculateDurationDays(start, end);
    // print('跨多天测试: $result3 天 (期望: 3天)');

    // 测试用例4：跨月
    final start2 = DateTime(2024, 3, 30);
    final end2 = DateTime(2024, 4, 2);
    final result4 = calculateDurationDays(start2, end2);
    // print('跨月测试: $result4 天 (期望: 4天)');
  }
}
