import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeOptions = ['跟随系统', '亮色', '暗色'];

    return ListTile(
      title: const Text('主题'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButton<String>(
          value: themeProvider.theme,
          underline: Container(),
          borderRadius: BorderRadius.circular(12),
          elevation: 2,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
          ),
          dropdownColor: Theme.of(context).colorScheme.surfaceContainer,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          items:
              themeOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              themeProvider.setTheme(newValue);
            }
          },
        ),
      ),
    );
  }
}
