import 'package:flutter/material.dart';
import 'package:test_1/pages/stats_page.dart';

/// 主页自定义AppBar组件
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('生理期记录', style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          onPressed: () => _navigateToStats(context),
          icon: const Icon(Icons.bar_chart),
          tooltip: '查看统计',
        ),
      ],
    );
  }

  /// 导航到统计页面
  void _navigateToStats(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Scaffold(body: StatsPage()),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
