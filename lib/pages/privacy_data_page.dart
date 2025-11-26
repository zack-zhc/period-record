import 'package:flutter/material.dart';
import 'package:period_record/components/biometric_lock_tile.dart';
import 'package:period_record/components/data_backup_tile.dart';
import 'package:period_record/components/data_import_tile.dart';
import 'package:period_record/components/prediction_switch_tile.dart';
import 'package:period_record/theme/app_colors.dart';

class PrivacyDataPage extends StatefulWidget {
  const PrivacyDataPage({super.key});

  @override
  State<PrivacyDataPage> createState() => _PrivacyDataPageState();
}

class _PrivacyDataPageState extends State<PrivacyDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 使用Material 3的AppBar设计
      appBar: AppBar(title: const Text('隐私与数据'), centerTitle: false),
      body: Container(
        color:
            Theme.of(
              context,
            ).colorScheme.surface, // 使用Material Design默认的background颜色
        child: ListView(
          padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
          children: [
            // 安全设置组
            _buildSettingsGroup(
              context,
              title: '安全设置',
              children: [
                // 生物识别
                BiometricLockTile(forceShow: false),
              ],
            ),

            const SizedBox(height: 24),

            // 数据管理组
            _buildSettingsGroup(
              context,
              title: '数据管理',
              children: [
                // 数据备份
                const DataBackupTile(),
                // 添加分隔线
                const Divider(indent: 16, endIndent: 16),
                // 数据导入
                const DataImportTile(),
              ],
            ),

            const SizedBox(height: 24),

            // 隐私设置组
            _buildSingleSetting(
              context,
              subtitle: '开启后，应用将显示基于历史数据的生理期预测信息。',
              title: '预测设置',
              child: const PredictionSwitchTile(),
            ),
          ],
        ),
      ),
    );
  }

  // Material 3风格的设置项组
  Widget _buildSettingsGroup(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 分组标题 - 符合Material 3规范
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // 分组内容卡片 - Material 3风格的卡片
        Card(
          elevation: 1,
          shadowColor: Theme.of(context).colorScheme.shadow,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSingleSetting(
    BuildContext context, {
    String? subtitle,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 分组标题 - 符合Material 3规范
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            top: 16.0,
            bottom: 8,
            // right: 16,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // 分组内容卡片 - Material 3风格的卡片
        Card(
          elevation: 1,
          shadowColor: Theme.of(context).colorScheme.shadow,
          surfaceTintColor: AppColors.of(context).surfaceContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(children: [child]),
        ),

        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
