import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/shared/theme_provider.dart';

import 'package:frontend/features/splash/presentation/screens/splash_screen.dart';

import 'core/ui/app_theme.dart'; // ✅ ADD THIS

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// LOCK TO PORTRAIT ONLY
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  print("App started");

  runApp(const ProviderScope(child: RecruitmentDemoApp()));
}

////////////////////////////////////////////////////////////
/// ROOT APP (NOW CONSUMER WIDGET)
////////////////////////////////////////////////////////////

class RecruitmentDemoApp extends ConsumerWidget {
  const RecruitmentDemoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// WATCH THEME STATE
    final themeState = ref.watch(themeProvider);

    final isDark = themeState.mode == AppThemeMode.dark;
    final seedColor = themeState.seedColor;

    return MaterialApp(
      title: "Recruitment Demo",

      debugShowCheckedModeBanner: false,

      ////////////////////////////////////////////////////////////
      /// LIGHT THEME (DYNAMIC COLOR)
      ////////////////////////////////////////////////////////////
      theme: AppTheme.light(seedColor),

      ////////////////////////////////////////////////////////////
      /// DARK THEME (DYNAMIC COLOR)
      ////////////////////////////////////////////////////////////
      darkTheme: AppTheme.dark(seedColor),

      ////////////////////////////////////////////////////////////
      /// CURRENT MODE
      ////////////////////////////////////////////////////////////
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      ////////////////////////////////////////////////////////////
      /// HOME
      ////////////////////////////////////////////////////////////
      home: const AppStartupScreen(),
    );
  }
}
