import 'package:flutter/material.dart';
import 'package:test_1/components/biometric_lock_tile.dart';
import 'package:test_1/components/data_backup_tile.dart';
import 'package:test_1/components/data_import_tile.dart';
import 'package:test_1/components/prediction_switch_tile.dart';
import 'package:test_1/components/settings_card.dart';
import 'package:test_1/components/theme_selector.dart';
import 'package:test_1/pages/about_page.dart';
import 'package:test_1/theme/app_colors.dart';

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
            // 通用设置
            SettingsCard(
              title: '通用',
              icon: Icons.settings,
              color: Theme.of(context).colorScheme.primary,
              children: [ThemeSelector(), const PredictionSwitchTile()],
            ),

            // 安全设置
            SettingsCard(
              title: '安全',
              icon: Icons.security,
              color: Theme.of(context).colorScheme.secondary,
              children: [
                BiometricLockTile(forceShow: false),
                const DataBackupTile(),
                const DataImportTile(),
              ],
            ),

            // 其他设置
            SettingsCard(
              title: '其他',
              icon: Icons.more_horiz,
              color: Theme.of(context).colorScheme.tertiary,
              children: [_buildAboutTile(context)],
            ),

            const SizedBox(height: 32),

            // 底部装饰
            _buildBottomDecoration(context),
          ],
        ),
      ),
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

  Widget _buildAboutTile(BuildContext context) {
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
      trailing: TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 32),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const AboutPage()));
        },
        child: const Text('打开'),
      ),
    );
  }

  Widget _buildBottomDecoration(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '设置完成',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
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
