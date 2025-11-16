import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:period_record/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:period_record/period_provider.dart';
import 'dart:io';

class DataImportTile extends StatefulWidget {
  const DataImportTile({super.key});

  @override
  State<DataImportTile> createState() => _DataImportTileState();
}

class _DataImportTileState extends State<DataImportTile>
    with SingleTickerProviderStateMixin {
  bool _isImporting = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

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

  Future<void> _importData() async {
    if (_isImporting) return;
    setState(() {
      _isImporting = true;
    });
    try {
      final provider = Provider.of<PeriodProvider>(context, listen: false);
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );
      if (result != null && mounted) {
        final file = File(result.files.single.path!);
        final confirmed = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('导入数据'),
                content: const Text('导入后将清除之前所有数据，是否继续？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('取消'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('确定'),
                  ),
                ],
              ),
        );
        if (confirmed == true && mounted) {
          final jsonData = await file.readAsString();
          await provider.importPeriodsFromJson(jsonData);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.of(context).onPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('数据导入成功'),
                  ],
                ),
                backgroundColor: AppColors.of(context).primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.of(context).onError,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text('导入失败: ${e.toString()}')),
              ],
            ),
            backgroundColor: AppColors.of(context).error,
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
          _isImporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ListTile(
        // leading: Container(
        //   padding: const EdgeInsets.all(8),
        //   child: Icon(
        //     Icons.file_upload,
        //     color: AppColors.of(context).onTertiaryContainer,
        //     size: 20,
        //   ),
        // ),
        title: const Text('导入数据'),
        subtitle: const Text('从本地文件导入周期数据'),
        trailing:
            _isImporting
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.of(context).primary,
                    ),
                  ),
                )
                : Container(
                  padding: const EdgeInsets.all(8),
                  // decoration: BoxDecoration(
                  //   color: AppColors.of(context).primaryContainer,
                  //   borderRadius: BorderRadius.circular(8),
                  // ),
                  child: Icon(
                    Icons.file_upload,
                    color: AppColors.of(context).onPrimaryContainer,
                    size: 20,
                  ),
                ),
        onTap: () async {
          _animationController.forward().then((_) {
            _animationController.reverse();
          });
          await _importData();
        },
      ),
    );
  }
}
