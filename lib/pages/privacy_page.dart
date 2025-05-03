import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_1/utils/auth_util.dart';
// 添加新的导入
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:test_1/period_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('安全', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _biometricEnabled == null
              ? const Placeholder(fallbackHeight: 0, fallbackWidth: 0)
              : Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(title: Text('生物识别解锁')),
                    SwitchListTile(
                      title: const Text('使用生物识别解锁'),
                      subtitle: const Text('保护您的数据安全'),
                      value: _biometricEnabled!,
                      onChanged: _toggleBiometric,
                    ),
                  ],
                ),
              ),

          SizedBox(height: _biometricEnabled == null ? 0 : 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('${DateTime.fromMillisecondsSinceEpoch(DateTime.now())}'),
                ListTile(title: const Text('数据安全')),
                ListTile(
                  leading: const Icon(Icons.local_library),
                  title: const Text('备份数据到本地'),
                  onTap: () async {
                    try {
                      final provider = Provider.of<PeriodProvider>(
                        context,
                        listen: false,
                      );
                      final jsonData = await provider.exportPeriodsToJson();
                      final bytes = utf8.encode(jsonData);

                      final result = await FilePicker.platform.saveFile(
                        dialogTitle: '保存备份文件',
                        fileName:
                            'Period_Data_${DateTime.now().toString().substring(0, 10).replaceAll('-', '')}.txt',
                        type: FileType.custom,
                        bytes: bytes,
                        allowedExtensions: ['txt'],
                      );

                      if (result != null) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('数据备份成功')),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('备份失败: ${e.toString()}')),
                        );
                      }
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.import_export),
                  title: const Text('导入数据'),
                  onTap: () async {
                    try {
                      final provider = Provider.of<PeriodProvider>(
                        context,
                        listen: false,
                      );

                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['txt'],
                      );

                      if (result != null) {
                        final file = File(result.files.single.path!);
                        if (context.mounted) {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('导入数据'),
                                  content: const Text('导入后将清楚之前所有数据，是否继续？'),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: const Text('取消'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: const Text('确定'),
                                    ),
                                  ],
                                ),
                          );
                          if (confirmed == true) {
                            final jsonData = await file.readAsString();
                            await provider.importPeriodsFromJson(jsonData);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('数据导入成功')),
                              );
                            }
                          }
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('导入失败: ${e.toString()}')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
