import 'dart:convert';

enum ScanResultType {
  normal,
  possibleIndicator,
  unableToConfirm,
}

class ScanResultModel {
  final String id;
  final DateTime timestamp;
  final ScanResultType type;
  final String methodTitle;
  final String location;
  final String? deviceName;
  final String? signalDbm;
  final String? frequencyBand;
  final String? detailsNotes;
  final String? approximateArea;
  final bool isDemo;

  const ScanResultModel({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.methodTitle,
    required this.location,
    this.deviceName,
    this.signalDbm,
    this.frequencyBand,
    this.detailsNotes,
    this.approximateArea,
    this.isDemo = true,
  });

  bool get isFlagged => type == ScanResultType.possibleIndicator;
  bool get isClean => type == ScanResultType.normal;
  bool get isInconclusive => type == ScanResultType.unableToConfirm;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'methodTitle': methodTitle,
      'location': location,
      'deviceName': deviceName,
      'signalDbm': signalDbm,
      'frequencyBand': frequencyBand,
      'detailsNotes': detailsNotes,
      'approximateArea': approximateArea,
      'isDemo': isDemo,
    };
  }

  factory ScanResultModel.fromMap(Map<String, dynamic> map) {
    return ScanResultModel(
      id: map['id'] ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      type: ScanResultType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ScanResultType.normal,
      ),
      methodTitle: map['methodTitle'] ?? 'Visual Check',
      location: map['location'] ?? 'Living Room',
      deviceName: map['deviceName'],
      signalDbm: map['signalDbm'],
      frequencyBand: map['frequencyBand'],
      detailsNotes: map['detailsNotes'],
      approximateArea: map['approximateArea'],
      isDemo: map['isDemo'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScanResultModel.fromJson(String source) =>
      ScanResultModel.fromMap(json.decode(source));

  static List<ScanResultModel> get initialSampleHistory => [
        ScanResultModel(
          id: 'SL-8042',
          timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
          type: ScanResultType.normal,
          methodTitle: 'Dual-band RF & Lens Check',
          location: 'Restroom Suite',
          detailsNotes: 'RF Spectrum: Clear. Infrared: 0 Pulses.',
          isDemo: true,
        ),
        ScanResultModel(
          id: 'SL-8041',
          timestamp: DateTime.now().subtract(const Duration(hours: 3, minutes: 20)),
          type: ScanResultType.possibleIndicator,
          methodTitle: 'Full Multi-Spectrum Check',
          location: 'Living Room (East corner)',
          deviceName: 'Unknown electronic device',
          signalDbm: '-68 dBm',
          frequencyBand: '2.4GHz RF Beacon',
          approximateArea: '~1.8m radius',
          detailsNotes: 'Frequent beacon broadcasts observed near TV console.',
          isDemo: true,
        ),
        ScanResultModel(
          id: 'SL-8038',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          type: ScanResultType.normal,
          methodTitle: 'Optical Lens Reflection',
          location: 'Bedroom Clock Area',
          detailsNotes: 'No anomalous optical glare points identified.',
          isDemo: true,
        ),
        ScanResultModel(
          id: 'SL-8035',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
          type: ScanResultType.normal,
          methodTitle: 'Bluetooth BLE Sweeper',
          location: 'Study & Desk Area',
          detailsNotes: 'Only authorized user peripherals found.',
          isDemo: true,
        ),
        ScanResultModel(
          id: 'SL-8022',
          timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
          type: ScanResultType.unableToConfirm,
          methodTitle: 'Wi-Fi & RF Spectrum Probe',
          location: 'Hotel Hallway & Entry',
          detailsNotes: 'High external interference; inconclusive check.',
          isDemo: true,
        ),
      ];
}
