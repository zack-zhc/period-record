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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getButtonGradient(colors, isDark, shouldShowAdd),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getButtonShadowColor(colors, isDark, shouldShowAdd),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => _handleAction(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: Icon(
          shouldShowAdd ? Icons.add : Icons.check,
          color: _getButtonIconColor(colors, isDark, shouldShowAdd),
          size: 28,
        ),
        label: Text(
          shouldShowAdd ? '开始记录' : '结束本次记录',
          style: TextStyle(
            color: _getButtonTextColor(colors, isDark, shouldShowAdd),
            fontWeight: FontWeight.bold,
          ),
        ),
        extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  /// 获取按钮渐变颜色
  List<Color> _getButtonGradient(
    ThemeColors colors,
    bool isDark,
    bool shouldShowAdd,
  ) {
    if (shouldShowAdd) {
      // 开始记录按钮
      return colors.addButtonGradient;
    } else {
      // 结束记录按钮
      return colors.endButtonGradient;
    }
  }

  /// 获取按钮阴影颜色
  Color _getButtonShadowColor(
    ThemeColors colors,
    bool isDark,
    bool shouldShowAdd,
  ) {
    if (shouldShowAdd) {
      // 开始记录按钮
      if (isDark) {
        return const Color(0xFFE91E63).withValues(alpha: 0.4);
      } else {
        return colors.primaryWithAlpha(0.3);
      }
    } else {
      // 结束记录按钮
      if (isDark) {
        return const Color(0xFF4CAF50).withValues(alpha: 0.4);
      } else {
        return colors.errorWithAlpha(0.3);
      }
    }
  }

  /// 获取按钮图标颜色
  Color _getButtonIconColor(
    ThemeColors colors,
    bool isDark,
    bool shouldShowAdd,
  ) {
    return AppColors.white;
  }

  /// 获取按钮文字颜色
  Color _getButtonTextColor(
    ThemeColors colors,
    bool isDark,
    bool shouldShowAdd,
  ) {
    return AppColors.white;
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
    if (isDark) {
      return const Color(0xFFE91E63); // 粉色
    } else {
      return colors.primary;
    }
  }
}
