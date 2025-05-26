// 文件名改为 biometric_lock_tile.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_1/utils/auth_util.dart';

// 类名改为 BiometricLockTile
class BiometricLockTile extends StatefulWidget {
  const BiometricLockTile({super.key});

  @override
  State<BiometricLockTile> createState() => _BiometricLockTileState();
}

class _BiometricLockTileState extends State<BiometricLockTile> {
  bool? _biometricEnabled;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    if (!await AuthUtil.checkBiometricsSupport()) {
      return;
    }
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
    if (_biometricEnabled == null) {
      return const SizedBox.shrink();
    }

    return ListTile(
      title: const Text('使用生物识别解锁'),
      subtitle: const Text('保护您的数据安全'),
      trailing: Switch(value: _biometricEnabled!, onChanged: _toggleBiometric),
    );
  }
}
