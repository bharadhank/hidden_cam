import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/scan_method.dart';
import '../models/scan_result_model.dart';
import 'storage_service.dart';

class ScanTelemetry {
  final int progress;
  final String statusText;
  final String rfStatus;
  final String lensStatus;
  final int bleCount;
  final double signalDbm;

  const ScanTelemetry({
    required this.progress,
    required this.statusText,
    required this.rfStatus,
    required this.lensStatus,
    required this.bleCount,
    required this.signalDbm,
  });
}

class ScanService extends ChangeNotifier {
  static final ScanService _instance = ScanService._internal();
  factory ScanService() => _instance;
  ScanService._internal();

  Timer? _timer;
  int _progress = 0;
  bool _isScanning = false;
  ScanMethod _selectedMethod = ScanMethod.availableMethods.first;
  ScanResultModel? _lastResult;

  int get progress => _progress;
  bool get isScanning => _isScanning;
  ScanMethod get selectedMethod => _selectedMethod;
  ScanResultModel? get lastResult => _lastResult;

  void selectMethod(ScanMethod method) {
    _selectedMethod = method;
    notifyListeners();
  }

  ScanTelemetry get currentTelemetry {
    String status;
    String rf = '2.4 / 5.0 GHz';
    String lens = 'Clear (0 peak)';
    int ble = 2;
    double dbm = -74.0;

    if (_progress < 25) {
      status = 'Calibrating local radio environment...';
    } else if (_progress < 50) {
      status = 'Scanning Wi-Fi & RF frequency bands...';
      rf = 'Sweeping channel 1, 6, 11';
      ble = 3;
    } else if (_progress < 75) {
      status = 'Analyzing optical reflections & sensors...';
      lens = 'Sampling optical returns';
      dbm = -68.0;
    } else if (_progress < 95) {
      status = 'Evaluating bluetooth beacon proximity...';
      ble = 4;
    } else {
      status = 'Synthesizing environmental summary...';
    }

    return ScanTelemetry(
      progress: _progress,
      statusText: status,
      rfStatus: rf,
      lensStatus: lens,
      bleCount: ble,
      signalDbm: dbm,
    );
  }

  void startScan({
    required Function(ScanResultModel) onComplete,
    ScanResultType desiredResultType = ScanResultType.normal,
  }) {
    _timer?.cancel();
    _progress = 0;
    _isScanning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(milliseconds: 140), (timer) {
      if (_progress < 100) {
        _progress += 2;
        if (_progress > 100) _progress = 100;
        notifyListeners();
      } else {
        timer.cancel();
        _isScanning = false;

        // Generate result according to the scenario
        final result = _createResult(desiredResultType);
        _lastResult = result;
        StorageService().saveScanResult(result);
        notifyListeners();
        onComplete(result);
      }
    });
  }

  void stopScan() {
    _timer?.cancel();
    _isScanning = false;
    notifyListeners();
  }

  ScanResultModel _createResult(ScanResultType type) {
    final now = DateTime.now();
    final id = 'SL-${(now.millisecondsSinceEpoch % 9000) + 1000}';

    switch (type) {
      case ScanResultType.normal:
        return ScanResultModel(
          id: id,
          timestamp: now,
          type: ScanResultType.normal,
          methodTitle: _selectedMethod.title,
          location: 'Living Area',
          detailsNotes: 'RF Spectrum: Clear. Infrared: 0 Pulses.',
          isDemo: true,
        );
      case ScanResultType.possibleIndicator:
        return ScanResultModel(
          id: id,
          timestamp: now,
          type: ScanResultType.possibleIndicator,
          methodTitle: _selectedMethod.title,
          location: 'Living Room (East corner)',
          deviceName: 'Unknown electronic device',
          signalDbm: '-68 dBm',
          frequencyBand: '2.4GHz RF Beacon',
          approximateArea: '~1.8m radius',
          detailsNotes:
              'Continuous non-broadcast transmission detected near multimedia console.',
          isDemo: true,
        );
      case ScanResultType.unableToConfirm:
        return ScanResultModel(
          id: id,
          timestamp: now,
          type: ScanResultType.unableToConfirm,
          methodTitle: _selectedMethod.title,
          location: 'Inspected Zone',
          detailsNotes:
              'Dense radio interference or obstructed line of sight prevented reliable reading.',
          isDemo: true,
        );
    }
  }
}
