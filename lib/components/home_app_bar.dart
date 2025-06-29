import 'package:flutter/material.dart';
import 'package:test_1/pages/stats_page.dart';
import 'package:test_1/theme/app_colors.dart';

/// 主页自定义AppBar组件
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors.appBarGradient,
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getIconBackgroundColor(colors, isDark),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.favorite,
              color: _getIconColor(colors, isDark),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '生理期记录',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getTitleColor(colors, isDark),
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () => _navigateToStats(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(colors, isDark),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.bar_chart,
                color: _getIconColor(colors, isDark),
                size: 20,
              ),
            ),
            tooltip: '查看统计',
          ),
        ),
      ],
    );
  }

  /// 获取图标背景颜色
  Color _getIconBackgroundColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return colors.onPrimaryContainer.withValues(alpha: 0.2);
    } else {
      return AppColors.white.withValues(alpha: 0.2);
    }
  }

  /// 获取图标颜色
  Color _getIconColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return colors.onPrimaryContainer;
    } else {
      return AppColors.white;
    }
  }

  /// 获取标题颜色
  Color _getTitleColor(ThemeColors colors, bool isDark) {
    if (isDark) {
      return colors.onPrimaryContainer;
    } else {
      return AppColors.white;
    }
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
