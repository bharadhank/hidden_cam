import 'package:flutter/material.dart';
import 'scan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Good evening ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF23483F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(Icons.waving_hand, size: 16, color: Color(0xFFD6A84F)),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Stay aware.\nStay comfortable.',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF23483F),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'SafeLens helps you check your surroundings for possible suspicious devices.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF5A716A),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF4F8F89),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: const Color(0xFF4F8F89).withValues(alpha:0.4),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ScanScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Scan Now',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Quick Safety Check',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF23483F),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF23483F).withValues(alpha:0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFA8C3A0).withValues(alpha:0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Color(0xFF4F8F89),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'No indicators found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF23483F),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Today · 7:42 PM',
                            style: TextStyle(
                              fontSize: 13,
                              color: const Color(0xFF23483F).withValues(alpha:0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFF5A716A)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Quick Safety Tip',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF23483F),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFA8C3A0).withValues(alpha:0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFF4F8F89),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: const Text(
                        'Take a moment to look around before using an unfamiliar space.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF23483F),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: const Color(0xFFE8E5DA),
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: _currentIndex == 0 ? const Color(0xFF4F8F89) : const Color(0xFFA0B0AA)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.radar_outlined, color: _currentIndex == 1 ? const Color(0xFF4F8F89) : const Color(0xFFA0B0AA)),
              label: 'Scan',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined, color: _currentIndex == 2 ? const Color(0xFF4F8F89) : const Color(0xFFA0B0AA)),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, color: _currentIndex == 3 ? const Color(0xFF4F8F89) : const Color(0xFFA0B0AA)),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
