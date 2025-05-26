import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:test_1/period_provider.dart';
import 'dart:io';

class DataImportTile extends StatelessWidget {
  const DataImportTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.import_export),
      title: const Text('导入数据'),
      onTap: () async {
        try {
          final provider = Provider.of<PeriodProvider>(context, listen: false);
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
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('确定'),
                        ),
                      ],
                    ),
              );
              if (confirmed == true) {
                final jsonData = await file.readAsString();
                await provider.importPeriodsFromJson(jsonData);
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('数据导入成功')));
                }
              }
            }
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('导入失败: ${e.toString()}')));
          }
        }
      },
    );
  }
}
