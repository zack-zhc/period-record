import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeOptions = ['跟随系统', '亮色', '暗色'];
    final themeIcons = [
      Icons.brightness_auto,
      Icons.light_mode,
      Icons.dark_mode,
    ];
    final currentIndex = themeOptions.indexOf(themeProvider.theme);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          themeIcons[currentIndex],
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: const Text('主题'),
      subtitle: Text('当前：${themeOptions[currentIndex]}'),
      trailing: Builder(
        builder:
            (context) => FilledButton.tonal(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;
                final Offset position = button.localToGlobal(
                  Offset.zero,
                  ancestor: overlay,
                );
                final selected = await showMenu<int>(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    position.dx,
                    position.dy + button.size.height,
                    overlay.size.width - position.dx - button.size.width,
                    0,
                  ),
                  items: List.generate(themeOptions.length, (index) {
                    return PopupMenuItem<int>(
                      value: index,
                      child: Row(
                        children: [
                          Icon(
                            themeIcons[index],
                            color:
                                index == currentIndex
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 12),
                          Text(themeOptions[index]),
                          const Spacer(),
                          if (index == currentIndex)
                            Icon(
                              Icons.check,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                        ],
                      ),
                    );
                  }),
                  elevation: 8,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
                if (selected != null && selected != currentIndex) {
                  themeProvider.setTheme(themeOptions[selected]);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    themeIcons[currentIndex],
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(themeOptions[currentIndex]),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
      ),
    );
  }
}
