import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/ui/premium_pill_toggle.dart';
import 'package:gap/gap.dart';

import '../../../../../core/ui/chart_colors.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';

////////////////////////////////////////////////////////////
/// ENUM
////////////////////////////////////////////////////////////

enum DistributionType { source, department, jobs }

////////////////////////////////////////////////////////////
/// DATA MODEL
////////////////////////////////////////////////////////////

class DonutChartDataItem {
  final String label;
  final int value;

  const DonutChartDataItem({required this.label, required this.value});
}

////////////////////////////////////////////////////////////
/// MAIN WIDGET
////////////////////////////////////////////////////////////

class AdminDistributionChart extends StatefulWidget {
  final DashboardDistribution distribution;

  const AdminDistributionChart({super.key, required this.distribution});

  @override
  State<AdminDistributionChart> createState() => _AdminDistributionChartState();
}

class _AdminDistributionChartState extends State<AdminDistributionChart> {
  DistributionType selected = DistributionType.source;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chartData = _getChartData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ////////////////////////////////////////////////////////////
        /// HEADER
        ////////////////////////////////////////////////////////////
        Row(
          children: [
            Icon(Icons.pie_chart_outline, color: ChartColors.primary),
            const Gap(8),
            Expanded(
              child: Text(
                "Applications Distribution",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const Gap(16),

        ////////////////////////////////////////////////////////////
        /// TOGGLE
        ////////////////////////////////////////////////////////////
        PremiumPillToggle<DistributionType>(
          selected: selected,
          values: DistributionType.values,
          onChanged: (value) => setState(() => selected = value),
          labelBuilder: (type) {
            switch (type) {
              case DistributionType.source:
                return "Source";
              case DistributionType.department:
                return "Department";
              case DistributionType.jobs:
                return "Jobs";
            }
          },
          colorBuilder: (type) {
            switch (type) {
              case DistributionType.source:
                return ChartColors.primary;
              case DistributionType.department:
                return ChartColors.success;
              case DistributionType.jobs:
                return ChartColors.warning;
            }
          },
        ),

        const Gap(20),

        ////////////////////////////////////////////////////////////
        /// CONTAINER
        ////////////////////////////////////////////////////////////
        Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [Color(0xff020617), Color(0xff0F172A)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.45),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: _DistributionDonutChart(
              key: ValueKey(selected),
              data: chartData,
            ),
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////

  List<DonutChartDataItem> _getChartData() {
    switch (selected) {
      case DistributionType.source:
        return DistributionMapper.fromSource(widget.distribution);

      case DistributionType.department:
        return DistributionMapper.fromDepartment(widget.distribution);

      case DistributionType.jobs:
        return DistributionMapper.fromJobs(widget.distribution);
    }
  }
}

////////////////////////////////////////////////////////////
/// DONUT CHART
////////////////////////////////////////////////////////////

class _DistributionDonutChart extends StatefulWidget {
  final List<DonutChartDataItem> data;

  const _DistributionDonutChart({super.key, required this.data});

  @override
  State<_DistributionDonutChart> createState() =>
      _DistributionDonutChartState();
}

class _DistributionDonutChartState extends State<_DistributionDonutChart>
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
  void didUpdateWidget(covariant _DistributionDonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    touchedIndex = -1;

    controller.reset();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: Text("No data", style: TextStyle(color: Colors.white54)),
        ),
      );
    }

    final total = widget.data.fold(0, (sum, e) => sum + e.value);

    final colors = List.generate(widget.data.length, (i) => ChartColors.get(i));

    final centerValue = touchedIndex == -1
        ? total
        : widget.data[touchedIndex].value;

    final centerLabel = touchedIndex == -1
        ? "Total"
        : widget.data[touchedIndex].label;

    ////////////////////////////////////////////////////////////

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

                        final color = colors[index];

                        final isTouched = index == touchedIndex;

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
                  /// CENTER TEXT WITH ELLIPSIS
                  ////////////////////////////////////////////////////////////
                  SizedBox(
                    width: 140,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          centerValue.toString(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),

                        const Gap(4),

                        Tooltip(
                          message: centerLabel,
                          child: Text(
                            centerLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        const Gap(16),

        ////////////////////////////////////////////////////////////
        /// LEGEND WITH ELLIPSIS (FINAL FIX)
        ////////////////////////////////////////////////////////////
        Wrap(
          spacing: 16,
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
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 160),
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

                      Expanded(
                        child: Tooltip(
                          message: item.label,
                          child: Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const Gap(6),

                      Text(
                        "${item.value} ($percent%)",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// MAPPER
////////////////////////////////////////////////////////////

class DistributionMapper {
  static List<DonutChartDataItem> fromSource(
    DashboardDistribution distribution,
  ) {
    return distribution.applicationsBySource.entries
        .map(
          (e) => DonutChartDataItem(label: _capitalize(e.key), value: e.value),
        )
        .toList();
  }

  static List<DonutChartDataItem> fromDepartment(
    DashboardDistribution distribution,
  ) {
    return distribution.applicationsByDepartment
        .map(
          (e) => DonutChartDataItem(label: e.department, value: e.applications),
        )
        .toList();
  }

  static List<DonutChartDataItem> fromJobs(DashboardDistribution distribution) {
    return distribution.applicationsByJob
        .map(
          (e) => DonutChartDataItem(label: e.jobTitle, value: e.applications),
        )
        .toList();
  }

  static String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
