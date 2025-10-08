import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:period_record/pages/home_page.dart';
import 'package:period_record/period_provider.dart';
import 'package:period_record/pages/settings_page.dart'; // 导入设置页面
import 'package:period_record/pages/stats_page.dart'; // 导入统计页面

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

// 然后修改_pages数组
class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    // 使用addPostFrameCallback确保widget树已构建完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PeriodProvider>(context, listen: false).loadPeriods();
    });
  }

  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(), // 主页组件
    const StatsPage(), // 统计页面
    const SettingsPage(), // 设置页面
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<PeriodProvider>(
      builder: (context, periodProvider, child) {
        return Scaffold(
          body: _pages[_currentIndex], // 主要内容区域
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_today),
                label: '记录',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: '统计',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: '设置',
              ),
            ],
          ),
        );
      },
    );
  }
}
