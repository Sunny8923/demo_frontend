import 'package:flutter/material.dart';

class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const PremiumAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      toolbarHeight: 72,
      automaticallyImplyLeading: true,
      title: Text(title),
      actions: actions,
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
