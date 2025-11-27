import 'package:flutter/material.dart';
import 'package:period_record/pages/settings_page.dart';
import 'package:period_record/pages/stats_page.dart';

/// 主页自定义AppBar组件
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('生理期记录'),
      centerTitle: true,
      // backgroundColor: Colors.transparent,
      // elevation: 0,
      // surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Scaffold(body: StatsPage()),
            ),
          );
        },
        icon: Icon(Icons.bar_chart_outlined, size: 24),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Scaffold(body: SettingsPage()),
              ),
            );
          },
          icon: Icon(Icons.settings, size: 24),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
