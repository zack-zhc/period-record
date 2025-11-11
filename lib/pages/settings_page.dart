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

    return Scaffold(
      // 使用Material 3的AppBar设计
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: false,
        // 移除自定义背景色和elevation，使用Material 3的默认样式
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 生理周期设置组
            _buildSettingsGroup(
              context,
              title: '生理周期设置',
              children: [
                // 提醒设置
                _buildSettingsTile(
                  context,
                  icon: Icons.notifications,
                  title: '提醒设置',
                  subtitle: '管理生理期和排卵期提醒',
                  onTap: () {
                    // 暂时保留空实现，等待导航逻辑
                  },
                ),

                // 默认周期设置
                _buildSettingsTile(
                  context,
                  icon: Icons.calendar_month,
                  title: '默认周期设置',
                  subtitle: '设置默认的生理周期天数',
                  onTap: () {
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
                ),

                // 默认经期设置
                _buildSettingsTile(
                  context,
                  icon: Icons.water_drop,
                  title: '默认经期设置',
                  subtitle: '设置默认的经期持续天数',
                  onTap: () {
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
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 外观与设置组
            _buildSettingsGroup(
              context,
              title: '外观与设置',
              children: [
                // 外观
                _buildSettingsTile(
                  context,
                  icon: Icons.palette,
                  title: '外观',
                  subtitle: '选择应用主题和外观',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AppearancePage(),
                        // 添加过渡动画
                        fullscreenDialog: false,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 隐私与信息组
            _buildSettingsGroup(
              context,
              title: '隐私与信息',
              children: [
                // 隐私与数据
                _buildSettingsTile(
                  context,
                  icon: Icons.privacy_tip,
                  title: '隐私与数据',
                  subtitle: '管理数据隐私和安全设置',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrivacyDataPage(),
                        fullscreenDialog: false,
                      ),
                    );
                  },
                ),

                // 关于应用
                _buildSettingsTile(
                  context,
                  icon: Icons.info_outline,
                  title: '关于应用',
                  subtitle: '查看应用信息和版本',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AboutPage(),
                        fullscreenDialog: false,
                      ),
                    );
                  },
                ),
              ],
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
        // 分组标题
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // 分组内容卡片
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  // Material 3风格的设置项
  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              // Material 3风格的图标容器
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),

              const SizedBox(width: 16),

              // 标题和副标题
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.bodyLarge),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // 右箭头图标
              Icon(
                Icons.chevron_right,
                size: 24,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
