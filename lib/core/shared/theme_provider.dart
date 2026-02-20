import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

////////////////////////////////////////////////////////////
/// THEME MODE ENUM
////////////////////////////////////////////////////////////

enum AppThemeMode { light, dark }

////////////////////////////////////////////////////////////
/// THEME STATE MODEL
////////////////////////////////////////////////////////////

class ThemeState {
  final AppThemeMode mode;
  final Color seedColor;

  const ThemeState({required this.mode, required this.seedColor});

  ThemeState copyWith({AppThemeMode? mode, Color? seedColor}) {
    return ThemeState(
      mode: mode ?? this.mode,
      seedColor: seedColor ?? this.seedColor,
    );
  }
}

////////////////////////////////////////////////////////////
/// THEME PROVIDER
////////////////////////////////////////////////////////////

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    return const ThemeState(
      mode: AppThemeMode.light,
      seedColor: Color(0xFF2563EB), // default blue
    );
  }

  ////////////////////////////////////////////////////////////
  /// CHANGE MODE
  ////////////////////////////////////////////////////////////

  void toggleTheme() {
    state = state.copyWith(
      mode: state.mode == AppThemeMode.light
          ? AppThemeMode.dark
          : AppThemeMode.light,
    );
  }

  ////////////////////////////////////////////////////////////
  /// CHANGE PRIMARY COLOR
  ////////////////////////////////////////////////////////////

  void changeColor(Color color) {
    state = state.copyWith(seedColor: color);
  }

  ////////////////////////////////////////////////////////////
  /// SET LIGHT
  ////////////////////////////////////////////////////////////

  void setLight() {
    state = state.copyWith(mode: AppThemeMode.light);
  }

  ////////////////////////////////////////////////////////////
  /// SET DARK
  ////////////////////////////////////////////////////////////

  void setDark() {
    state = state.copyWith(mode: AppThemeMode.dark);
  }
}
