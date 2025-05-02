import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool? _biometricEnabled; // 改为可空类型，初始为null
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _biometricEnabled = _prefs.getBool('biometric_enabled') ?? true;
      });
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    setState(() {
      _biometricEnabled = value;
    });
    await _prefs.setBool('biometric_enabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '隐私设置',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body:
          _biometricEnabled == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    '生物识别解锁',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('使用生物识别解锁'),
                    subtitle: const Text('保护您的账户安全'),
                    value: _biometricEnabled!,
                    onChanged: _toggleBiometric,
                  ),
                  const Text(
                    '数据隐私',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('数据收集与分析'),
                    subtitle: const Text('帮助我们改进应用体验'),
                    value: false,
                    onChanged: (value) {},
                  ),
                  SwitchListTile(
                    title: const Text('个性化推荐'),
                    subtitle: const Text('根据使用习惯提供个性化内容'),
                    value: false,
                    onChanged: (value) {},
                  ),
                  const Divider(height: 32),
                  const Text(
                    '权限管理',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('通知权限'),
                    trailing: const Text('已授权'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.storage),
                    title: const Text('存储权限'),
                    trailing: const Text('已授权'),
                    onTap: () {},
                  ),
                ],
              ),
    );
  }
}
