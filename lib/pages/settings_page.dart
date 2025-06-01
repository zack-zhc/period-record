import 'package:flutter/material.dart';
import 'package:test_1/components/biometric_lock_tile.dart';
import 'package:test_1/components/data_backup_tile.dart';
import 'package:test_1/components/data_import_tile.dart';
import 'package:test_1/components/settings_card.dart';
import 'package:test_1/components/theme_selector.dart';
import 'package:test_1/pages/about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          SettingsCard(title: '通用', children: [ThemeSelector()]),
          SettingsCard(
            title: '安全',
            children: [
              BiometricLockTile(),
              const DataBackupTile(),
              const DataImportTile(),
            ],
          ),
          SettingsCard(
            title: '其他',
            children: [
              ListTile(
                title: const Text('关于应用'),
                trailing: FilledButton.tonal(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AboutPage(),
                      ),
                    );
                  },
                  child: Text('打开'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
