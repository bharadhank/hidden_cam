import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_result_model.dart';
import '../models/report_issue_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Onboarding
  bool get hasCompletedOnboarding =>
      _prefs?.getBool('hasCompletedOnboarding') ?? false;

  Future<void> setCompletedOnboarding(bool value) async {
    await _prefs?.setBool('hasCompletedOnboarding', value);
  }

  // Accessibility & Settings
  bool get isReducedMotion => _prefs?.getBool('isReducedMotion') ?? false;

  Future<void> setReducedMotion(bool value) async {
    await _prefs?.setBool('isReducedMotion', value);
  }

  bool get isAudioCuesEnabled => _prefs?.getBool('isAudioCuesEnabled') ?? true;

  Future<void> setAudioCuesEnabled(bool value) async {
    await _prefs?.setBool('isAudioCuesEnabled', value);
  }

  bool get isHapticEnabled => _prefs?.getBool('isHapticEnabled') ?? true;

  Future<void> setHapticEnabled(bool value) async {
    await _prefs?.setBool('isHapticEnabled', value);
  }

  bool get onDeviceOnly => _prefs?.getBool('onDeviceOnly') ?? true;

  Future<void> setOnDeviceOnly(bool value) async {
    await _prefs?.setBool('onDeviceOnly', value);
  }

  // Scan History
  List<ScanResultModel> getScanHistory() {
    final list = _prefs?.getStringList('scanHistory');
    if (list == null || list.isEmpty) {
      return ScanResultModel.initialSampleHistory;
    }
    return list.map((item) => ScanResultModel.fromJson(item)).toList();
  }

  Future<void> saveScanResult(ScanResultModel result) async {
    final current = getScanHistory();
    current.insert(0, result);
    final stringList = current.map((e) => e.toJson()).toList();
    await _prefs?.setStringList('scanHistory', stringList);
  }

  Future<void> clearScanHistory() async {
    await _prefs?.remove('scanHistory');
  }

  // Reports
  List<ReportIssueModel> getSavedReports() {
    final list = _prefs?.getStringList('savedReports');
    if (list == null) return [];
    return list.map((item) => ReportIssueModel.fromJson(item)).toList();
  }

  Future<void> saveReport(ReportIssueModel report) async {
    final current = getSavedReports();
    current.insert(0, report);
    final stringList = current.map((e) => e.toJson()).toList();
    await _prefs?.setStringList('savedReports', stringList);
  }
}
