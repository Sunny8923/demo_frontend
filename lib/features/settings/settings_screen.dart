import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/shared/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  ////////////////////////////////////////////////////////////
  /// AVAILABLE COLORS
  ////////////////////////////////////////////////////////////

  static const List<Color> themeColors = [
    Color(0xFF2563EB), // Blue
    Color(0xFF16A34A), // Green
    Color(0xFFDC2626), // Red
    Color(0xFF9333EA), // Purple
    Color(0xFFEA580C), // Orange
    Color(0xFF0891B2), // Cyan
    Color(0xFFDB2777), // Pink
    Color(0xFF4F46E5), // Indigo
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);

    final isDark = themeState.mode == AppThemeMode.dark;
    final currentColor = themeState.seedColor;

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          ////////////////////////////////////////////////////////////
          /// THEME MODE SECTION
          ////////////////////////////////////////////////////////////
          Text(
            "Appearance",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: SwitchListTile(
              title: const Text("Dark Mode"),
              subtitle: const Text("Enable dark theme"),
              value: isDark,
              onChanged: (_) {
                notifier.toggleTheme();
              },
            ),
          ),

          const SizedBox(height: 24),

          ////////////////////////////////////////////////////////////
          /// COLOR SECTION
          ////////////////////////////////////////////////////////////
          Text(
            "Theme Color",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Wrap(
                spacing: 12,
                runSpacing: 12,

                children: themeColors.map((color) {
                  final isSelected = color.value == currentColor.value;

                  return GestureDetector(
                    onTap: () {
                      notifier.changeColor(color);
                    },

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),

                      width: 44,
                      height: 44,

                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.onSurface
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),

                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
