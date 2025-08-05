import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'expense_list_screen.dart';
import '../widgets/add_transaction_modal.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ExpenseListScreen(),
    const Center(
      child: Text(
        'Stats\nComing Soon',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    ),
    const Center(
      child: Text(
        'Settings\nComing Soon',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavigation() {
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      shape: const AutomaticNotchedShape(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.account_balance_wallet, 'Wallet', 1),
          const SizedBox(width: 40), // Space for FAB
          _buildNavItem(Icons.bar_chart, 'Stats', 2),
          _buildNavItem(Icons.settings, 'Settings', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.green[600] : Colors.grey[600]),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.green[600] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        _showAddTransactionModal(context);
      },
      backgroundColor: Colors.green[600],
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showAddTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: const AddTransactionModal(),
          ),
    );
  }
}
