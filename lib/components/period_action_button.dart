import 'package:flutter/material.dart';
import 'package:test_1/period.dart';
import 'package:test_1/period_provider.dart';
import 'package:test_1/models/period_status_logic.dart';

/// 生理期操作浮动按钮
class PeriodActionButton extends StatelessWidget {
  final PeriodProvider periodProvider;

  const PeriodActionButton({super.key, required this.periodProvider});

  @override
  Widget build(BuildContext context) {
    final lastPeriod = periodProvider.lastPeriod;
    final shouldShowAdd = PeriodStatusLogic.shouldShowAddButton(lastPeriod);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              shouldShowAdd
                  ? [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ]
                  : [
                    Theme.of(context).colorScheme.error,
                    Theme.of(context).colorScheme.error.withValues(alpha: 0.8),
                  ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (shouldShowAdd
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error)
                .withValues(alpha: 0.3),
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
          color: Colors.white,
          size: 28,
        ),
        label: Text(
          shouldShowAdd ? '开始记录' : '结束本次记录',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
