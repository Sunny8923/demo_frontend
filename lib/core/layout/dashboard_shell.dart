import 'package:flutter/material.dart';
import '../ui/app_drawer.dart';

class DashboardShell extends StatelessWidget {
  final Widget child;

  const DashboardShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1100;

    if (!isDesktop) {
      return Scaffold(body: child);
    }

    return Scaffold(
      body: Row(
        children: [
          const SizedBox(width: 260, child: AppDrawer()),
          Expanded(child: child),
        ],
      ),
    );
  }
}
