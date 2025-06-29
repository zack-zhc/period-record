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

    return FloatingActionButton(
      onPressed: () => _handleAction(context),
      child: Icon(shouldShowAdd ? Icons.add : Icons.check),
    );
  }

  /// 处理按钮点击事件
  void _handleAction(BuildContext context) {
    final lastPeriod = periodProvider.lastPeriod;

    if (PeriodStatusLogic.shouldShowAddButton(lastPeriod)) {
      // 添加新的生理期记录
      periodProvider.addPeriod(DateTime.now(), null);
    } else if (PeriodStatusLogic.shouldShowEndButton(lastPeriod)) {
      // 结束当前生理期
      final newPeriod = Period.initialize(
        start: lastPeriod!.start!,
        end: DateTime.now(),
        id: lastPeriod.id,
      );
      periodProvider.editPeriod(newPeriod);
    }
  }
}
