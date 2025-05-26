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
}
