import 'package:flutter/material.dart';
import 'package:period_record/components/theme_selector.dart';
import 'package:period_record/font_provider.dart';
import 'package:provider/provider.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  // 本页的临时 UI 状态（建议后续持久化到 Provider/设置存储）
  String _accentColorName = '系统默认';
  Color _accentColor = Colors.blue;

  // 常用强调色候选（名字用于展示）
  final List<Map<String, Object>> _accentColorOptions = [
    {'name': '粉色', 'color': Colors.pink},
    {'name': '红色', 'color': Colors.red},
    {'name': '紫色', 'color': Colors.purple},
    {'name': '蓝色', 'color': Colors.blue},
    {'name': '青色', 'color': Colors.teal},
    {'name': '绿色', 'color': Colors.green},
  ];
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
        child: CircleAvatar(
          backgroundColor: _accentColor.withOpacity(0.14),
          child: Icon(Icons.palette, color: _accentColor, size: 20),
        ),
      ),
      title: const Text('强调色'),
      subtitle: const Text('选择应用的主要颜色'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              _accentColorName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
      onTap: () => _showAccentColorSheet(context),
    );
  }

  void _showAccentColorSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      // ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('选择强调色', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    _accentColorOptions.map((opt) {
                      final name = opt['name'] as String;
                      final color = opt['color'] as Color;
                      final selected = color.value == _accentColor.value;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _accentColor = color;
                            _accentColorName = name;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                shape: BoxShape.circle,
                                border:
                                    selected
                                        ? Border.all(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                          width: 2,
                                        )
                                        : null,
                              ),
                              child: Center(
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    boxShadow:
                                        selected
                                            ? [
                                              BoxShadow(
                                                color: color.withOpacity(0.24),
                                                blurRadius: 6,
                                              ),
                                            ]
                                            : null,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              name,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _accentColorName = '系统默认';
                    _accentColor = Theme.of(context).colorScheme.primary;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('恢复默认'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFontSizeTile(BuildContext context) {
    final fontScale = context.watch<FontProvider>().fontScale;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.12),
          child: Icon(
            Icons.text_fields,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
      ),
      title: const Text('字体大小'),
      subtitle: const Text('调整应用中的文字大小'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              _fontScaleLabel(fontScale),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
      onTap: () => _showFontSizeSheet(context),
    );
  }

  void _showFontSizeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer<FontProvider>(
          builder: (context, fontProvider, _) {
            final fontScale = fontProvider.fontScale;
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('字体大小', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Slider(
                    min: FontProvider.minFontScale,
                    max: FontProvider.maxFontScale,
                    divisions: 6,
                    value: fontScale,
                    label: _fontScaleLabel(fontScale),
                    onChanged: (v) {
                      fontProvider.setFontScale(v);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '示例文本：用于预览字体大小',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontSize: 16 * fontScale),
                        ),
                        TextButton(
                          onPressed: () {
                            fontProvider.setFontScale(1.0);
                          },
                          child: const Text('恢复默认'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _fontScaleLabel(double scale) {
    if ((scale - 1.0).abs() < 0.01) return '中等';
    return scale < 1.0 ? '较小' : '较大';
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // 符合Material 3的AppBar实现
    return AppBar(
      // Material 3中AppBar使用surface颜色作为背景
      // 使用Material 3推荐的阴影效果
      elevation: 0,
      scrolledUnderElevation: 2,
      // 应用Material 3的标题样式
      title: Text('外观'),
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
