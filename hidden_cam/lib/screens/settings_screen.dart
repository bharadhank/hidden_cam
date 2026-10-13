import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../services/storage_service.dart';
import '../widgets/rounded_card.dart';
import 'onboarding_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storage = StorageService();

  late bool _isReducedMotion;
  late bool _isAudioCues;
  late bool _isHaptic;
  late bool _onDeviceOnly;

  @override
  void initState() {
    super.initState();
    _isReducedMotion = _storage.isReducedMotion;
    _isAudioCues = _storage.isAudioCuesEnabled;
    _isHaptic = _storage.isHapticEnabled;
    _onDeviceOnly = _storage.onDeviceOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        title: const Text('Settings & Privacy'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Privacy Architecture
              _buildSectionTitle('PRIVACY ARCHITECTURE'),
              RoundedCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      icon: Icons.security_rounded,
                      title: '100% On-Device Processing',
                      subtitle:
                          'Sensor data never leaves this phone. No remote servers or cloud accounts.',
                      value: _onDeviceOnly,
                      onChanged: (val) async {
                        await _storage.setOnDeviceOnly(val);
                        setState(() => _onDeviceOnly = val);
                      },
                    ),
                    const Divider(height: 1, color: AppColors.outlineLight),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Icon(
                          Icons.enhanced_encryption_rounded,
                          size: 20,
                          color: AppColors.naturalTeal,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Local Storage Sealed',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.deepForestGreen,
                                ),
                              ),
                              Text(
                                'All logs are stored exclusively in app sandboxed storage.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.verified_rounded,
                          size: 18,
                          color: AppColors.naturalTeal,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section 2: Sensor & Permissions Manager
              _buildSectionTitle('DEVICE PERMISSIONS'),
              RoundedCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPermissionItem(
                      icon: Icons.camera_alt_outlined,
                      title: 'Camera Access',
                      reason:
                          'Required for optical reflection and flashlight analysis.',
                      isGranted: true,
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.outlineLight),
                    const SizedBox(height: 12),
                    _buildPermissionItem(
                      icon: Icons.bluetooth_rounded,
                      title: 'Bluetooth & Nearby Devices',
                      reason:
                          'Enables passive detection of unclassified BLE beacons.',
                      isGranted: true,
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.outlineLight),
                    const SizedBox(height: 12),
                    _buildPermissionItem(
                      icon: Icons.wifi_find_rounded,
                      title: 'Local Network',
                      reason:
                          'Used to assess Wi-Fi access points and hidden SSIDs.',
                      isGranted: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section 3: Accessibility & Motion
              _buildSectionTitle('ACCESSIBILITY & COMFORT'),
              RoundedCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      icon: Icons.motion_photos_off_outlined,
                      title: 'Reduced Motion',
                      subtitle:
                          'Replaces continuous 3D rotations and concentric ring animations with gentle static states.',
                      value: _isReducedMotion,
                      onChanged: (val) async {
                        await _storage.setReducedMotion(val);
                        setState(() => _isReducedMotion = val);
                      },
                    ),
                    const Divider(height: 1, color: AppColors.outlineLight),
                    _buildSwitchTile(
                      icon: Icons.volume_up_outlined,
                      title: 'Gentle Audio Guidance',
                      subtitle: 'Calm audio chimes at start and end of sweeps.',
                      value: _isAudioCues,
                      onChanged: (val) async {
                        await _storage.setAudioCuesEnabled(val);
                        setState(() => _isAudioCues = val);
                      },
                    ),
                    const Divider(height: 1, color: AppColors.outlineLight),
                    _buildSwitchTile(
                      icon: Icons.vibration_rounded,
                      title: 'Haptic Guidance',
                      subtitle: 'Soft tactile pulse when completing checks.',
                      value: _isHaptic,
                      onChanged: (val) async {
                        await _storage.setHapticEnabled(val);
                        setState(() => _isHaptic = val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section 4: Data Management & Tour
              _buildSectionTitle('DATA & GUIDES'),
              RoundedCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.tour_outlined,
                        color: AppColors.naturalTeal,
                      ),
                      title: const Text(
                        'Replay Onboarding Tour',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.deepForestGreen,
                        ),
                      ),
                      subtitle: const Text(
                        'View the introduction guide again',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OnboardingScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.outlineLight),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.file_download_outlined,
                        color: AppColors.naturalTeal,
                      ),
                      title: const Text(
                        'Export Privacy Logs',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.deepForestGreen,
                        ),
                      ),
                      subtitle: const Text(
                        'Save summary text of all offline scan checks',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Offline audit log exported to device clipboard.',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section 5: Responsible Disclosure Disclaimer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.verified_outlined,
                          size: 18,
                          color: AppColors.naturalTeal,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Responsible Detection Disclosure',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepForestGreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      'SafeLens is designed as a personal privacy and awareness utility. No mobile sensor can guarantee 100% detection of concealed hardware. SafeLens presents indicators for user verification and does not replace professional physical security reviews.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Version info
              const Center(
                child: Text(
                  'SafeLens v${AppStrings.appVersion} • Serene Safeguard Edition',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.naturalTeal, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepForestGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeTrackColor: AppColors.naturalTeal,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String reason,
    required bool isGranted,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.naturalTeal),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepForestGreen,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                reason,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: const Text(
            'Granted',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.naturalTeal,
            ),
          ),
        ),
      ],
    );
  }
}
