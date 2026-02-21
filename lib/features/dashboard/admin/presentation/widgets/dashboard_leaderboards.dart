import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/ui/premium_pill_toggle.dart';
import 'package:gap/gap.dart';

import '../../../../../core/ui/chart_colors.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';

enum LeaderboardType { partners, recruiters, jobs }

class DashboardLeaderboardsWidget extends StatefulWidget {
  final DashboardLeaderboards leaderboards;

  const DashboardLeaderboardsWidget({super.key, required this.leaderboards});

  @override
  State<DashboardLeaderboardsWidget> createState() =>
      _DashboardLeaderboardsWidgetState();
}

class _DashboardLeaderboardsWidgetState
    extends State<DashboardLeaderboardsWidget> {
  LeaderboardType selected = LeaderboardType.partners;

  @override
  Widget build(BuildContext context) {
    final data = _getData();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Leaderboards",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        const Gap(14),

        PremiumPillToggle<LeaderboardType>(
          selected: selected,
          values: LeaderboardType.values,
          onChanged: (value) => setState(() => selected = value),

          labelBuilder: (type) {
            switch (type) {
              case LeaderboardType.partners:
                return "Partners";
              case LeaderboardType.recruiters:
                return "Recruiters";
              case LeaderboardType.jobs:
                return "Jobs";
            }
          },

          colorBuilder: (type) {
            switch (type) {
              case LeaderboardType.partners:
                return ChartColors.primary;
              case LeaderboardType.recruiters:
                return ChartColors.success;
              case LeaderboardType.jobs:
                return ChartColors.warning;
            }
          },
        ),

        const Gap(20),

        _LeaderboardChart(data: data),
      ],
    );
  }

  List<_BarData> _getData() {
    switch (selected) {
      case LeaderboardType.partners:
        return widget.leaderboards.topPartners
            .map((e) => _BarData(e.partnerName, e.applications))
            .toList();

      case LeaderboardType.recruiters:
        return widget.leaderboards.topRecruiters
            .map((e) => _BarData(e.userName, e.applications))
            .toList();

      case LeaderboardType.jobs:
        return widget.leaderboards.topJobs
            .map((e) => _BarData(e.jobTitle, e.applications))
            .toList();
    }
  }
}

////////////////////////////////////////////////////////////
/// CHART WITH PULSE GLOW
////////////////////////////////////////////////////////////

class _LeaderboardChart extends StatefulWidget {
  final List<_BarData> data;

  const _LeaderboardChart({required this.data});

  @override
  State<_LeaderboardChart> createState() => _LeaderboardChartState();
}

class _LeaderboardChartState extends State<_LeaderboardChart>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController glowController;

  late Animation<double> animation;
  late Animation<double> glowAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    animation = CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);

    glowAnimation = Tween<double>(
      begin: 1.5,
      end: 4,
    ).animate(CurvedAnimation(parent: glowController, curve: Curves.easeInOut));

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    glowController.dispose();
    super.dispose();
  }

  ////////////////////////////////////////////////////////////

  double _maxY() {
    if (widget.data.isEmpty) return 10;

    final max = widget.data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    if (max == 0) return 10;

    return max * 1.25;
  }

  double _interval(double maxY) {
    if (maxY <= 0) return 1;
    return maxY / 4;
  }

  String _shortName(String name) {
    return name.split(" ").first;
  }

  Color _glowColor(int index) {
    if (index == 0) return const Color(0xFFFFD700);
    if (index == 1) return const Color(0xFFC0C0C0);
    if (index == 2) return const Color(0xFFCD7F32);
    return Colors.transparent;
  }

  Widget _rankIcon(int index) {
    if (index == 0) {
      return const Text("🥇", style: TextStyle(fontSize: 16));
    }
    if (index == 1) {
      return const Text("🥈", style: TextStyle(fontSize: 16));
    }
    if (index == 2) {
      return const Text("🥉", style: TextStyle(fontSize: 16));
    }

    return CircleAvatar(
      radius: 10,
      backgroundColor: Colors.white.withOpacity(.08),
      child: Text(
        "${index + 1}",
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }

  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final maxY = _maxY();
    final interval = _interval(maxY);

    return Container(
      height: 320,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),

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

      child: AnimatedBuilder(
        animation: Listenable.merge([animation, glowAnimation]),
        builder: (_, __) {
          return BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceAround,

              gridData: FlGridData(
                horizontalInterval: interval,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: Colors.white.withOpacity(.06)),
              ),

              borderData: FlBorderData(show: false),

              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: interval,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(.4),
                      ),
                    ),
                  ),
                ),

                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 80,

                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();

                      if (i >= widget.data.length) {
                        return const SizedBox();
                      }

                      final item = widget.data[i];
                      final color = ChartColors.get(i);

                      return SideTitleWidget(
                        meta: meta,

                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _rankIcon(i),

                            const Gap(4),

                            CircleAvatar(
                              radius: 12,
                              backgroundColor: color.withOpacity(.15),
                              child: Text(
                                item.label[0].toUpperCase(),
                                style: TextStyle(
                                  color: color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const Gap(4),

                            SizedBox(
                              width: 60,
                              child: Text(
                                _shortName(item.label),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),

              barGroups: List.generate(widget.data.length, (i) {
                final item = widget.data[i];
                final color = ChartColors.get(i);

                final isTop = i == 0;

                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: item.value * animation.value,
                      width: 26,
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(.7)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(8),

                      borderSide: i < 3
                          ? BorderSide(
                              color: _glowColor(i).withOpacity(.7),
                              width: 2,
                            )
                          : BorderSide.none,

                      rodStackItems: isTop
                          ? [
                              BarChartRodStackItem(
                                0,
                                item.value.toDouble(),
                                color.withOpacity(.05),
                              ),
                            ]
                          : [],

                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY,
                        color: Colors.white.withOpacity(.04),
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// MODEL
////////////////////////////////////////////////////////////

class _BarData {
  final String label;
  final int value;

  _BarData(this.label, this.value);
}
