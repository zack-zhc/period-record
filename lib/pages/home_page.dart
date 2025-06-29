// 首先创建一个新的主页组件
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/period_provider.dart';
import 'package:test_1/components/home_app_bar.dart';
import 'package:test_1/components/period_action_button.dart';
import 'package:test_1/components/period_status_content.dart';

/// 主页面
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PeriodProvider>(
      builder: (context, periodProvider, child) {
        return Scaffold(
          appBar: const HomeAppBar(),
          body: PeriodStatusContent(lastPeriod: periodProvider.lastPeriod),
          floatingActionButton: PeriodActionButton(
            periodProvider: periodProvider,
          ),
        );
      },
    );
  }
}
