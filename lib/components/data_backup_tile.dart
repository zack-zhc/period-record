import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:test_1/period_provider.dart';
import 'dart:convert';

class DataBackupTile extends StatefulWidget {
  const DataBackupTile({super.key});

  @override
  State<DataBackupTile> createState() => _DataBackupTileState();
}

class _DataBackupTileState extends State<DataBackupTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isBackingUp = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _backupData() async {
    if (_isBackingUp) return;

    setState(() {
      _isBackingUp = true;
    });

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

      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text('数据备份成功'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.onError,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text('备份失败: ${e.toString()}')),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBackingUp = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.backup,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            size: 20,
          ),
        ),
        title: const Text('备份数据到本地'),
        subtitle: const Text('将数据保存到本地文件'),
        trailing:
            _isBackingUp
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
                : Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.download,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 20,
                  ),
                ),
        onTap: () async {
          _animationController.forward().then((_) {
            _animationController.reverse();
          });
          await _backupData();
        },
      ),
    );
  }
}
