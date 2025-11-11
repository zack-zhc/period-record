import 'package:flutter/material.dart';
import 'package:period_record/theme/app_colors.dart';

/// 主页自定义AppBar组件
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      elevation: 4.0,
      backgroundColor: isDark ? colors.surface : colors.primary,
      title: Text(
        '生理期记录',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? colors.onSurface : colors.onPrimary,
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.favorite,
          color: isDark ? colors.onSurface : colors.onPrimary,
          size: 24,
        ),
      ),
      actions: const [],
    );
  }



  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
