import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/ui/app_scaffold.dart';
import '../../core/router/route_names.dart';

class DashboardShell extends StatelessWidget {
  final Widget child;

  const DashboardShell({super.key, required this.child});

  ////////////////////////////////////////////////////////////
  /// 🔥 DYNAMIC TITLE BASED ON ROUTE
  ////////////////////////////////////////////////////////////

  String _getTitle(BuildContext context) {
    final path = GoRouterState.of(context).uri.toString();

    if (path.startsWith(AppRoutes.dashboard)) return "Dashboard";
    if (path.startsWith(AppRoutes.candidates)) return "Candidates";
    if (path.startsWith(AppRoutes.jobs)) return "Jobs";
    if (path.startsWith(AppRoutes.analytics)) return "Analytics";
    if (path.startsWith(AppRoutes.settings)) return "Settings";

    return "Dashboard";
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(title: _getTitle(context), body: child);
  }
}
