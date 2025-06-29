import 'package:flutter/material.dart';
import 'package:test_1/period.dart';
import 'package:test_1/components/period_status_widgets.dart';
import 'package:test_1/models/period_status_logic.dart';

/// 生理期状态主内容区域
class PeriodStatusContent extends StatelessWidget {
  final Period? lastPeriod;

  const PeriodStatusContent({super.key, required this.lastPeriod});

  @override
  Widget build(BuildContext context) {
    final statusInfo = PeriodStatusLogic.calculateStatus(lastPeriod);

    switch (statusInfo.status) {
      case PeriodStatus.noPeriod:
        return const NoPeriodWidget();

      case PeriodStatus.startedToday:
        return PeriodStartedTodayWidget(title: statusInfo.title);

      case PeriodStatus.inProgress:
        return PeriodInProgressWidget(
          title: statusInfo.title,
          days: statusInfo.days,
        );

      case PeriodStatus.endedToday:
        return PeriodEndedWidget(title: statusInfo.title);

      case PeriodStatus.ended:
        return DefaultPeriodStatusWidget(
          title: statusInfo.title,
          days: statusInfo.days,
        );
    }
  }
}
