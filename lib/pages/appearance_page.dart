import 'package:flutter/material.dart';
import 'package:period_record/components/theme_selector.dart';
import 'package:period_record/theme/app_colors.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
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
            // 主题设置分组
            _buildSectionHeader('主题'),
            const ThemeSelector(),

            const SizedBox(height: 16),

            // 其他外观设置分组
            _buildSectionHeader('其他'),
            _buildAccentColorTile(context),
            _buildFontSizeTile(context),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildAccentColorTile(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.palette,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          size: 20,
        ),
      ),
      title: const Text('强调色'),
      subtitle: const Text('选择应用的主要颜色'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // 这里可以导航到强调色选择页面
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('强调色设置'),
                content: const Text('强调色设置功能正在开发中'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('确定'),
                  ),
                ],
              ),
        );
      },
    );
  }

  Widget _buildFontSizeTile(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.text_fields,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
          size: 20,
        ),
      ),
      title: const Text('字体大小'),
      subtitle: const Text('调整应用中的文字大小'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // 这里可以导航到字体大小设置页面
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('字体大小设置'),
                content: const Text('字体大小设置功能正在开发中'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('确定'),
                  ),
                ],
              ),
        );
      },
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
        '外观',
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
