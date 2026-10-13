import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hidden_cam/core/theme/app_theme.dart';
import 'package:hidden_cam/controllers/shield_animation_controller.dart';
import 'package:hidden_cam/models/scan_method.dart';
import 'package:hidden_cam/models/scan_result_model.dart';
import 'package:hidden_cam/models/report_issue_model.dart';
import 'package:hidden_cam/services/storage_service.dart';
import 'package:hidden_cam/services/scan_service.dart';
import 'package:hidden_cam/widgets/shield_3d_widget.dart';
import 'package:hidden_cam/widgets/scan_rings_widget.dart';
import 'package:hidden_cam/widgets/primary_button.dart';
import 'package:hidden_cam/widgets/safety_tip_card.dart';
import 'package:hidden_cam/screens/splash_screen.dart';
import 'package:hidden_cam/screens/onboarding_screen.dart';
import 'package:hidden_cam/screens/home_screen.dart';
import 'package:hidden_cam/screens/scan_method_selection_screen.dart';
import 'package:hidden_cam/screens/active_scanning_screen.dart';
import 'package:hidden_cam/screens/processing_screen.dart';
import 'package:hidden_cam/screens/normal_result_screen.dart';
import 'package:hidden_cam/screens/possible_indicator_screen.dart';
import 'package:hidden_cam/screens/device_details_screen.dart';
import 'package:hidden_cam/screens/safety_steps_screen.dart';
import 'package:hidden_cam/screens/report_screen.dart';
import 'package:hidden_cam/screens/report_confirmation_screen.dart';
import 'package:hidden_cam/screens/scan_history_screen.dart';
import 'package:hidden_cam/screens/settings_screen.dart';
import 'package:hidden_cam/screens/unable_to_confirm_screen.dart';
import 'package:hidden_cam/screens/main_navigation_shell.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    home: child,
  );
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService().init();
  });

  group('SafeLens Reusable 3D Shield & Rings Widget Tests', () {
    testWidgets('Shield3DWidget renders in all 8 states', (tester) async {
      for (final state in ShieldState.values) {
        await tester.pumpWidget(
          _wrap(Shield3DWidget(state: state, size: 100)),
        );
        expect(find.byType(Shield3DWidget), findsOneWidget);
      }
    });

    testWidgets('Shield3DWidget renders with reduced motion', (tester) async {
      await tester.pumpWidget(
        _wrap(const Shield3DWidget(
          state: ShieldState.scanning,
          isReducedMotion: true,
          showRings: true,
        )),
      );
      expect(find.byType(Shield3DWidget), findsOneWidget);
    });

    testWidgets('ScanRingsWidget renders both dynamic and static modes',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const ScanRingsWidget(isScanning: true, isReducedMotion: false)),
      );
      expect(find.byType(ScanRingsWidget), findsOneWidget);

      await tester.pumpWidget(
        _wrap(const ScanRingsWidget(isScanning: false, isReducedMotion: true)),
      );
      expect(find.byType(ScanRingsWidget), findsOneWidget);
    });

    testWidgets('PrimaryButton renders and triggers tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        _wrap(PrimaryButton(
          text: 'Scan Now',
          onPressed: () => tapped = true,
        )),
      );

      expect(find.text('Scan Now'), findsOneWidget);
      await tester.tap(find.byType(PrimaryButton));
      expect(tapped, isTrue);
    });

    testWidgets('SafetyTipCard displays title and description', (tester) async {
      await tester.pumpWidget(
        _wrap(const SafetyTipCard()),
      );
      expect(find.textContaining('Take a moment to look around'), findsOneWidget);
    });
  });

  group('SafeLens Service & Model Tests', () {
    test('ScanResultModel serialization and deserialization', () {
      final model = ScanResultModel(
        id: 'SL-9999',
        timestamp: DateTime(2026, 10, 13, 21, 30),
        type: ScanResultType.possibleIndicator,
        methodTitle: 'Full Multi-Spectrum Check',
        location: 'Hotel Suite 301',
        deviceName: 'Unknown electronic device',
        signalDbm: '-68 dBm',
        frequencyBand: '2.4GHz RF Beacon',
      );

      final jsonStr = model.toJson();
      final parsed = ScanResultModel.fromJson(jsonStr);

      expect(parsed.id, 'SL-9999');
      expect(parsed.isFlagged, isTrue);
      expect(parsed.signalDbm, '-68 dBm');
      expect(parsed.frequencyBand, '2.4GHz RF Beacon');
    });

    test('ReportIssueModel serialization and deserialization', () {
      final report = ReportIssueModel(
        id: 'REP-101',
        noticeType: ReportNoticeType.unexpectedCamera,
        location: 'Dressing Room',
        notes: 'Pinhole lens reflection spotted near lamp.',
        hasPhotoAttached: true,
        timestamp: DateTime.now(),
        consentGiven: true,
      );

      final jsonStr = report.toJson();
      final parsed = ReportIssueModel.fromJson(jsonStr);

      expect(parsed.id, 'REP-101');
      expect(parsed.noticeType, ReportNoticeType.unexpectedCamera);
      expect(parsed.hasPhotoAttached, isTrue);
    });

    test('ScanService progress and telemetry states', () {
      final service = ScanService();
      service.selectMethod(ScanMethod.availableMethods[1]);
      expect(service.selectedMethod.type, ScanMethodType.opticalLens);

      final telemetry = service.currentTelemetry;
      expect(telemetry.progress, 0);
      expect(telemetry.statusText.isNotEmpty, isTrue);
    });
  });

  group('SafeLens 16-Screen Smoke & Render Tests', () {
    final sampleNormal = ScanResultModel(
      id: 'SL-1',
      timestamp: DateTime.now(),
      type: ScanResultType.normal,
      methodTitle: 'Dual-band Check',
      location: 'Living Room',
    );

    final sampleCaution = ScanResultModel(
      id: 'SL-2',
      timestamp: DateTime.now(),
      type: ScanResultType.possibleIndicator,
      methodTitle: 'Full Multi-Spectrum',
      location: 'East corner',
      deviceName: 'Unknown electronic device',
      signalDbm: '-68 dBm',
    );

    final sampleInconclusive = ScanResultModel(
      id: 'SL-3',
      timestamp: DateTime.now(),
      type: ScanResultType.unableToConfirm,
      methodTitle: 'Wi-Fi Probe',
      location: 'Hallway',
    );

    final sampleReport = ReportIssueModel(
      id: 'REP-500',
      noticeType: ReportNoticeType.suspiciousDevice,
      location: 'Room 202',
      notes: 'Test observation',
      hasPhotoAttached: false,
      timestamp: DateTime.now(),
      consentGiven: true,
    );

    testWidgets('Screen 1: SplashScreen renders', (tester) async {
      await tester.pumpWidget(_wrap(const SplashScreen()));
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('Screens 2-4: OnboardingScreen renders', (tester) async {
      await tester.pumpWidget(_wrap(const OnboardingScreen()));
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.text('SafeLens'), findsOneWidget);
    });

    testWidgets('Screen 5: HomeScreen renders', (tester) async {
      await tester.pumpWidget(_wrap(const HomeScreen()));
      expect(find.text('Stay aware.\nStay comfortable.'), findsOneWidget);
      expect(find.text('Scan Now'), findsOneWidget);
    });

    testWidgets('Screen 6: ScanMethodSelectionScreen renders', (tester) async {
      await tester.pumpWidget(_wrap(const ScanMethodSelectionScreen()));
      expect(find.text('Inspection Methods'), findsOneWidget);
      expect(find.text('Full Multi-Spectrum Check'), findsOneWidget);
    });

    testWidgets('Screen 7: ActiveScanningScreen renders', (tester) async {
      await tester.pumpWidget(
        _wrap(ActiveScanningScreen(
          method: ScanMethod.availableMethods.first,
        )),
      );
      expect(find.text('Checking your space'), findsOneWidget);
      expect(find.text('Stop Scan'), findsOneWidget);
    });

    testWidgets('Screen 8: ProcessingScreen renders', (tester) async {
      await tester.pumpWidget(_wrap(ProcessingScreen(result: sampleNormal)));
      expect(find.text('Analyzing Environment'), findsOneWidget);
    });

    testWidgets('Screen 9: NormalResultScreen renders', (tester) async {
      await tester.pumpWidget(_wrap(NormalResultScreen(result: sampleNormal)));
      expect(find.text('No indicators found'), findsOneWidget);
      expect(find.text('View Safety Tips'), findsOneWidget);
    });

    testWidgets('Screen 10: PossibleIndicatorScreen renders', (tester) async {
      await tester.pumpWidget(_wrap(PossibleIndicatorScreen(result: sampleCaution)));
      expect(find.text('Possible indicator'), findsOneWidget);
      expect(find.text('Review Details'), findsOneWidget);
    });

    testWidgets('Screen 11: DeviceDetailsScreen renders', (tester) async {
      await tester.pumpWidget(_wrap(DeviceDetailsScreen(result: sampleCaution)));
      expect(find.text('Device Details'), findsOneWidget);
      expect(find.text('Unknown electronic device'), findsOneWidget);
    });

    testWidgets('Screen 12: SafetyStepsScreen renders', (tester) async {
      await tester.pumpWidget(_wrap(const SafetyStepsScreen()));
      expect(find.text('Recommended Safety Steps'), findsOneWidget);
      expect(find.text('Look around carefully'), findsOneWidget);
    });

    testWidgets('Screen 13: ReportScreen renders', (tester) async {
      await tester.pumpWidget(_wrap(const ReportScreen()));
      expect(find.text('Document Finding'), findsOneWidget);
      expect(find.text('What did you notice?'), findsOneWidget);
    });

    testWidgets('Screen 14: ReportConfirmationScreen renders', (tester) async {
      await tester.pumpWidget(
        _wrap(ReportConfirmationScreen(report: sampleReport)),
      );
      expect(find.text('Report Recorded Safely'), findsOneWidget);
    });

    testWidgets('Screen 15: ScanHistoryScreen renders', (tester) async {
      await tester.pumpWidget(_wrap(const ScanHistoryScreen()));
      expect(find.text('Scan History'), findsOneWidget);
      expect(find.textContaining('All Scans'), findsOneWidget);
    });

    testWidgets('Screen 16: SettingsScreen renders', (tester) async {
      await tester.pumpWidget(_wrap(const SettingsScreen()));
      expect(find.text('Settings & Privacy'), findsOneWidget);
      expect(find.text('Reduced Motion'), findsOneWidget);
    });

    testWidgets('Screen 17: UnableToConfirmScreen renders', (tester) async {
      await tester.pumpWidget(
        _wrap(UnableToConfirmScreen(result: sampleInconclusive)),
      );
      expect(find.text('Unable to confirm'), findsOneWidget);
    });

    testWidgets('MainNavigationShell renders with bottom dock', (tester) async {
      await tester.pumpWidget(_wrap(const MainNavigationShell()));
      expect(find.byType(MainNavigationShell), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });
  });
}
