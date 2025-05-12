import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/theme_provider.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeOptions = ['跟随系统', '亮色', '暗色'];

    return Scaffold(
      appBar: AppBar(title: const Text('主题设置')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('主题', style: TextStyle(fontSize: 16)),
                DropdownButton<String>(
                  value: themeProvider.theme,
                  underline: Container(),
                  items:
                      themeOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      themeProvider.setTheme(newValue);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
