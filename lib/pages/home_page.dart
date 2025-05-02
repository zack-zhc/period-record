// 首先创建一个新的主页组件
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/period_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PeriodProvider>(
      builder: (context, periodProvider, child) {
        if (periodProvider.lastPeriod == null) {
          return Center(child: Text(
              '还没有记录生理期',
              style: Theme.of(context).textTheme.bodyLarge,
            ));
        }
        var lastPeriod = periodProvider.lastPeriod!;
        var title = '';
        var diff = 0;
        if (lastPeriod.end != null) {
          diff = lastPeriod.start!.difference(DateTime.now()).inDays * -1;
          title = '上一次生理期开始之后';
        }

        if (diff == 0 && lastPeriod.end == null) {
          title = '生理期今天刚开始';
          return Container(
            color: Theme.of(context).colorScheme.error,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (diff == 0 && lastPeriod.end!= null) {
          title = '上次生理期刚刚结束'; 
          return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(title, style: Theme.of(context).textTheme.bodyLarge,)],
          ),);
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$diff', style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold
                  )),
                  const SizedBox(width: 4),
                  Text('天', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
