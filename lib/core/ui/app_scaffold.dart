import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../features/auth/presentation/providers/current_user_provider.dart';
import 'app_drawer.dart';

class AppScaffold extends ConsumerWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  /// optional: center content like modern SaaS apps
  final bool centerContent;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.centerContent = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(currentUserProvider);

    final theme = Theme.of(context);

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        actions: [if (actions != null) ...actions!, const SizedBox(width: 8)],
      ),

      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: centerContent ? 900 : double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: body.animate().fadeIn(duration: 250.ms).slideY(begin: .02),
            ),
          ),
        ),
      ),

      floatingActionButton: floatingActionButton,
    );
  }
}
