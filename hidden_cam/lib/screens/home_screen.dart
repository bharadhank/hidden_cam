import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../services/storage_service.dart';
import '../models/scan_result_model.dart';
import '../widgets/shield_3d_widget.dart';
import '../controllers/shield_animation_controller.dart';
import '../widgets/primary_button.dart';
import '../widgets/rounded_card.dart';
import '../widgets/safety_tip_card.dart';
import 'scan_method_selection_screen.dart';
import 'normal_result_screen.dart';
import 'device_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenScan;
  final VoidCallback? onOpenHistory;

  const HomeScreen({
    super.key,
    this.onOpenScan,
    this.onOpenHistory,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<ScanResultModel> _history;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _history = StorageService().getScanHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recentScan = _history.isNotEmpty ? _history.first : null;

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.naturalTeal,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'SafeLens',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.deepForestGreen,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new alerts. Your environment is calm.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.deepForestGreen,
                size: 18,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Greeting & Botanical Banner Card
              RoundedCard(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    // Foliage background decorative silhouette
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Opacity(
                        opacity: 0.15,
                        child: Icon(
                          Icons.local_florist_rounded,
                          size: 110,
                          color: AppColors.naturalTeal,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Good evening',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text('👋', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Stay aware.\nStay comfortable.',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepForestGreen,
                            height: 1.25,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'SafeLens helps you check your surroundings for possible suspicious devices.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Hero 3D Shield Floating Animation
              Center(
                child: Shield3DWidget(
                  state: ShieldState.idle,
                  size: 140,
                  showRings: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ScanMethodSelectionScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),

              // Primary "Scan Now" Button
              PrimaryButton(
                text: 'Scan Now',
                icon: Icons.radar_rounded,
                onPressed: () {
                  if (widget.onOpenScan != null) {
                    widget.onOpenScan!();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ScanMethodSelectionScreen(),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 8),

              const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.fiber_manual_record,
                      size: 8,
                      color: AppColors.softSageGreen,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Ready to scan optical & radio signals',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section: Quick Safety Check
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quick Safety Check',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepForestGreen,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onOpenHistory,
                    child: const Text(
                      'Last activity',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Recent Scan Card
              if (recentScan != null)
                RoundedCard(
                  onTap: () {
                    if (recentScan.type == ScanResultType.possibleIndicator) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DeviceDetailsScreen(result: recentScan),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NormalResultScreen(result: recentScan),
                        ),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: recentScan.isFlagged
                              ? AppColors.amberLight
                              : AppColors.surfaceContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          recentScan.isFlagged
                              ? Icons.warning_rounded
                              : Icons.check_circle_rounded,
                          color: recentScan.isFlagged
                              ? AppColors.softAmber
                              : AppColors.naturalTeal,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recentScan.isFlagged
                                  ? 'Possible indicator noted'
                                  : 'No indicators found',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.deepForestGreen,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${recentScan.location} · ${recentScan.methodTitle}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textTertiary,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // Section: Daily Habit / Quick Safety Tip
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick Safety Tip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepForestGreen,
                    ),
                  ),
                  Text(
                    'Daily habit',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.naturalTeal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const SafetyTipCard(),

              const SizedBox(height: 16),

              // Environmental Awareness Card: Ambient Mode Active
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.eco_rounded,
                        color: AppColors.naturalTeal,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ambient Mode Active',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepForestGreen,
                            ),
                          ),
                          Text(
                            'Background reflections muted',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.naturalTeal,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: const Text(
                        'Secured',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
