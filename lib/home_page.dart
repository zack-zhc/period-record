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
          return const Center(child: Text('还没有记录周期'));
        }
        var lastPeriod = periodProvider.lastPeriod!;
        var title = '';
        var diff = 0;
        if (lastPeriod.end != null) {
          diff = lastPeriod.start!.difference(DateTime.now()).inDays * -1;
          title = '上一次生理期开始之后';
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(title), Text('$diff 天')],
          ),
        );
      },
    );
  }
}
