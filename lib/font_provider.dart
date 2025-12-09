import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontProvider extends ChangeNotifier {
  static const String _fontScaleKey = 'fontScale';
  static const double minFontScale = 0.85;
  static const double maxFontScale = 1.15;

  double _fontScale = 1.0;

  double get fontScale => _fontScale;

  FontProvider() {
    _loadFontPreference();
  }

  Future<void> _loadFontPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _fontScale = prefs.getDouble(_fontScaleKey) ?? 1.0;
    notifyListeners();
  }

  Future<void> setFontScale(double scale) async {
    final newScale = scale.clamp(minFontScale, maxFontScale).toDouble();
    if ((_fontScale - newScale).abs() < 0.001) return;
    _fontScale = newScale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontScaleKey, _fontScale);
  }
}
