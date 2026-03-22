import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'core/router/app_router.dart';
import 'core/shared/theme_provider.dart';
import 'core/ui/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ////////////////////////////////////////////////////////////
  /// 🔥 GLOBAL DEBUG LOGGER
  ////////////////////////////////////////////////////////////
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null) {
      print("🧭 $message");
    }
  };

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  runApp(const ProviderScope(child: RecruitmentDemoApp()));
}

class RecruitmentDemoApp extends ConsumerWidget {
  const RecruitmentDemoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    final isDark = themeState.mode == AppThemeMode.dark;
    final seedColor = themeState.seedColor;

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
      child: MaterialApp.router(
        routerConfig: ref.watch(routerProvider),
        title: "Recruitment Demo",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(seedColor),
        darkTheme: AppTheme.dark(seedColor),
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
