import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:system_theme/system_theme.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

enum NavigationIndicators { sticky, end }

class AppTheme {
  AccentColor _color = systemAccentColor;
  AccentColor get color => _color;
  set color(AccentColor color) {
    _color = color;
  }

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  set mode(ThemeMode mode) {
    _mode = mode;
  }

  PaneDisplayMode _displayMode = PaneDisplayMode.compact;
  PaneDisplayMode get displayMode => _displayMode;
  set displayMode(PaneDisplayMode displayMode) {
    _displayMode = displayMode;
  }

  NavigationIndicators _indicator = NavigationIndicators.sticky;
  NavigationIndicators get indicator => _indicator;
  set indicator(NavigationIndicators indicator) {
    _indicator = indicator;
  }

  WindowEffect _windowEffect = WindowEffect.disabled;
  WindowEffect get windowEffect => _windowEffect;
  set windowEffect(WindowEffect windowEffect) {
    _windowEffect = windowEffect;
  }

  void setEffect(WindowEffect effect, BuildContext context) {
    Window.setEffect(
      effect: effect,
      color: [
        WindowEffect.solid,
        WindowEffect.acrylic,
      ].contains(effect)
          ? FluentTheme.of(context).micaBackgroundColor.withOpacity(0.05)
          : Colors.transparent,
      dark: FluentTheme.of(context).brightness.isDark,
    );
  }

  TextDirection _textDirection = TextDirection.ltr;
  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection direction) {
    _textDirection = direction;
  }

  Locale? _locale;
  Locale? get locale => _locale;
  set locale(Locale? locale) {
    _locale = locale;
  }

  static AccentColor get systemAccentColor {
    if ((defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.android) &&
        !kIsWeb) {
      return AccentColor.swatch({
        'darkest': SystemTheme.accentColor.darkest,
        'darker': SystemTheme.accentColor.darker,
        'dark': SystemTheme.accentColor.dark,
        'normal': SystemTheme.accentColor.accent,
        'light': SystemTheme.accentColor.light,
        'lighter': SystemTheme.accentColor.lighter,
        'lightest': SystemTheme.accentColor.lightest,
      });
    }
    return Colors.blue;
  }
}
