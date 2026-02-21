import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/ui/premium_pill_toggle.dart';
import 'package:gap/gap.dart';
import '../../../../../core/ui/chart_colors.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';

enum TrendType { applications, hires, jobs, all }

class DashboardTrendsChart extends StatefulWidget {
  final DashboardTrends trends;

  const DashboardTrendsChart({super.key, required this.trends});

  @override
  State<DashboardTrendsChart> createState() => _DashboardTrendsChartState();
}

class _DashboardTrendsChartState extends State<DashboardTrendsChart>
    with SingleTickerProviderStateMixin {
  TrendType selected = TrendType.applications;

  int touchedIndex = -1;

  late AnimationController _controller;
  late Animation<double> _animation;

  ////////////////////////////////////////////////////////////
  /// INIT ANIMATION
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final datasets = _buildDatasets();

    final maxY = _calculateMaxY(datasets);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ////////////////////////////////////////////////////////////
        /// Header
        ////////////////////////////////////////////////////////////
        Row(
          children: [
            Text(
              "Analytics Trends",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            _AnimatedTotalCounter(
              total: _currentTotal(),
              color: _currentColor(),
            ),
          ],
        ),

        const Gap(14),

        ////////////////////////////////////////////////////////////
        /// PREMIUM TOGGLE
        ////////////////////////////////////////////////////////////
        PremiumPillToggle<TrendType>(
          selected: selected,
          values: TrendType.values,
          onChanged: (value) {
            setState(() {
              selected = value;
              touchedIndex = -1;
              _controller.reset();
              _controller.forward();
            });
          },
          labelBuilder: (type) {
            switch (type) {
              case TrendType.applications:
                return "Applications";
              case TrendType.hires:
                return "Hires";
              case TrendType.jobs:
                return "Jobs";
              case TrendType.all:
                return "All";
            }
          },
          colorBuilder: (type) {
            switch (type) {
              case TrendType.applications:
                return ChartColors.primary;
              case TrendType.hires:
                return ChartColors.success;
              case TrendType.jobs:
                return ChartColors.warning;
              case TrendType.all:
                return ChartColors.violet;
            }
          },
        ),

        const Gap(18),

        ////////////////////////////////////////////////////////////
        /// ULTRA PREMIUM CHART CONTAINER
        ////////////////////////////////////////////////////////////
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return Container(
              height: 290,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),

                gradient: const LinearGradient(
                  colors: [Color(0xff020617), Color(0xff0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.5),
                    blurRadius: 32,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),

              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: _maxX(),
                  minY: 0,
                  maxY: maxY,

                  //////////////////////////////////////////////////
                  /// TOUCH WITH VERTICAL HIGHLIGHT
                  //////////////////////////////////////////////////
                  lineTouchData: LineTouchData(
                    touchCallback: (event, response) {
                      if (response != null &&
                          response.lineBarSpots != null &&
                          response.lineBarSpots!.isNotEmpty) {
                        setState(() {
                          touchedIndex = response.lineBarSpots!.first.spotIndex;
                        });
                      }
                    },

                    getTouchedSpotIndicator: (barData, spotIndexes) {
                      return spotIndexes.map((index) {
                        final color =
                            barData.gradient?.colors.first ??
                            ChartColors.primary;

                        return TouchedSpotIndicatorData(
                          FlLine(color: color.withOpacity(.35), strokeWidth: 2),
                          FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, bar, i) =>
                                FlDotCirclePainter(
                                  radius: 6,
                                  color: color,
                                  strokeWidth: 3,
                                  strokeColor: const Color(0xff020617),
                                ),
                          ),
                        );
                      }).toList();
                    },

                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => const Color(0xff020617),

                      tooltipBorderRadius: BorderRadius.circular(14),

                      getTooltipItems: (spots) {
                        return spots.map((spot) {
                          final color =
                              spot.bar.gradient?.colors.first ??
                              ChartColors.primary;

                          return LineTooltipItem(
                            spot.y.toInt().toString(),
                            TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),

                  //////////////////////////////////////////////////
                  /// GRID
                  //////////////////////////////////////////////////
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: Colors.white.withOpacity(.05)),
                  ),

                  //////////////////////////////////////////////////
                  /// TITLES
                  //////////////////////////////////////////////////
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();

                          if (index >= widget.trends.applications.length)
                            return const SizedBox();

                          final day = widget.trends.applications[index].date
                              .substring(8, 10);

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              day,
                              style: TextStyle(
                                color: Colors.white.withOpacity(.5),
                                fontSize: 11,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),

                  borderData: FlBorderData(show: false),

                  //////////////////////////////////////////////////
                  /// DATASETS
                  //////////////////////////////////////////////////
                  lineBarsData: datasets
                      .map(
                        (e) => e.copyWith(
                          spots: e.spots
                              .map(
                                (spot) =>
                                    FlSpot(spot.x, spot.y * _animation.value),
                              )
                              .toList(),
                        ),
                      )
                      .toList(),

                  //////////////////////////////////////////////////
                  /// EXTRA LINES (VERTICAL HOVER)
                  //////////////////////////////////////////////////
                  extraLinesData: touchedIndex == -1
                      ? ExtraLinesData()
                      : ExtraLinesData(
                          verticalLines: [
                            VerticalLine(
                              x: touchedIndex.toDouble(),
                              color: Colors.white.withOpacity(.15),
                              strokeWidth: 1.5,
                              dashArray: [6, 4],
                            ),
                          ],
                        ),
                ),

                duration: const Duration(milliseconds: 250),
              ),
            );
          },
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////

  List<LineChartBarData> _buildDatasets() {
    final app = _buildLine(widget.trends.applications, ChartColors.primary);

    final hires = _buildLine(widget.trends.hires, ChartColors.success);

    final jobs = _buildLine(widget.trends.jobsCreated, ChartColors.warning);

    switch (selected) {
      case TrendType.applications:
        return [app];
      case TrendType.hires:
        return [hires];
      case TrendType.jobs:
        return [jobs];
      case TrendType.all:
        return [app, hires, jobs];
    }
  }

  ////////////////////////////////////////////////////////////

  LineChartBarData _buildLine(List<TrendPoint> data, Color color) {
    return LineChartBarData(
      spots: List.generate(
        data.length,
        (i) => FlSpot(i.toDouble(), data[i].count.toDouble()),
      ),

      isCurved: true,

      gradient: LinearGradient(colors: [color, color.withOpacity(.7)]),

      barWidth: 4,

      isStrokeCapRound: true,

      dotData: const FlDotData(show: false),

      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color.withOpacity(.25), color.withOpacity(.02)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////

  double _calculateMaxY(List<LineChartBarData> datasets) {
    double max = 0;

    for (final line in datasets) {
      for (final spot in line.spots) {
        if (spot.y > max) max = spot.y;
      }
    }

    return max + max * .25 + 1;
  }

  double _maxX() => widget.trends.applications.length - 1;

  int _currentTotal() {
    switch (selected) {
      case TrendType.applications:
        return widget.trends.applications.fold(0, (sum, e) => sum + e.count);
      case TrendType.hires:
        return widget.trends.hires.fold(0, (sum, e) => sum + e.count);
      case TrendType.jobs:
        return widget.trends.jobsCreated.fold(0, (sum, e) => sum + e.count);
      case TrendType.all:
        return widget.trends.applications.fold(0, (sum, e) => sum + e.count);
    }
  }

  Color _currentColor() {
    switch (selected) {
      case TrendType.applications:
        return ChartColors.primary;
      case TrendType.hires:
        return ChartColors.success;
      case TrendType.jobs:
        return ChartColors.warning;
      case TrendType.all:
        return ChartColors.primary;
    }
  }
}

////////////////////////////////////////////////////////////
/// Animated Counter
////////////////////////////////////////////////////////////

class _AnimatedTotalCounter extends StatelessWidget {
  final int total;
  final Color color;

  const _AnimatedTotalCounter({required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: IntTween(begin: 0, end: total),
      duration: const Duration(milliseconds: 900),
      builder: (_, value, __) {
        return Text(
          value.toString(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        );
      },
    );
  }
}
