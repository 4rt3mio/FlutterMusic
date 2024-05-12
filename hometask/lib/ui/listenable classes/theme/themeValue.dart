import 'package:flutter/material.dart';

class ThemeValue {
  ThemeValue._();

  static final curTheme = ValueNotifier<ThemeData>(ThemeData.dark());
  static final List<ThemeData> availableThemes = [ThemeData.dark(), ThemeData.light()];
  static int _currentThemeIndex = 0;

  static void nextTheme() {
    _currentThemeIndex = (_currentThemeIndex + 1) % availableThemes.length;
    curTheme.value = availableThemes[_currentThemeIndex];
  }
}