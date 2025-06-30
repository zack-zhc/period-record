import 'package:flutter/material.dart';
import 'package:test_1/period.dart';
import 'package:test_1/components/period_status_widgets.dart';
import 'package:test_1/models/period_status_logic.dart';
import 'package:provider/provider.dart';
import 'package:test_1/period_provider.dart';

/// 生理期状态主内容区域
class PeriodStatusContent extends StatelessWidget {
  final Period? lastPeriod;

  const PeriodStatusContent({super.key, required this.lastPeriod});

  @override
  Widget build(BuildContext context) {
    final statusInfo = PeriodStatusLogic.calculateStatus(lastPeriod);
    // 获取全部周期数据
    final periods = Provider.of<PeriodProvider>(context, listen: false).periods;
    final nextPeriodDays = PeriodStatusLogic.calculateNextPeriodPrediction(
      periods,
    );
    final showPredictionSwitch =
        Provider.of<PeriodProvider>(context).showPrediction;

    Widget mainWidget;
    switch (statusInfo.status) {
      case PeriodStatus.noPeriod:
        mainWidget = const NoPeriodWidget();
        break;
      case PeriodStatus.startedToday:
        mainWidget = PeriodStartedTodayWidget(title: statusInfo.title);
        break;
      case PeriodStatus.inProgress:
        mainWidget = PeriodInProgressWidget(
          title: statusInfo.title,
          days: statusInfo.days,
        );
        break;
      case PeriodStatus.endedToday:
        mainWidget = PeriodEndedWidget(title: statusInfo.title);
        break;
      case PeriodStatus.ended:
        mainWidget = DefaultPeriodStatusWidget(
          title: statusInfo.title,
          days: statusInfo.days,
        );
        break;
    }

    // 仅在非生理期状态时显示预测内容
    if (nextPeriodDays != null &&
        statusInfo.status.isShowPrediction &&
        showPredictionSwitch) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          mainWidget,
          const SizedBox(height: 12),
          Text(
            '预计下次生理期还有 $nextPeriodDays 天',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      return mainWidget;
    }
  }
}
