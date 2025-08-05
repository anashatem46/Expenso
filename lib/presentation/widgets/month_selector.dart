import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final Function(DateTime) onMonthSelected;

  const MonthSelector({
    super.key,
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = DateTime(selectedMonth.year, index + 1);
          final isSelected = month.month == selectedMonth.month;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onMonthSelected(month),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green[600] : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? Colors.green[600]! : Colors.grey[300]!,
                    width: 1,
                  ),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                child: Center(
                  child: Text(
                    DateFormat('MMM').format(month),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
