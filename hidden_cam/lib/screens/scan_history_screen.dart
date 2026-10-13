import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/scan_result_model.dart';
import '../services/storage_service.dart';
import '../widgets/rounded_card.dart';
import '../widgets/empty_state.dart';
import 'normal_result_screen.dart';
import 'device_details_screen.dart';
import 'unable_to_confirm_screen.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  int _selectedFilter = 0; // 0: All, 1: Flagged, 2: Clean
  String _searchQuery = '';
  late List<ScanResultModel> _allHistory;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _allHistory = StorageService().getScanHistory();
    });
  }

  void _confirmClearHistory() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Clear Scan History?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.deepForestGreen,
          ),
        ),
        content: const Text(
          'All offline scan records will be securely purged from this device. This action cannot be undone.',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.mutedCoral,
            ),
            onPressed: () async {
              final nav = Navigator.of(ctx);
              await StorageService().clearScanHistory();
              nav.pop();
              _loadHistory();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var filteredList = _allHistory.where((item) {
      if (_selectedFilter == 1 && !item.isFlagged) return false;
      if (_selectedFilter == 2 && !item.isClean) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchLoc = item.location.toLowerCase().contains(q);
        final matchMethod = item.methodTitle.toLowerCase().contains(q);
        if (!matchLoc && !matchMethod) return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        title: const Text('Scan History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear history',
            onPressed: _allHistory.isEmpty ? null : _confirmClearHistory,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                children: [
                  // Encryption & Status Banner
                  RoundedCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.enhanced_encryption_rounded,
                                color: AppColors.naturalTeal,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_allHistory.length} total checks',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepForestGreen,
                                  ),
                                ),
                                const Text(
                                  'Encrypted & sealed on-device',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.fiber_manual_record,
                                size: 7,
                                color: AppColors.naturalTeal,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Protected',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.naturalTeal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Search input
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: [AppColors.softShadow],
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: AppColors.textTertiary,
                        ),
                        hintText: 'Search location or scan method...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Filter Chips
                  Row(
                    children: [
                      _buildFilterChip('All Scans (${_allHistory.length})', 0),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Flagged (${_allHistory.where((e) => e.isFlagged).length})',
                        1,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Clean (${_allHistory.where((e) => e.isClean).length})',
                        2,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // History List
            Expanded(
              child: filteredList.isEmpty
                  ? EmptyState(
                      icon: Icons.history_rounded,
                      title: 'No checks found',
                      description: _searchQuery.isNotEmpty
                          ? 'No logs matched "$_searchQuery"'
                          : 'Your recent scans will appear here as you inspect spaces.',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildHistoryCard(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.naturalTeal : Colors.white,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: [AppColors.softShadow],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : AppColors.deepForestGreen,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(ScanResultModel item) {
    IconData icon;
    Color iconColor;
    Color badgeBg;
    String statusText;

    if (item.isFlagged) {
      icon = Icons.warning_rounded;
      iconColor = AppColors.softAmber;
      badgeBg = AppColors.amberLight;
      statusText = 'Possible Indicator';
    } else if (item.isClean) {
      icon = Icons.check_circle_rounded;
      iconColor = AppColors.naturalTeal;
      badgeBg = AppColors.surfaceContainer;
      statusText = 'No indicators found';
    } else {
      icon = Icons.help_outline_rounded;
      iconColor = AppColors.textTertiary;
      badgeBg = AppColors.surfaceContainerHigh;
      statusText = 'Unable to confirm';
    }

    final timeStr =
        '${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}';

    return RoundedCard(
      padding: const EdgeInsets.all(16),
      onTap: () {
        if (item.isFlagged) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DeviceDetailsScreen(result: item),
            ),
          );
        } else if (item.isInconclusive) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UnableToConfirmScreen(result: item),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NormalResultScreen(result: item),
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
              color: badgeBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        statusText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepForestGreen,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      timeStr,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.location} · ${item.methodTitle}',
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
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
            size: 20,
          ),
        ],
      ),
    );
  }
}
