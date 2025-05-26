import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:test_1/period_provider.dart';
import 'dart:convert';

class DataBackupTile extends StatelessWidget {
  const DataBackupTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.local_library),
      title: const Text('备份数据到本地'),
      onTap: () async {
        try {
          final provider = Provider.of<PeriodProvider>(context, listen: false);
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

          if (result != null && context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('数据备份成功')));
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('备份失败: ${e.toString()}')));
          }
        }
      },
    );
  }
}
