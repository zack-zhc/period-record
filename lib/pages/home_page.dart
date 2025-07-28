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
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: CustomScrollView(
              slivers: [
                // 状态显示区域整体居中
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: PeriodStatusContent(
                        lastPeriod: periodProvider.lastPeriod,
                      ),
                    ),
                  ),
                ),
              ],
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
