import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/shared/theme_provider.dart';
import 'core/ui/app_theme.dart';

import 'features/splash/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: RecruitmentDemoApp()));
}

////////////////////////////////////////////////////////////
/// ROOT APP
////////////////////////////////////////////////////////////

class RecruitmentDemoApp extends ConsumerWidget {
  const RecruitmentDemoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    final isDark = themeState.mode == AppThemeMode.dark;
    final seedColor = themeState.seedColor;

    ////////////////////////////////////////////////////////////
    /// SYSTEM UI OVERLAY (CRITICAL FOR PREMIUM LOOK)
    ////////////////////////////////////////////////////////////

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,

        systemNavigationBarColor: isDark
            ? const Color(0xFF020617)
            : const Color(0xFFF8FAFC),

        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: MaterialApp(
        title: "Recruitment Demo",

        debugShowCheckedModeBanner: false,

        ////////////////////////////////////////////////////////////
        /// LIGHT THEME
        ////////////////////////////////////////////////////////////
        theme: AppTheme.light(seedColor),

        ////////////////////////////////////////////////////////////
        /// DARK THEME
        ////////////////////////////////////////////////////////////
        darkTheme: AppTheme.dark(seedColor),

        ////////////////////////////////////////////////////////////
        /// MODE
        ////////////////////////////////////////////////////////////
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

        ////////////////////////////////////////////////////////////
        /// START SCREEN
        ////////////////////////////////////////////////////////////
        home: const AppStartupScreen(),
      ),
    );
  }
}
