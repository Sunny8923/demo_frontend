import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/features/settings/settings_screen.dart';
import 'package:gap/gap.dart';

import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/auth/presentation/providers/current_user_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider).value;

    final name = user?.name ?? "Unknown User";
    final email = user?.email ?? "";
    final role = user?.role ?? "USER";
    final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : "?";

    return Drawer(
      width: 300,

      child: Column(
        children: [
          ////////////////////////////////////////////////////////////
          /// MODERN GRADIENT HEADER
          ////////////////////////////////////////////////////////////
          _DrawerHeader(
            name: name,
            email: email,
            role: role,
            firstLetter: firstLetter,
          ),

          ////////////////////////////////////////////////////////////
          /// MENU
          ////////////////////////////////////////////////////////////
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),

              children: [
                _ModernDrawerItem(
                  icon: Icons.dashboard_rounded,
                  title: "Dashboard",
                  onTap: () => Navigator.pop(context),
                ),

                _ModernDrawerItem(
                  icon: Icons.person_outline_rounded,
                  title: "Profile",
                  onTap: () => Navigator.pop(context),
                ),

                _ModernDrawerItem(
                  icon: Icons.settings_rounded,
                  title: "Settings",
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),

                const Gap(20),

                Divider(color: Colors.grey.withOpacity(.2), thickness: 1),

                const Gap(10),

                _ModernDrawerItem(
                  icon: Icons.logout_rounded,
                  title: "Logout",
                  isDestructive: true,

                  onTap: () async {
                    await ref.read(authStateProvider.notifier).logout();

                    if (!context.mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                    );
                  },
                ),
              ],
            ),
          ),

          ////////////////////////////////////////////////////////////
          /// FOOTER
          ////////////////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.all(12),

            child: Text(
              "Version 1.0.0",
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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

class _DrawerHeader extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final String firstLetter;

  const _DrawerHeader({
    required this.name,
    required this.email,
    required this.role,
    required this.firstLetter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(.75),
          ],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ////////////////////////////////////////////////////////////
          /// AVATAR WITH GLASS EFFECT
          ////////////////////////////////////////////////////////////
          ClipRRect(
            borderRadius: BorderRadius.circular(40),

            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

              child: Container(
                width: 56,
                height: 56,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.15),
                  shape: BoxShape.circle,

                  border: Border.all(color: Colors.white.withOpacity(.3)),
                ),

                alignment: Alignment.center,

                child: Text(
                  firstLetter,

                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const Gap(14),

          ////////////////////////////////////////////////////////////
          /// NAME
          ////////////////////////////////////////////////////////////
          Text(
            name,

            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const Gap(4),

          ////////////////////////////////////////////////////////////
          /// EMAIL
          ////////////////////////////////////////////////////////////
          Text(
            email,

            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(.85),
            ),
          ),

          const Gap(10),

          ////////////////////////////////////////////////////////////
          /// ROLE BADGE
          ////////////////////////////////////////////////////////////
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              role,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -.2);
  }
}

////////////////////////////////////////////////////////////
/// MODERN ITEM
////////////////////////////////////////////////////////////

class _ModernDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ModernDrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(14),

          onTap: onTap,

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

            child: Row(
              children: [
                Icon(icon, size: 22, color: color),

                const Gap(14),

                Expanded(
                  child: Text(
                    title,

                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: -.1);
  }
}
