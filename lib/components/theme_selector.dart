import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:period_record/theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final currentTheme = themeProvider.theme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.outline.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _getThemeIcon(currentTheme),
                  color: colors.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '外观模式',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getThemeDescription(currentTheme),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(
                  value: '跟随系统',
                  label: Text('自动'),
                  icon: Icon(Icons.brightness_auto_outlined),
                ),
                ButtonSegment<String>(
                  value: '亮色',
                  label: Text('亮色'),
                  icon: Icon(Icons.light_mode_outlined),
                ),
                ButtonSegment<String>(
                  value: '暗色',
                  label: Text('暗色'),
                  icon: Icon(Icons.dark_mode_outlined),
                ),
              ],
              selected: {currentTheme},
              onSelectionChanged: (Set<String> newSelection) {
                themeProvider.setTheme(newSelection.first);
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.comfortable,
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                side: WidgetStateProperty.all(
                  BorderSide(color: colors.outline.withValues(alpha: 0.2)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getThemeIcon(String theme) {
    switch (theme) {
      case '亮色':
        return Icons.light_mode_rounded;
      case '暗色':
        return Icons.dark_mode_rounded;
      case '跟随系统':
      default:
        return Icons.brightness_auto_rounded;
    }
  }

  String _getThemeDescription(String theme) {
    switch (theme) {
      case '亮色':
        return '始终使用浅色外观';
      case '暗色':
        return '始终使用深色外观';
      case '跟随系统':
      default:
        return '自动匹配系统设置';
    }
  }
}
