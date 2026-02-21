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
    final scheme = theme.colorScheme;

    final user = ref.watch(currentUserProvider).value;

    final name = user?.name ?? "Unknown User";
    final email = user?.email ?? "";
    final role = user?.role ?? "USER";
    final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : "?";

    return Drawer(
      width: 300,

      backgroundColor: scheme.surface,

      child: Column(
        children: [
          ////////////////////////////////////////////////////////////
          /// PREMIUM HEADER
          ////////////////////////////////////////////////////////////
          _DrawerHeader(
            name: name,
            email: email,
            role: role,
            firstLetter: firstLetter,
          ),

          ////////////////////////////////////////////////////////////
          /// MENU CONTAINER
          ////////////////////////////////////////////////////////////
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),

              child: Column(
                children: [
                  const Gap(8),

                  Expanded(
                    child: ListView(
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
                              MaterialPageRoute(
                                builder: (_) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),

                        const Gap(16),

                        Divider(color: scheme.outlineVariant.withOpacity(.3)),

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
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
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
                    padding: const EdgeInsets.only(bottom: 12),

                    child: Text(
                      "Version 1.0.0",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// PREMIUM HEADER
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
/// ULTRA PREMIUM DRAWER HEADER
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
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,

      ////////////////////////////////////////////////////////////
      /// OUTER GRADIENT BACKGROUND
      ////////////////////////////////////////////////////////////
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary,
            Color.lerp(scheme.primary, Colors.black, .25)!,
            Color.lerp(scheme.primary, Colors.black, .45)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: Stack(
        children: [
          ////////////////////////////////////////////////////////////
          /// DECORATIVE ORB
          ////////////////////////////////////////////////////////////
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 140,
              height: 140,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(.12), Colors.transparent],
                ),
              ),
            ),
          ),

          ////////////////////////////////////////////////////////////
          /// CONTENT
          ////////////////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                child: Container(
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.08),

                    borderRadius: BorderRadius.circular(20),

                    border: Border.all(color: Colors.white.withOpacity(.15)),
                  ),

                  child: Row(
                    children: [
                      ////////////////////////////////////////////////////
                      /// PREMIUM AVATAR WITH GLOW RING
                      ////////////////////////////////////////////////////
                      Container(
                        padding: const EdgeInsets.all(3),

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(.9),
                              Colors.white.withOpacity(.2),
                            ],
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(.25),
                              blurRadius: 16,
                            ),
                          ],
                        ),

                        child: CircleAvatar(
                          radius: 28,

                          backgroundColor: Colors.black.withOpacity(.35),

                          child: Text(
                            firstLetter,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const Gap(14),

                      ////////////////////////////////////////////////////
                      /// USER INFO
                      ////////////////////////////////////////////////////
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),

                            const Gap(3),

                            Text(
                              email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(.75),
                              ),
                            ),

                            const Gap(8),

                            ////////////////////////////////////////////////////
                            /// ROLE BADGE
                            ////////////////////////////////////////////////////
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),

                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(.25),
                                    Colors.white.withOpacity(.1),
                                  ],
                                ),

                                borderRadius: BorderRadius.circular(20),

                                border: Border.all(
                                  color: Colors.white.withOpacity(.25),
                                ),
                              ),

                              child: Text(
                                role,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -.15);
  }
}
////////////////////////////////////////////////////////////
/// MODERN ITEM
////////////////////////////////////////////////////////////

class _ModernDrawerItem extends StatefulWidget {
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
  State<_ModernDrawerItem> createState() => _ModernDrawerItemState();
}

class _ModernDrawerItemState extends State<_ModernDrawerItem> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final color = widget.isDestructive ? scheme.error : scheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: MouseRegion(
        onEnter: (_) => setState(() => hovered = true),
        onExit: (_) => setState(() => hovered = false),

        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: widget.onTap,

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),

            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),

              color: hovered
                  ? scheme.primary.withOpacity(.08)
                  : Colors.transparent,
            ),

            child: Row(
              children: [
                ////////////////////////////////////////////////////
                /// ICON CONTAINER
                ////////////////////////////////////////////////////
                Container(
                  padding: const EdgeInsets.all(8),

                  decoration: BoxDecoration(
                    color: hovered
                        ? scheme.primary.withOpacity(.12)
                        : scheme.surfaceContainerHighest,

                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Icon(widget.icon, size: 20, color: color),
                ),

                const Gap(14),

                Expanded(
                  child: Text(
                    widget.title,

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
