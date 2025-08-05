import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
        maxX: (data.length - 1).toDouble(),
        minY: data.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) - 10,
        maxY: data.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 10,
      ),
    );
  }
}
