import 'package:flutter/material.dart';
import 'package:period_record/pages/about_page.dart';
import 'package:period_record/pages/appearance_page.dart';
import 'package:period_record/pages/privacy_data_page.dart';
import 'package:period_record/theme/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(context, colors, isDark),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // 提醒设置
            _buildReminderSettingsTile(context),

            // 默认周期设置
            _buildDefaultCycleSettingsTile(context),

            // 默认经期设置
            _buildDefaultPeriodSettingsTile(context),

            // 外观
            _buildThemeSettingsTile(context),

            // 隐私与数据
            _buildPrivacyDataSettingsTile(context),

            // 关于应用
            _buildAboutSettingsTile(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderSettingsTile(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.notifications,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          size: 20,
        ),
      ),
      title: const Text('提醒设置'),
      subtitle: const Text('管理生理期和排卵期提醒'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Navigator.of(context).push();
      },
    );
  }

  Widget _buildDefaultCycleSettingsTile(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.calendar_month,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          size: 20,
        ),
      ),
      title: const Text('默认周期设置'),
      subtitle: const Text('设置默认的生理周期天数'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // 这里可以导航到默认周期设置页面
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('默认周期设置'),
                content: const Text('设置默认的生理周期天数（通常为28天）'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('确定'),
                  ),
                ],
              ),
        );
      },
    );
  }

  Widget _buildDefaultPeriodSettingsTile(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.water_drop,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
          size: 20,
        ),
      ),
      title: const Text('默认经期设置'),
      subtitle: const Text('设置默认的经期持续天数'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // 这里可以导航到默认经期设置页面
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('默认经期设置'),
                content: const Text('设置默认的经期持续天数（通常为5天）'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('确定'),
                  ),
                ],
              ),
        );
      },
    );
  }

  Widget _buildThemeSettingsTile(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.palette,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          size: 20,
        ),
      ),
      title: const Text('外观'),
      subtitle: const Text('选择应用主题和外观'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const AppearancePage()));
      },
    );
  }

  Widget _buildPrivacyDataSettingsTile(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.privacy_tip,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
          size: 20,
        ),
      ),
      title: const Text('隐私与数据'),
      subtitle: const Text('管理数据隐私和安全设置'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const PrivacyDataPage()),
        );
      },
    );
  }

  Widget _buildAboutSettingsTile(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.info_outline,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
          size: 20,
        ),
      ),
      title: const Text('关于应用'),
      subtitle: const Text('查看应用信息和版本'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const AboutPage()));
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeColors colors,
    bool isDark,
  ) {
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
      title: Text(
        '设置',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: _getTitleColor(colors, isDark),
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        onPressed: () {},
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getIconBackgroundColor(colors, isDark),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.settings,
            color: _getIconColor(colors, isDark),
            size: 20,
          ),
        ),
      ),
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
}
