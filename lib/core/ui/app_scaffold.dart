import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: backgroundColor ?? scheme.surfaceContainerLowest,

      ////////////////////////////////////////////////////////////
      /// DRAWER
      ////////////////////////////////////////////////////////////
      drawer: const AppDrawer(),

      ////////////////////////////////////////////////////////////
      /// APP BAR
      ////////////////////////////////////////////////////////////
      appBar: PremiumAppBar(title: title, actions: actions),

      ////////////////////////////////////////////////////////////
      /// ✅ FIX: ADD MATERIAL HERE
      ////////////////////////////////////////////////////////////
      body: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              Widget content = Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: body
                    .animate()
                    .fadeIn(duration: 250.ms)
                    .slideY(begin: .04, duration: 250.ms),
              );

              if (centerContent) {
                content = Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: content,
                  ),
                );
              }

              return SizedBox.expand(child: content);
            },
          ),
        ),
      ),

      floatingActionButton: floatingActionButton,
    );
  }
}
