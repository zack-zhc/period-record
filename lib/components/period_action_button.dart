import 'package:flutter/material.dart';
import 'package:period_record/period.dart';
import 'package:period_record/period_provider.dart';
import 'package:period_record/models/period_status_logic.dart';
import 'package:period_record/theme/app_colors.dart';

/// 生理期操作浮动按钮
class PeriodActionButton extends StatelessWidget {
  final PeriodProvider periodProvider;

  const PeriodActionButton({super.key, required this.periodProvider});

  @override
  Widget build(BuildContext context) {
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
      onPressed: () => _handleAction(context),
      backgroundColor: buttonBackgroundColor,
      foregroundColor: buttonContentColor,
      elevation: 6.0, // 使用标准阴影
      icon: Icon(shouldShowAdd ? Icons.add : Icons.check, size: 24),
      label: Text(
        shouldShowAdd ? '开始记录' : '结束本次记录',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// 处理按钮点击事件
  void _handleAction(BuildContext context) {
    final lastPeriod = periodProvider.lastPeriod;

    if (PeriodStatusLogic.shouldShowAddButton(lastPeriod)) {
      // 添加新的生理期记录
      periodProvider.addPeriod(DateTime.now(), null);
      _showSnackBar(context, '生理期已开始记录');
    } else if (PeriodStatusLogic.shouldShowEndButton(lastPeriod)) {
      // 结束当前生理期
      final newPeriod = Period.initialize(
        start: lastPeriod!.start!,
        end: DateTime.now(),
        id: lastPeriod.id,
      );
      periodProvider.editPeriod(newPeriod);
      _showSnackBar(context, '生理期已结束记录');
    }
  }

  /// 显示操作提示
  void _showSnackBar(BuildContext context, String message) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.white, size: 20),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: _getSnackBarColor(colors, isDark),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// 获取SnackBar背景颜色
  Color _getSnackBarColor(ThemeColors colors, bool isDark) {
    // 根据Material 3规范，在深色模式下使用容器色，确保视觉一致性
    return isDark ? colors.primaryContainer : colors.primary;
  }
}
