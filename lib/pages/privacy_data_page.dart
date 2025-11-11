import 'package:flutter/material.dart';
import 'package:period_record/components/biometric_lock_tile.dart';
import 'package:period_record/components/data_backup_tile.dart';
import 'package:period_record/components/data_import_tile.dart';
import 'package:period_record/components/prediction_switch_tile.dart';
import 'package:period_record/theme/app_colors.dart';

class PrivacyDataPage extends StatefulWidget {
  const PrivacyDataPage({super.key});

  @override
  State<PrivacyDataPage> createState() => _PrivacyDataPageState();
}

class _PrivacyDataPageState extends State<PrivacyDataPage> {
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(context, colors, isDark),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // 生物识别
            BiometricLockTile(forceShow: false),

            // 数据备份
            const DataBackupTile(),

            // 数据导入
            const DataImportTile(),

            // 预测设置
            const PredictionSwitchTile(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeColors colors,
    bool isDark,
  ) {
    return AppBar(
      elevation: 4.0,
      backgroundColor: isDark ? colors.surface : colors.primary,
      title: Text(
        '隐私与数据',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? colors.onSurface : colors.onPrimary,
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back,
          color: isDark ? colors.onSurface : colors.onPrimary,
          size: 24,
        ),
      ),
    );
  }


}
