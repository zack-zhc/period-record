import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/pages/home_page.dart';
import 'package:test_1/period_provider.dart';
import 'package:test_1/pages/settings_page.dart'; // 导入设置页面
import 'package:test_1/theme/app_colors.dart';

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
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<PeriodProvider>(
      builder: (context, periodProvider, child) {
        return Scaffold(
          body: Row(
            children: [
              if (isMediumScreen) // 中等和扩展屏幕都显示NavigationRail
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: colors.appBarGradient,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(2, 0),
                      ),
                    ],
                  ),
                  child: NavigationRail(
                    extended: isExpandedScreen, // 扩展屏幕时显示完整标签
                    selectedIndex: _currentIndex,
                    onDestinationSelected: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    backgroundColor: Colors.transparent,
                    selectedIconTheme: IconThemeData(
                      color: _getSelectedIconColor(colors, isDark),
                      size: 24,
                    ),
                    unselectedIconTheme: IconThemeData(
                      color: _getUnselectedIconColor(colors, isDark),
                      size: 24,
                    ),
                    selectedLabelTextStyle: TextStyle(
                      color: _getSelectedLabelColor(colors, isDark),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    unselectedLabelTextStyle: TextStyle(
                      color: _getUnselectedLabelColor(colors, isDark),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    indicatorColor: _getIndicatorColor(colors, isDark),
                    destinations: [
                      NavigationRailDestination(
                        icon: const Icon(Icons.calendar_today_outlined),
                        selectedIcon: const Icon(Icons.calendar_today),
                        label: const Text('记录'),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.settings_outlined),
                        selectedIcon: const Icon(Icons.settings),
                        label: const Text('设置'),
                      ),
                    ],
                  ),
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

  /// 获取选中图标颜色
  Color _getSelectedIconColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return colors.onPrimaryContainer;
    } else {
      return AppColors.white;
    }
  }

  /// 获取未选中图标颜色
  Color _getUnselectedIconColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return colors.onPrimaryContainer.withValues(alpha: 0.7);
    } else {
      return AppColors.white.withValues(alpha: 0.7);
    }
  }

  /// 获取选中标签颜色
  Color _getSelectedLabelColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return colors.onPrimaryContainer;
    } else {
      return AppColors.white;
    }
  }

  /// 获取未选中标签颜色
  Color _getUnselectedLabelColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return colors.onPrimaryContainer.withValues(alpha: 0.7);
    } else {
      return AppColors.white.withValues(alpha: 0.7);
    }
  }

  /// 获取指示器颜色
  Color _getIndicatorColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return colors.onPrimaryContainer.withValues(alpha: 0.2);
    } else {
      return AppColors.white.withValues(alpha: 0.2);
    }
  }
}
