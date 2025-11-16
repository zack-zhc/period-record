import 'package:flutter/material.dart';
import 'package:period_record/components/theme_selector.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  @override
  Widget build(BuildContext context) {
    // 使用Material 3推荐的布局
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            // 主题设置分组 - 使用Material 3推荐的间距
            _buildSectionHeader('主题'),
            const ThemeSelector(),

            const SizedBox(height: 24),

            // 其他外观设置分组
            _buildSectionHeader('其他'),
            _buildAccentColorTile(context),
            _buildFontSizeTile(context),

            // 添加底部间距以改善滚动体验
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Text(
        title,
        // style: Theme.of(context).textTheme.titleMedium?.copyWith(
        //   fontWeight: FontWeight.w600,
        //   color: Theme.of(context).colorScheme.primary,
        // ),
      ),
    );
  }

  Widget _buildAccentColorTile(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.palette,
          color: Theme.of(context).colorScheme.primary,
          size: 24, // 稍大的图标更符合Material 3
        ),
      ),
      title: const Text('强调色'),
      subtitle: const Text('选择应用的主要颜色'),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: () {
        // 使用Material 3的AlertDialog样式
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
                // 使用Material 3推荐的形状
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
        );
      },
    );
  }

  Widget _buildFontSizeTile(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.text_fields,
          color: Theme.of(context).colorScheme.primary,
          size: 24, // 稍大的图标更符合Material 3
        ),
      ),
      title: const Text('字体大小'),
      subtitle: const Text('调整应用中的文字大小'),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: () {
        // 使用Material 3的AlertDialog样式
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
                // 使用Material 3推荐的形状
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // 符合Material 3的AppBar实现
    return AppBar(
      // Material 3中AppBar使用surface颜色作为背景
      backgroundColor: Theme.of(context).colorScheme.surface,
      // 使用Material 3推荐的阴影效果
      elevation: 0,
      scrolledUnderElevation: 2,
      // 应用Material 3的标题样式
      title: Text(
        '外观',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onSurface,
          size: 24,
        ),
      ),
    );
  }
}
