import 'package:flutter/material.dart';
import 'package:test_1/pages/privacy_page.dart';

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
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('通知设置'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // 跳转到通知设置页面
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('主题设置'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // 跳转到主题设置页面
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('安全'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PrivacyPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('帮助与反馈'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // 跳转到帮助页面
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('关于应用'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // 跳转到关于页面
            },
          ),
        ],
      ),
    );
  }
}
