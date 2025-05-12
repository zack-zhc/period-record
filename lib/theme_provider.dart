import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  String _theme = '跟随系统';

  String get theme => _theme;
  ThemeMode get themeMode {
    switch (_theme) {
      case '亮色':
        return ThemeMode.light;
      case '暗色':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _theme = prefs.getString('theme') ?? '跟随系统';
    notifyListeners();
  }

  Future<void> setTheme(String theme) async {
    _theme = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    notifyListeners();
  }
}
