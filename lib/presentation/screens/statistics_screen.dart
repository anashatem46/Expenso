import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../logic/bloc/expense_bloc.dart';
import '../../logic/bloc/expense_state.dart';
import '../../data/models/expense.dart';

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
                  _shareStatistics();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildPeriodSelector(),
                _buildExpenseIncomeToggle(),
                _buildSummaryCards(state),
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showExpenses = !_showExpenses;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _showExpenses ? Colors.red[50] : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Expense',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                            _showExpenses ? Colors.red[600] : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showExpenses = !_showExpenses;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          !_showExpenses
                              ? Colors.green[50]
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Income',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                            !_showExpenses
                                ? Colors.green[600]
                                : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(ExpenseState state) {
    final expenses =
        _showExpenses
            ? state.expenses.where((e) => e.amount < 0).toList()
            : state.expenses.where((e) => e.amount > 0).toList();

    final total = expenses.fold<double>(0, (sum, e) => sum + e.amount.abs());
    final average = expenses.isNotEmpty ? total / expenses.length : 0.0;
    final count = expenses.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total',
              '£${total.toStringAsFixed(0)}',
              _showExpenses ? Colors.red[600]! : Colors.green[600]!,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Average',
              '£${average.toStringAsFixed(0)}',
              Colors.grey[600]!,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Count',
              count.toString(),
              Colors.teal[600]!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
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
      padding: const EdgeInsets.fromLTRB(
        24,
        24,
        24,
        40,
      ), // Much more bottom padding
      height: 380, // Much more height
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
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              _formatYAxisLabel(value),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                        reservedSize: 60,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          final label = _getChartLabel(index);
                          if (label != null) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Transform.rotate(
                                angle: _getRotationAngle(),
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: _getFontSize(),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                        reservedSize: _getBottomReservedSize(),
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
                      if (event is FlTapUpEvent || event is FlPanEndEvent) {
                        setState(() {
                          _selectedChartIndex = -1;
                        });
                      } else if (touchResponse != null &&
                          touchResponse.lineBarSpots != null) {
                        setState(() {
                          _selectedChartIndex =
                              touchResponse.lineBarSpots!.first.spotIndex;
                        });
                      }
                    },
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.teal[600]!,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: const EdgeInsets.all(8),
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final label = _getChartLabel(barSpot.x.toInt());
                          return LineTooltipItem(
                            '${label ?? ''}\n£${barSpot.y.toStringAsFixed(0)}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  minX: 0,
                  maxX: (chartData.length - 1).toDouble(),
                  minY: 0, // Back to 0 for proper Y-axis display
                  maxY: _getChartMaxY(chartData),
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
                    '${_showExpenses ? '-' : '+'} £${item['amount'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          isLast
                              ? Colors.white
                              : (_showExpenses
                                  ? Colors.red[600]
                                  : Colors.green[600]),
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
    if (state.expenses.isEmpty) return [];

    final now = DateTime.now();
    List<FlSpot> spots = [];

    switch (_selectedPeriod) {
      case 0: // Day
        spots = _getDailyData(state, now);
        break;
      case 1: // Week
        spots = _getWeeklyData(state, now);
        break;
      case 2: // Month
        spots = _getMonthlyData(state, now);
        break;
      case 3: // Year
        spots = _getYearlyData(state, now);
        break;
    }

    return spots;
  }

  List<FlSpot> _getDailyData(ExpenseState state, DateTime now) {
    final List<FlSpot> spots = [];
    final expenses =
        _showExpenses
            ? state.expenses.where((e) => e.amount < 0).toList()
            : state.expenses.where((e) => e.amount > 0).toList();

    // Get last 6 days for better spacing
    for (int i = 5; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayExpenses =
          expenses
              .where(
                (e) =>
                    e.date.year == date.year &&
                    e.date.month == date.month &&
                    e.date.day == date.day,
              )
              .toList();

      final total = dayExpenses.fold<double>(
        0,
        (sum, e) => sum + e.amount.abs(),
      );
      spots.add(FlSpot((5 - i).toDouble(), total));
    }

    return spots;
  }

  List<FlSpot> _getWeeklyData(ExpenseState state, DateTime now) {
    final List<FlSpot> spots = [];
    final expenses =
        _showExpenses
            ? state.expenses.where((e) => e.amount < 0).toList()
            : state.expenses.where((e) => e.amount > 0).toList();

    // Get last 4 weeks
    for (int i = 3; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: (i + 1) * 7));
      final weekEnd = now.subtract(Duration(days: i * 7));

      final weekExpenses =
          expenses
              .where(
                (e) => e.date.isAfter(weekStart) && e.date.isBefore(weekEnd),
              )
              .toList();

      final total = weekExpenses.fold<double>(
        0,
        (sum, e) => sum + e.amount.abs(),
      );
      spots.add(FlSpot((3 - i).toDouble(), total));
    }

    return spots;
  }

  List<FlSpot> _getMonthlyData(ExpenseState state, DateTime now) {
    final List<FlSpot> spots = [];
    final expenses =
        _showExpenses
            ? state.expenses.where((e) => e.amount < 0).toList()
            : state.expenses.where((e) => e.amount > 0).toList();

    // Get last 6 months
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthExpenses =
          expenses
              .where(
                (e) => e.date.year == month.year && e.date.month == month.month,
              )
              .toList();

      final total = monthExpenses.fold<double>(
        0,
        (sum, e) => sum + e.amount.abs(),
      );
      spots.add(FlSpot((5 - i).toDouble(), total));
    }

    return spots;
  }

  List<FlSpot> _getYearlyData(ExpenseState state, DateTime now) {
    final List<FlSpot> spots = [];
    final expenses =
        _showExpenses
            ? state.expenses.where((e) => e.amount < 0).toList()
            : state.expenses.where((e) => e.amount > 0).toList();

    // Get last 5 years
    for (int i = 4; i >= 0; i--) {
      final year = now.year - i;
      final yearExpenses = expenses.where((e) => e.date.year == year).toList();

      final total = yearExpenses.fold<double>(
        0,
        (sum, e) => sum + e.amount.abs(),
      );
      spots.add(FlSpot((4 - i).toDouble(), total));
    }

    return spots;
  }

  String? _getChartLabel(int index) {
    final now = DateTime.now();

    switch (_selectedPeriod) {
      case 0: // Day
        final date = now.subtract(Duration(days: 5 - index));
        return _getDayLabel(date);
      case 1: // Week
        final weekStart = now.subtract(Duration(days: (3 - index + 1) * 7));
        return 'W${weekStart.day}';
      case 2: // Month
        final month = DateTime(now.year, now.month - (5 - index), 1);
        return _getMonthLabel(month);
      case 3: // Year
        final year = now.year - (4 - index);
        return year.toString();
      default:
        return null;
    }
  }

  String _getDayLabel(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _getMonthLabel(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[date.month - 1];
  }

  double _getYAxisInterval(List<FlSpot> data) {
    if (data.isEmpty) return 500;
    final maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    // Create more grid lines for better spacing with larger range
    if (maxY <= 100) return maxY / 2;
    if (maxY <= 500) return maxY / 3;
    if (maxY <= 1000) return maxY / 4;
    return maxY / 5; // More divisions for larger values
  }

  List<Map<String, dynamic>> _getTopSpending(ExpenseState state) {
    if (state.expenses.isEmpty) return [];

    final expenses =
        _showExpenses
            ? state.expenses.where((e) => e.amount < 0).toList()
            : state.expenses.where((e) => e.amount > 0).toList();

    // Group expenses by category and calculate totals
    final Map<String, double> categoryTotals = {};
    final Map<String, List<Expense>> categoryExpenses = {};

    for (final expense in expenses) {
      final category = expense.category;
      categoryTotals[category] =
          (categoryTotals[category] ?? 0) + expense.amount.abs();
      categoryExpenses.putIfAbsent(category, () => []).add(expense);
    }

    // Sort categories by total amount (descending)
    final sortedCategories =
        categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    // Get top 5 categories
    final topCategories = sortedCategories.take(5).toList();

    return topCategories.map((entry) {
      final category = entry.key;
      final total = entry.value;
      final categoryExpenseList = categoryExpenses[category]!;

      // Get the most recent expense for this category
      final mostRecent = categoryExpenseList.reduce(
        (a, b) => a.date.isAfter(b.date) ? a : b,
      );

      return {
        'category': category.toLowerCase(),
        'name': category,
        'date': _formatDate(mostRecent.date),
        'amount': total,
      };
    }).toList();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '${difference} days ago';

    return '${date.day}/${date.month}/${date.year}';
  }

  double _getRotationAngle() {
    final chartData = _getChartData(context.read<ExpenseBloc>().state);
    if (chartData.length <= 4) return 0.0; // No rotation for few points
    if (chartData.length <= 6) return -0.3; // Slight rotation
    return -0.5; // More rotation for many points
  }

  double _getFontSize() {
    final chartData = _getChartData(context.read<ExpenseBloc>().state);
    if (chartData.length <= 4) return 12.0;
    if (chartData.length <= 6) return 11.0;
    return 10.0; // Smaller font for many points
  }

  double _getBottomReservedSize() {
    final chartData = _getChartData(context.read<ExpenseBloc>().state);
    if (chartData.length <= 4) return 80.0; // Much more space
    if (chartData.length <= 6) return 90.0; // Much more space
    return 100.0; // Much more space for many points
  }

  double _getChartMaxY(List<FlSpot> chartData) {
    if (chartData.isEmpty) return 1000;

    final maxValue = chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    // Add much more padding to prevent overlap with X-axis labels
    if (maxValue == 0) return 200; // Increased minimum value
    return maxValue * 2.0; // Much more space - increased from 1.4 to 2.0
  }

  String _formatYAxisLabel(double value) {
    if (value >= 1000) {
      return '£${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return '£${value.toStringAsFixed(0)}';
    }
  }

  void _shareStatistics() {
    final now = DateTime.now();
    final period = _periods[_selectedPeriod];
    final type = _showExpenses ? 'Expenses' : 'Income';

    final shareText = '''
📊 Expense Statistics Report

Period: $period
Type: $type
Generated: ${now.day}/${now.month}/${now.year}

View your detailed financial insights in the Expenso app!
''';

    // For now, just show a snackbar. In a real app, you'd use a share package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Statistics report ready to share!'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {
            // In a real app, you'd copy to clipboard
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Copied to clipboard!')));
          },
        ),
      ),
    );
  }
}
