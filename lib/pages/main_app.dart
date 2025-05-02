import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/pages/home_page.dart';
import 'package:test_1/period.dart';
import 'package:test_1/period_provider.dart';
import 'package:test_1/pages/stats_page.dart';
import 'package:test_1/pages/settings_page.dart'; // 导入设置页面

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
    const HomePage(), // 使用新的主页组件
    const SettingsPage(), // 改为设置页
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumScreen = screenWidth >= 600; // 中等屏幕
    final isExpandedScreen = screenWidth >= 840; // 扩展屏幕

    return Consumer<PeriodProvider>(
      builder: (context, periodProvider, child) {
        return Scaffold(
          body: Row(
            children: [
              if (isMediumScreen) // 中等和扩展屏幕都显示NavigationRail
                NavigationRail(
                  extended: isExpandedScreen, // 扩展屏幕时显示完整标签
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_today_outlined),
                      selectedIcon: Icon(Icons.calendar_today),
                      label: Text('记录'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: Text('设置'),
                    ),
                  ],
                ),
              Expanded(child: _pages[_currentIndex]), // 主要内容区域
            ],
          ),
          bottomNavigationBar:
              isMediumScreen
                  ? null // 宽屏时不显示底部导航
                  : NavigationBar(
                    // 窄屏时显示底部导航
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
