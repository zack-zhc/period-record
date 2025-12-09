import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme';

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
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _theme = prefs.getString(_themeKey) ?? '跟随系统';
    notifyListeners();
  }

  Future<void> setTheme(String theme) async {
    if (_theme == theme) return;
    _theme = theme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
  }
}
