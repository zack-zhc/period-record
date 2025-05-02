import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/pages/home_page.dart';
import 'package:test_1/period.dart';
import 'package:test_1/period_provider.dart';
import 'package:test_1/pages/stats_page.dart';

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
    const StatsPage(), // 统计页
  ];

  Future<void> _showAddPeriodDialog(BuildContext context) async {
    final dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(hours: 1)),
      ),
      locale: Localizations.localeOf(context), // 确保使用当前语言环境
    );

    if (dateRange != null && context.mounted) {
      await Provider.of<PeriodProvider>(
        context,
        listen: false,
      ).addPeriod(dateRange.start, dateRange.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumScreen = screenWidth >= 600; // 中等屏幕
    final isExpandedScreen = screenWidth >= 840; // 扩展屏幕

    return Consumer<PeriodProvider>(
      builder: (context, periodProvider, child) {
        var title = '记录生理期';
        if (_currentIndex == 1) {
          title = '生理期记录统计';
        }

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
                      icon: Icon(Icons.bar_chart_outlined),
                      selectedIcon: Icon(Icons.bar_chart),
                      label: Text('统计'),
                    ),
                  ],
                ),
              Expanded(child: _pages[_currentIndex]), // 主要内容区域
            ],
          ),
          appBar: AppBar(
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            actions:
                _currentIndex == 1
                    ? [
                      IconButton(
                        onPressed: () => _showAddPeriodDialog(context),
                        icon: const Icon(Icons.add),
                      ),
                    ]
                    : null,
          ),
          floatingActionButton:
              _currentIndex == 0
                  ? FloatingActionButton(
                    onPressed:
                        () => {
                          if (periodProvider.lastPeriod == null)
                            {
                              // 创建一个Period对象并添加到数据库中
                              Provider.of<PeriodProvider>(
                                context,
                                listen: false,
                              ).addPeriod(DateTime.now(), null),
                            }
                          else
                            {
                              if (periodProvider.lastPeriod!.end != null)
                                {
                                  // 创建一个Period对象并添加到数据库中
                                  Provider.of<PeriodProvider>(
                                    context,
                                    listen: false,
                                  ).addPeriod(DateTime.now(), null),
                                }
                              else
                                {
                                  // 编辑最后一个周期的结束时间
                                  Provider.of<PeriodProvider>(
                                    context,
                                    listen: false,
                                  ).editPeriod(
                                    Period.initialize(
                                      start: periodProvider.lastPeriod!.start!,
                                      end: DateTime.now(),
                                      id: periodProvider.lastPeriod!.id,
                                    ),
                                  ),
                                },
                            },
                        },
                    child: Icon(
                      periodProvider.lastPeriod == null
                          ? Icons.add
                          : (periodProvider.lastPeriod!.end != null
                              ? Icons.add
                              : Icons.check),
                    ),
                  )
                  : null,
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
                        icon: Icon(Icons.bar_chart_outlined),
                        selectedIcon: Icon(Icons.bar_chart),
                        label: '统计',
                      ),
                    ],
                  ),
        );
      },
    );
  }
}
