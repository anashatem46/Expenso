import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../logic/bloc/expense_bloc.dart';
import '../../logic/bloc/expense_state.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedPeriod = 2; // 0: Day, 1: Week, 2: Month, 3: Year
  bool _showExpenses = true; // true: Expenses, false: Income
  int _selectedChartIndex = -1;

  final List<String> _periods = ['Day', 'Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Statistics',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.black87),
                onPressed: () {
                  // TODO: Implement share functionality
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildPeriodSelector(),
                _buildExpenseIncomeToggle(),
                _buildChart(state),
                _buildTopSpending(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children:
            _periods.asMap().entries.map((entry) {
              final index = entry.key;
              final period = entry.value;
              final isSelected = index == _selectedPeriod;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPeriod = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal[600] : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        period,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildExpenseIncomeToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _showExpenses ? 'Expense' : 'Income',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showExpenses = !_showExpenses;
                    });
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(ExpenseState state) {
    final chartData = _getChartData(state);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child:
          chartData.isEmpty
              ? Center(
                child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              )
              : LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _getYAxisInterval(chartData),
                    getDrawingHorizontalLine: (value) {
                      return FlLine(color: Colors.grey[200]!, strokeWidth: 1);
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: _getYAxisInterval(chartData),
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${(value / 1000).toStringAsFixed(0)}K',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          );
                        },
                        reservedSize: 50,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final months = [
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                          ];
                          final index = value.toInt();
                          if (index >= 0 && index < months.length) {
                            return Text(
                              months[index],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData,
                      isCurved: true,
                      color: Colors.teal[600],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          final isSelected = index == _selectedChartIndex;
                          return FlDotCirclePainter(
                            radius: isSelected ? 6 : 4,
                            color:
                                isSelected
                                    ? Colors.teal[700]!
                                    : Colors.teal[600]!,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.teal[600]!.withOpacity(0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchCallback: (
                      FlTouchEvent event,
                      LineTouchResponse? touchResponse,
                    ) {
                      if (touchResponse != null &&
                          touchResponse.lineBarSpots != null) {
                        setState(() {
                          _selectedChartIndex =
                              touchResponse.lineBarSpots!.first.spotIndex;
                        });
                      }
                    },
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.teal[600]!,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          return LineTooltipItem(
                            '\$${(barSpot.y / 1000).toStringAsFixed(1)}K',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  minX: 0,
                  maxX: (chartData.length - 1).toDouble(),
                  minY: 0,
                  maxY:
                      chartData.isNotEmpty
                          ? chartData
                                  .map((e) => e.y)
                                  .reduce((a, b) => a > b ? a : b) *
                              1.2
                          : 1000,
                ),
              ),
    );
  }

  Widget _buildTopSpending(ExpenseState state) {
    final topSpending = _getTopSpending(state);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Spending',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Icon(Icons.sort, color: Colors.grey[600], size: 20),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: topSpending.length,
          itemBuilder: (context, index) {
            final item = topSpending[index];
            final isLast = index == topSpending.length - 1;

            return Container(
              margin: EdgeInsets.only(bottom: isLast ? 20 : 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    index == topSpending.length - 1
                        ? Colors.teal[600]
                        : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildCategoryIcon(item['category'], isLast),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isLast ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['date'],
                          style: TextStyle(
                            fontSize: 14,
                            color: isLast ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '- \$${item['amount'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isLast ? Colors.white : Colors.red[600],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryIcon(String category, bool isWhite) {
    Color backgroundColor;
    Widget icon;

    switch (category.toLowerCase()) {
      case 'coffee':
        backgroundColor =
            isWhite ? Colors.white.withOpacity(0.2) : Colors.green[100]!;
        icon = Text(
          '☕',
          style: TextStyle(fontSize: 24, color: isWhite ? Colors.white : null),
        );
        break;
      case 'transfer':
        backgroundColor =
            isWhite ? Colors.white.withOpacity(0.2) : Colors.blue[100]!;
        icon = Icon(
          Icons.person,
          color: isWhite ? Colors.white : Colors.blue[600]!,
          size: 24,
        );
        break;
      default:
        backgroundColor =
            isWhite ? Colors.white.withOpacity(0.2) : Colors.grey[100]!;
        icon = Text(
          '📝',
          style: TextStyle(fontSize: 24, color: isWhite ? Colors.white : null),
        );
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: icon),
    );
  }

  List<FlSpot> _getChartData(ExpenseState state) {
    // Mock data for the chart - replace with actual calculation
    return [
      const FlSpot(0, 1230),
      const FlSpot(1, 1100),
      const FlSpot(2, 1400),
      const FlSpot(3, 1000),
      const FlSpot(4, 1300),
      const FlSpot(5, 1200),
      const FlSpot(6, 1500),
    ];
  }

  double _getYAxisInterval(List<FlSpot> data) {
    if (data.isEmpty) return 500;
    final maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return maxY / 4;
  }

  List<Map<String, dynamic>> _getTopSpending(ExpenseState state) {
    // Mock data - replace with actual calculation from state
    return [
      {
        'category': 'coffee',
        'name': 'Starbucks',
        'date': 'Jan 12, 2022',
        'amount': 150.00,
      },
      {
        'category': 'transfer',
        'name': 'Transfer',
        'date': 'Jan 10, 2022',
        'amount': 85.00,
      },
    ];
  }
}
