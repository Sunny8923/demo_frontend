import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:frontend/core/ui/premium_appbar.dart';

import '../../features/auth/presentation/providers/current_user_provider.dart';
import 'app_drawer.dart';

class AppScaffold extends ConsumerWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  /// center content like SaaS apps
  final bool centerContent;

  /// enable drawer
  final bool enableDrawer;

  /// optional background override
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.centerContent = true,
    this.enableDrawer = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(currentUserProvider);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      ////////////////////////////////////////////////////////////
      /// BACKGROUND (PREMIUM DEPTH)
      ////////////////////////////////////////////////////////////
      backgroundColor: backgroundColor ?? scheme.surfaceContainerLowest,

      ////////////////////////////////////////////////////////////
      /// DRAWER
      ////////////////////////////////////////////////////////////
      drawer: enableDrawer ? const AppDrawer() : null,

      ////////////////////////////////////////////////////////////
      /// PREMIUM APP BAR
      ////////////////////////////////////////////////////////////
      appBar: PremiumAppBar(title: title, actions: actions),

      ////////////////////////////////////////////////////////////
      /// BODY
      ////////////////////////////////////////////////////////////
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            Widget content = Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: body
                  .animate()
                  .fadeIn(duration: 250.ms, curve: Curves.easeOut)
                  .slideY(begin: .04, duration: 250.ms, curve: Curves.easeOut),
            );

            ////////////////////////////////////////////////////////////
            /// ONLY constrain width, don't break scroll
            ////////////////////////////////////////////////////////////

            if (centerContent) {
              content = Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: content,
                ),
              );
            }

            ////////////////////////////////////////////////////////////
            /// CRITICAL FIX: allow scrollables to expand properly
            ////////////////////////////////////////////////////////////

            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: content,
            );
          },
        ),
      ),

      ////////////////////////////////////////////////////////////
      /// FLOATING BUTTON
      ////////////////////////////////////////////////////////////
      floatingActionButton: floatingActionButton,

      ////////////////////////////////////////////////////////////
      /// PREMIUM KEYBOARD BEHAVIOR
      ////////////////////////////////////////////////////////////
      resizeToAvoidBottomInset: true,
    );
  }
}
