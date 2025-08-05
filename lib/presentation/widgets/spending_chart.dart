import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SpendingChart extends StatelessWidget {
  final List<FlSpot> data;

  const SpendingChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data to display',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: true,
            color: Colors.green[600],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.green[600]!,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green[600]!.withOpacity(0.1),
            ),
          ),
        ],
        minX: 0,
        maxX: data.isNotEmpty ? (data.length - 1).toDouble() : 1,
        minY: 0,
        maxY:
            data.isNotEmpty
                ? data.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.2
                : 100,
      ),
    );
  }

  double _getHorizontalInterval() {
    if (data.isEmpty) return 20;
    final maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    if (maxY <= 50) return 10;
    if (maxY <= 200) return 50;
    if (maxY <= 500) return 100;
    return 200;
  }
}
