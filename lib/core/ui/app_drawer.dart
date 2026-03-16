import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/route_names.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/auth/presentation/providers/current_user_provider.dart';

////////////////////////////////////////////////////////////
/// ROUTE ENUM
////////////////////////////////////////////////////////////

enum DrawerRoute {
  dashboard,
  jobs,
  applications,
  candidates,
  partners,
  recruiters,
  analytics,
  profile,
  settings,
  logout,
}

////////////////////////////////////////////////////////////
/// MENU MODEL
////////////////////////////////////////////////////////////

class DrawerMenuItem {
  final String title;
  final IconData icon;
  final DrawerRoute route;
  final bool destructive;

  const DrawerMenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.destructive = false,
  });
}

////////////////////////////////////////////////////////////
/// APP DRAWER
////////////////////////////////////////////////////////////

class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({super.key});

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  DrawerRoute activeRoute = DrawerRoute.dashboard;

  ////////////////////////////////////////////////////////////
  /// ROLE MENU BUILDER
  ////////////////////////////////////////////////////////////

  List<DrawerMenuItem> _menu(String role) {
    switch (role.toUpperCase()) {
      case "ADMIN":
        return const [
          DrawerMenuItem(
            title: "Dashboard",
            icon: Icons.dashboard_rounded,
            route: DrawerRoute.dashboard,
          ),
          DrawerMenuItem(
            title: "Jobs",
            icon: Icons.work_outline,
            route: DrawerRoute.jobs,
          ),
          DrawerMenuItem(
            title: "Applications",
            icon: Icons.assignment_outlined,
            route: DrawerRoute.applications,
          ),
          DrawerMenuItem(
            title: "Partners",
            icon: Icons.handshake_outlined,
            route: DrawerRoute.partners,
          ),
          DrawerMenuItem(
            title: "Recruiters",
            icon: Icons.groups_outlined,
            route: DrawerRoute.recruiters,
          ),
          DrawerMenuItem(
            title: "Analytics",
            icon: Icons.analytics_outlined,
            route: DrawerRoute.analytics,
          ),
          DrawerMenuItem(
            title: "Settings",
            icon: Icons.settings,
            route: DrawerRoute.settings,
          ),
          DrawerMenuItem(
            title: "Logout",
            icon: Icons.logout,
            route: DrawerRoute.logout,
            destructive: true,
          ),
        ];

      case "PARTNER":
        return const [
          DrawerMenuItem(
            title: "Dashboard",
            icon: Icons.dashboard,
            route: DrawerRoute.dashboard,
          ),
          DrawerMenuItem(
            title: "Jobs",
            icon: Icons.work_outline,
            route: DrawerRoute.jobs,
          ),
          DrawerMenuItem(
            title: "My Submissions",
            icon: Icons.assignment_outlined,
            route: DrawerRoute.applications,
          ),
          DrawerMenuItem(
            title: "Candidates",
            icon: Icons.people_outline,
            route: DrawerRoute.candidates,
          ),
          DrawerMenuItem(
            title: "Analytics",
            icon: Icons.analytics_outlined,
            route: DrawerRoute.analytics,
          ),
          DrawerMenuItem(
            title: "Settings",
            icon: Icons.settings,
            route: DrawerRoute.settings,
          ),
          DrawerMenuItem(
            title: "Logout",
            icon: Icons.logout,
            route: DrawerRoute.logout,
            destructive: true,
          ),
        ];

      case "RECRUITER":
        return const [
          DrawerMenuItem(
            title: "Dashboard",
            icon: Icons.dashboard,
            route: DrawerRoute.dashboard,
          ),
          DrawerMenuItem(
            title: "Candidates",
            icon: Icons.people_outline,
            route: DrawerRoute.candidates,
          ),
          DrawerMenuItem(
            title: "Applications",
            icon: Icons.assignment_outlined,
            route: DrawerRoute.applications,
          ),
          DrawerMenuItem(
            title: "Analytics",
            icon: Icons.analytics_outlined,
            route: DrawerRoute.analytics,
          ),
          DrawerMenuItem(
            title: "Settings",
            icon: Icons.settings,
            route: DrawerRoute.settings,
          ),
          DrawerMenuItem(
            title: "Logout",
            icon: Icons.logout,
            route: DrawerRoute.logout,
            destructive: true,
          ),
        ];

      default:
        return const [
          DrawerMenuItem(
            title: "Dashboard",
            icon: Icons.dashboard,
            route: DrawerRoute.dashboard,
          ),
          DrawerMenuItem(
            title: "Jobs",
            icon: Icons.work_outline,
            route: DrawerRoute.jobs,
          ),
          DrawerMenuItem(
            title: "My Applications",
            icon: Icons.assignment_outlined,
            route: DrawerRoute.applications,
          ),
          DrawerMenuItem(
            title: "Profile",
            icon: Icons.person_outline,
            route: DrawerRoute.profile,
          ),
          DrawerMenuItem(
            title: "Settings",
            icon: Icons.settings,
            route: DrawerRoute.settings,
          ),
          DrawerMenuItem(
            title: "Logout",
            icon: Icons.logout,
            route: DrawerRoute.logout,
            destructive: true,
          ),
        ];
    }
  }

  ////////////////////////////////////////////////////////////
  /// NAVIGATION HANDLER
  ////////////////////////////////////////////////////////////

  Future<void> _handleNavigation(DrawerMenuItem item) async {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }

    setState(() {
      activeRoute = item.route;
    });

    switch (item.route) {
      ////////////////////////////////////////////////////////////
      /// DASHBOARD
      ////////////////////////////////////////////////////////////

      case DrawerRoute.dashboard:
        context.go(AppRoutes.dashboard);
        break;

      ////////////////////////////////////////////////////////////
      /// JOBS
      ////////////////////////////////////////////////////////////

      case DrawerRoute.jobs:
        context.go(AppRoutes.jobs);
        break;

      ////////////////////////////////////////////////////////////
      /// APPLICATIONS
      ////////////////////////////////////////////////////////////

      case DrawerRoute.applications:
        context.go(AppRoutes.applications);
        break;

      ////////////////////////////////////////////////////////////
      /// CANDIDATES
      ////////////////////////////////////////////////////////////

      case DrawerRoute.candidates:
        context.go(AppRoutes.candidates);
        break;

      ////////////////////////////////////////////////////////////
      /// PARTNERS
      ////////////////////////////////////////////////////////////

      case DrawerRoute.partners:
        context.go(AppRoutes.partners);
        break;

      ////////////////////////////////////////////////////////////
      /// RECRUITERS
      ////////////////////////////////////////////////////////////

      case DrawerRoute.recruiters:
        context.go(AppRoutes.recruiters);
        break;

      ////////////////////////////////////////////////////////////
      /// ANALYTICS
      ////////////////////////////////////////////////////////////

      case DrawerRoute.analytics:
        context.go(AppRoutes.analytics);
        break;

      ////////////////////////////////////////////////////////////
      /// PROFILE
      ////////////////////////////////////////////////////////////

      case DrawerRoute.profile:
        context.go(AppRoutes.profile);
        break;

      ////////////////////////////////////////////////////////////
      /// SETTINGS
      ////////////////////////////////////////////////////////////

      case DrawerRoute.settings:
        context.go(AppRoutes.settings);
        break;

      ////////////////////////////////////////////////////////////
      /// LOGOUT
      ////////////////////////////////////////////////////////////

      case DrawerRoute.logout:
        await ref.read(authStateProvider.notifier).logout();

        if (!mounted) return;

        context.go(AppRoutes.login);
        break;
    }
  }

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;

    final scheme = Theme.of(context).colorScheme;

    final name = user?.name ?? "User";
    final email = user?.email ?? "";
    final role = user?.role ?? "USER";

    final items = _menu(role);

    return Drawer(
      backgroundColor: scheme.surface,

      child: Column(
        children: [
          if (MediaQuery.of(context).size.width < 1100)
            _Header(name: name, email: email, role: role)
          else
            _DesktopSidebarHeader(),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),

              children: [
                const Gap(12),

                for (final item in items)
                  _DrawerItem(
                    item: item,
                    active: item.route == activeRoute,
                    onTap: () => _handleNavigation(item),
                  ),

                const Gap(16),

                Divider(color: scheme.outlineVariant),

                const Gap(8),

                Center(
                  child: Text(
                    "Version 1.0.0",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),

                const Gap(12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// HEADER
////////////////////////////////////////////////////////////

class _Header extends StatelessWidget {
  final String name;
  final String email;
  final String role;

  const _Header({required this.name, required this.email, required this.role});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.primary.withOpacity(.85)],
        ),
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white.withOpacity(.15),
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const Gap(12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  email,
                  style: TextStyle(color: Colors.white.withOpacity(.8)),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.2),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    role,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -.2);
  }
}

class _DesktopSidebarHeader extends StatelessWidget {
  const _DesktopSidebarHeader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 72,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Admin Panel",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: scheme.onSurface,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// DRAWER ITEM
////////////////////////////////////////////////////////////

class _DrawerItem extends StatefulWidget {
  final DrawerMenuItem item;
  final bool active;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.item,
    required this.active,
    required this.onTap,
  });

  @override
  State<_DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<_DrawerItem> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final color = widget.item.destructive
        ? scheme.error
        : widget.active
        ? scheme.primary
        : scheme.onSurface;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),

      margin: const EdgeInsets.symmetric(vertical: 4),

      decoration: BoxDecoration(
        color: widget.active
            ? scheme.primary.withOpacity(.12)
            : hover
            ? scheme.primary.withOpacity(.06)
            : Colors.transparent,

        borderRadius: BorderRadius.circular(14),
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(14),

        onTap: widget.onTap,

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Row(
            children: [
              Icon(widget.item.icon, color: color),

              const Gap(14),

              Text(
                widget.item.title,
                style: TextStyle(
                  color: color,
                  fontWeight: widget.active ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: -.1);
  }
}
