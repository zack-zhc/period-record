import 'package:flutter/material.dart';
import 'package:test_1/components/biometric_lock_tile.dart';
import 'package:test_1/components/data_backup_tile.dart';
import 'package:test_1/components/data_import_tile.dart';
import 'package:test_1/components/settings_card.dart';
import 'package:test_1/components/theme_selector.dart';
import 'package:test_1/pages/about_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainer,
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // 通用设置
                _buildAnimatedSettingsCard(
                  title: '通用',
                  icon: Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                  children: [ThemeSelector()],
                  delay: 0,
                ),

                // 安全设置
                _buildAnimatedSettingsCard(
                  title: '安全',
                  icon: Icons.security,
                  color: Theme.of(context).colorScheme.secondary,
                  children: [
                    BiometricLockTile(),
                    const DataBackupTile(),
                    const DataImportTile(),
                  ],
                  delay: 100,
                ),

                // 其他设置
                _buildAnimatedSettingsCard(
                  title: '其他',
                  icon: Icons.more_horiz,
                  color: Theme.of(context).colorScheme.tertiary,
                  children: [_buildAboutTile(context)],
                  delay: 200,
                ),

                const SizedBox(height: 32),

                // 底部装饰
                _buildBottomDecoration(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSettingsCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: SettingsCard(
              title: title,
              icon: icon,
              color: color,
              children: children,
            ),
          ),
        );
      },
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
}
