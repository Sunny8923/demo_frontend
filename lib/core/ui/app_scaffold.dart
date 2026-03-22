import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/core/ui/app_sidebar.dart';

import 'premium_appbar.dart';
import 'app_drawer.dart';

class AppScaffold extends ConsumerWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  final bool centerContent;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.centerContent = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width > 1100;

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: body
          .animate()
          .fadeIn(duration: 250.ms)
          .slideY(begin: .04, duration: 250.ms),
    );

    return Scaffold(
      backgroundColor: backgroundColor ?? scheme.surfaceContainerLowest,

      ////////////////////////////////////////////////////////////
      /// 🔥 FIX: WRAP EVERYTHING IN SAFEAREA
      ////////////////////////////////////////////////////////////
      body: SafeArea(
        child: Row(
          children: [
            ////////////////////////////////////////////////////
            /// SIDEBAR
            ////////////////////////////////////////////////////
            if (isDesktop)
              const SizedBox(
                width: 260,
                child: AppDrawer(), // no extra Material needed
              ),

            ////////////////////////////////////////////////////
            /// RIGHT SIDE
            ////////////////////////////////////////////////////
            Expanded(
              child: Column(
                children: [
                  ////////////////////////////////////////////////////
                  /// APP BAR
                  ////////////////////////////////////////////////////
                  PremiumAppBar(title: title, actions: actions),

                  ////////////////////////////////////////////////////
                  /// BODY
                  ////////////////////////////////////////////////////
                  Expanded(
                    child: Material(color: Colors.transparent, child: content),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      ////////////////////////////////////////////////////////////
      /// MOBILE (ignore for now)
      ////////////////////////////////////////////////////////////
      drawer: !isDesktop ? const Drawer(child: AppDrawer()) : null,

      floatingActionButton: floatingActionButton,
    );
  }
}
