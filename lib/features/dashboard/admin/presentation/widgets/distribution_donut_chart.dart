import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../core/ui/chart_colors.dart';

class DonutChartDataItem {
  final String label;
  final int value;

  const DonutChartDataItem({required this.label, required this.value});
}

class DistributionDonutChart extends StatefulWidget {
  final List<DonutChartDataItem> data;

  const DistributionDonutChart({super.key, required this.data});

  @override
  State<DistributionDonutChart> createState() => _DistributionDonutChartState();
}

class _DistributionDonutChartState extends State<DistributionDonutChart>
    with SingleTickerProviderStateMixin {
  int touchedIndex = -1;

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.data.isEmpty) {
      return const SizedBox(height: 240);
    }

    final total = widget.data.fold(0, (sum, e) => sum + e.value);

    final colors = List.generate(widget.data.length, (i) => ChartColors.get(i));

    final centerValue = touchedIndex == -1
        ? total
        : widget.data[touchedIndex].value;

    final centerLabel = touchedIndex == -1
        ? "Total"
        : widget.data[touchedIndex].label;

    return Column(
      children: [
        ////////////////////////////////////////////////////////////
        /// CHART
        ////////////////////////////////////////////////////////////
        SizedBox(
          height: 240,
          child: AnimatedBuilder(
            animation: animation,
            builder: (_, __) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      startDegreeOffset: -90,
                      centerSpaceRadius: 70,
                      sectionsSpace: 3,

                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          if (response == null ||
                              response.touchedSection == null) {
                            setState(() => touchedIndex = -1);
                            return;
                          }

                          setState(() {
                            touchedIndex =
                                response.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),

                      sections: List.generate(widget.data.length, (index) {
                        final item = widget.data[index];

                        final isTouched = index == touchedIndex;

                        final color = colors[index];

                        return PieChartSectionData(
                          value: item.value * animation.value,

                          radius: isTouched ? 44 : 36,

                          showTitle: false,

                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(.7)],
                          ),

                          borderSide: BorderSide(
                            color: color.withOpacity(.4),
                            width: isTouched ? 4 : 2,
                          ),
                        );
                      }),
                    ),
                  ),

                  ////////////////////////////////////////////////////////////
                  /// CENTER TEXT
                  ////////////////////////////////////////////////////////////
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        centerValue.toString(),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        centerLabel,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),

        const Gap(16),

        ////////////////////////////////////////////////////////////
        /// LEGEND (FIXED VISIBILITY)
        ////////////////////////////////////////////////////////////
        Wrap(
          spacing: 20,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: List.generate(widget.data.length, (index) {
            final item = widget.data[index];

            final percent = (item.value / total * 100).toStringAsFixed(1);

            final isActive = touchedIndex == -1 || touchedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  touchedIndex = touchedIndex == index ? -1 : index;
                });
              },

              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),

                opacity: isActive ? 1 : .4,

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors[index],
                      ),
                    ),

                    const Gap(8),

                    Text(
                      item.label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Gap(6),

                    Text(
                      "${item.value} ($percent%)",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
