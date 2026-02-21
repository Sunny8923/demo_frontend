import 'package:flutter/material.dart';

////////////////////////////////////////////////////////////
/// PREMIUM SAAS PILL TOGGLE (REUSABLE)
////////////////////////////////////////////////////////////

class PremiumPillToggle<T> extends StatelessWidget {
  final T selected;
  final List<T> values;
  final ValueChanged<T> onChanged;

  final String Function(T value) labelBuilder;
  final Color Function(T value) colorBuilder;

  const PremiumPillToggle({
    super.key,
    required this.selected,
    required this.values,
    required this.onChanged,
    required this.labelBuilder,
    required this.colorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),

        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(30),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: values.map((value) {
            final isSelected = selected == value;

            final color = colorBuilder(value);

            return GestureDetector(
              onTap: () => onChanged(value),

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),

                curve: Curves.easeOutCubic,

                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),

                margin: const EdgeInsets.symmetric(horizontal: 2),

                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.transparent,

                  borderRadius: BorderRadius.circular(30),
                ),

                child: Text(
                  labelBuilder(value),

                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,

                    color: isSelected ? Colors.white : scheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
