// 首先创建一个新的主页组件
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:period_record/period_provider.dart';
import 'package:period_record/components/home_app_bar.dart';
import 'package:period_record/components/period_action_button.dart';
import 'package:period_record/components/period_status_content.dart';

/// 主页面
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PeriodProvider>(
      builder: (context, periodProvider, child) {
        return Scaffold(
          appBar: const HomeAppBar(),
          body: Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: PeriodStatusContent(lastPeriod: periodProvider.lastPeriod),
            ),
          ),
          floatingActionButton: PeriodActionButton(
            periodProvider: periodProvider,
          ),
        );
      },
    );
  }
}
