import 'package:flutter/material.dart';

/// 显示天数的通用组件
class DaysDisplayWidget extends StatelessWidget {
  final int days;
  final TextStyle? numberStyle;
  final TextStyle? labelStyle;

  const DaysDisplayWidget({
    super.key,
    required this.days,
    this.numberStyle,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final defaultNumberStyle = Theme.of(
      context,
    ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold);

    final defaultLabelStyle = Theme.of(context).textTheme.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$days', style: numberStyle ?? defaultNumberStyle),
        const SizedBox(width: 4),
        Text('天', style: labelStyle ?? defaultLabelStyle),
      ],
    );
  }
}

/// 无记录状态组件
class NoPeriodWidget extends StatelessWidget {
  const NoPeriodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('还没有记录生理期', style: TextStyle(fontSize: 18)),
    );
  }
}

/// 生理期今天开始组件
class PeriodStartedTodayWidget extends StatelessWidget {
  final String title;

  const PeriodStartedTodayWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.error,
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
      ),
    );
  }
}

/// 生理期进行中组件
class PeriodInProgressWidget extends StatelessWidget {
  final String title;
  final int days;

  const PeriodInProgressWidget({
    super.key,
    required this.title,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.onError;

    return Container(
      color: Theme.of(context).colorScheme.error,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: errorColor),
            ),
            const SizedBox(height: 8),
            DaysDisplayWidget(
              days: days,
              numberStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: errorColor,
              ),
              labelStyle: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: errorColor),
            ),
          ],
        ),
      ),
    );
  }
}

/// 生理期结束组件
class PeriodEndedWidget extends StatelessWidget {
  final String title;

  const PeriodEndedWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}

/// 默认状态显示组件
class DefaultPeriodStatusWidget extends StatelessWidget {
  final String title;
  final int days;

  const DefaultPeriodStatusWidget({
    super.key,
    required this.title,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          DaysDisplayWidget(days: days),
        ],
      ),
    );
  }
}
