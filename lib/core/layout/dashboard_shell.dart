import 'package:flutter/material.dart';
import 'package:frontend/core/ui/app_sidebar.dart';
import '../ui/app_drawer.dart';

class DashboardShell extends StatelessWidget {
  final Widget child;

  const DashboardShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1100;

    if (!isDesktop) {
      return Scaffold(drawer: const AppDrawer(), body: child);
    }

    return Scaffold(
      body: Row(
        children: [
          const AppSidebar(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
