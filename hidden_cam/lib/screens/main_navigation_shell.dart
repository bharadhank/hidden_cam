import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/bottom_navigation.dart';
import 'home_screen.dart';
import 'scan_method_selection_screen.dart';
import 'scan_history_screen.dart';
import 'settings_screen.dart';

class MainNavigationShell extends StatefulWidget {
  final int initialIndex;

  const MainNavigationShell({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onScanPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ScanMethodSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            onOpenScan: _onScanPressed,
            onOpenHistory: () {
              setState(() => _currentIndex = 2);
            },
          ),
          // Placeholder for scan tab if clicked via index
          HomeScreen(onOpenScan: _onScanPressed),
          const ScanHistoryScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: SafeLensBottomNavigation(
        currentIndex: _currentIndex,
        onIndexChanged: (index) {
          if (index == 1) {
            _onScanPressed();
          } else {
            setState(() => _currentIndex = index);
          }
        },
        onScanPressed: _onScanPressed,
      ),
    );
  }
}
