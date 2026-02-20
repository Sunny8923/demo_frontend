import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';
import 'package:gap/gap.dart';

class DashboardTrendsChart extends StatelessWidget {
  final DashboardTrends trends;

  const DashboardTrendsChart({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final spots = _buildSpots(trends.applications);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ////////////////////////////////////////////////////////////
        /// Title
        ////////////////////////////////////////////////////////////
        Text(
          "Applications Trend",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const Gap(12),

        ////////////////////////////////////////////////////////////
        /// Chart container
        ////////////////////////////////////////////////////////////
        Container(
          height: 220,
          padding: const EdgeInsets.fromLTRB(12, 16, 16, 12),

          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],

            border: Border.all(color: Colors.grey.withOpacity(.08)),
          ),

          child: spots.isEmpty
              ? const Center(
                  child: Text(
                    "No trend data available",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: spots.length.toDouble() - 1,

                    minY: 0,
                    maxY: _maxY(spots),

                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(.15),
                          strokeWidth: 1,
                        );
                      },
                    ),

                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 1,
                        ),
                      ),

                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();

                            if (index < 0 ||
                                index >= trends.applications.length) {
                              return const SizedBox();
                            }

                            final date = trends.applications[index].date;

                            final day = date.substring(8, 10);

                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                day,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
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

                    borderData: FlBorderData(show: false),

                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,

                        isCurved: true,

                        barWidth: 3,

                        isStrokeCapRound: true,

                        dotData: const FlDotData(show: false),

                        belowBarData: BarAreaData(
                          show: true,
                          color: theme.colorScheme.primary.withOpacity(.15),
                        ),

                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  //////////////////////////////////////////////////////////////
  /// Convert trend points to chart spots
  //////////////////////////////////////////////////////////////

  List<FlSpot> _buildSpots(List<TrendPoint> points) {
    final List<FlSpot> spots = [];

    for (int i = 0; i < points.length; i++) {
      spots.add(FlSpot(i.toDouble(), points[i].count.toDouble()));
    }

    return spots;
  }

  //////////////////////////////////////////////////////////////
  /// Calculate max Y safely
  //////////////////////////////////////////////////////////////

  double _maxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 5;

    double max = 0;

    for (final s in spots) {
      if (s.y > max) max = s.y;
    }

    return max + 2;
  }
}
