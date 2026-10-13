import 'package:flutter/material.dart';

enum ScanMethodType {
  multiSpectrum,
  opticalLens,
  rfSpectrum,
  bluetoothBle,
}

class ScanMethod {
  final ScanMethodType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final String canDetect;
  final String cannotDetect;
  final String estimatedDuration;
  final bool isRecommended;

  const ScanMethod({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.canDetect,
    required this.cannotDetect,
    required this.estimatedDuration,
    this.isRecommended = false,
  });

  static const List<ScanMethod> availableMethods = [
    ScanMethod(
      type: ScanMethodType.multiSpectrum,
      title: 'Full Multi-Spectrum Check',
      subtitle: 'Combined RF, BLE & guided optical reflection assessment.',
      icon: Icons.radar,
      canDetect: 'Active wireless signals, BLE beacons, and high-contrast reflective optics.',
      cannotDetect: 'Powered-down electronics or shielded non-wireless pinholes.',
      estimatedDuration: '~25 seconds',
      isRecommended: true,
    ),
    ScanMethod(
      type: ScanMethodType.opticalLens,
      title: 'Optical Lens Reflection',
      subtitle: 'Uses flashlight strobe & optical reflection filters.',
      icon: Icons.camera_enhance_outlined,
      canDetect: 'Curved glass elements and antireflective coatings in dimmed lighting.',
      cannotDetect: 'Covered, non-optical, or recessed devices.',
      estimatedDuration: '~15 seconds',
    ),
    ScanMethod(
      type: ScanMethodType.rfSpectrum,
      title: 'Wi-Fi & RF Spectrum Probe',
      subtitle: 'Passively monitors 2.4 GHz and 5.0 GHz broadcast beacons.',
      icon: Icons.wifi_tethering,
      canDetect: 'Unusual Wi-Fi access points, hidden SSIDs, and high-frequency streaming.',
      cannotDetect: 'Offline devices recording strictly to local micro-SD storage.',
      estimatedDuration: '~10 seconds',
    ),
    ScanMethod(
      type: ScanMethodType.bluetoothBle,
      title: 'Bluetooth BLE Sweeper',
      subtitle: 'Detects proximate low-energy advertisement packets.',
      icon: Icons.bluetooth_searching,
      canDetect: 'Nearby unclassified transmitters and unknown BLE tracking beacons.',
      cannotDetect: 'Hardwired equipment or passive sensors.',
      estimatedDuration: '~12 seconds',
    ),
  ];
}
