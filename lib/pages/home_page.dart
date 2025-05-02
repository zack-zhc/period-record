// 首先创建一个新的主页组件
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/pages/stats_page.dart';
import 'package:test_1/period_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _noLastPeriodWidget() {
    return Center(child: Text('还没有记录生理期', style: TextStyle(fontSize: 18)));
  }

  Widget _periodStartedTodayWidget(BuildContext context, String title) {
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

  Widget _periodEndedTodayWidget(BuildContext context, String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(title, style: Theme.of(context).textTheme.bodyLarge)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PeriodProvider>(
      builder: (context, periodProvider, child) {
        var noLastPeriod = periodProvider.lastPeriod == null;
        var periodStartedToday = false;
        var lastPeriodJustEnd = false;

        Widget body;

        if (noLastPeriod) {
          body = _noLastPeriodWidget();
        }

        var title = '';
        var diff = 0;

        var lastPeriod = periodProvider.lastPeriod;
        if (lastPeriod != null && lastPeriod.end != null) {
          diff = lastPeriod.start!.difference(DateTime.now()).inDays * -1;
          title = '上一次生理期开始之后';
        }

        if (lastPeriod != null && diff == 0 && lastPeriod.end == null) {
          title = '生理期今天刚开始';
          periodStartedToday = true;
          body = _periodStartedTodayWidget(context, title);
        }

        if (lastPeriod != null && diff == 0 && lastPeriod.end != null) {
          title = '上次生理期刚刚结束';
          lastPeriodJustEnd = true;
          body = _periodEndedTodayWidget(context, title);
        }

        body = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$diff',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text('天', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text('生理期记录', style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Scaffold(body: const StatsPage()),
                    ),
                  );
                },
                icon: const Icon(Icons.bar_chart), // 修改图标为设置图标
              ),
            ],
          ),
          body: body,
        );
      },
    );
  }
}
