import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/scan_method.dart';
import '../models/scan_result_model.dart';
import '../services/scan_service.dart';
import '../controllers/shield_animation_controller.dart';
import '../widgets/primary_button.dart';
import '../widgets/rounded_card.dart';
import '../guide/guide.dart';
import 'processing_screen.dart';

class ActiveScanningScreen extends StatefulWidget {
  final ScanMethod method;
  final ScanResultType desiredOutcome;

  const ActiveScanningScreen({
    super.key,
    required this.method,
    this.desiredOutcome = ScanResultType.normal,
  });

  @override
  State<ActiveScanningScreen> createState() => _ActiveScanningScreenState();
}

class _ActiveScanningScreenState extends State<ActiveScanningScreen> {
  final ScanService _scanService = ScanService();
  late FemaleGuideAnimationController _ariaGuideController;
  bool _showGuideAvatar = true;

  @override
  void initState() {
    super.initState();
    _ariaGuideController = FemaleGuideAnimationController(
      initialState: GuideAnimationState.scanning,
      initialSpeechText: 'Attentive scan in progress. Keep moving steadily.',
    );
    _startScan();
  }

  void _startScan() {
    _scanService.startScan(
      desiredResultType: widget.desiredOutcome,
      onComplete: (result) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (ctx, anim, secAnim) => ProcessingScreen(result: result),
            transitionsBuilder: (ctx, anim, secAnim, child) {
              return FadeTransition(opacity: anim, child: child);
            },
            transitionDuration: const Duration(milliseconds: 350),
          ),
        );
      },
    );
  }

  void _stopScanEarly() {
    _scanService.stopScan();
    final currentResult = ScanResultModel(
      id: 'SL-${DateTime.now().millisecondsSinceEpoch % 10000}',
      timestamp: DateTime.now(),
      type: widget.desiredOutcome,
      methodTitle: widget.method.title,
      location: 'Inspected Zone',
      detailsNotes: 'Scan ended manually by user.',
      isDemo: true,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ProcessingScreen(result: currentResult),
      ),
    );
  }

  @override
  void dispose() {
    _ariaGuideController.dispose();
    _scanService.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _scanService,
      builder: (context, _) {
        final telemetry = _scanService.currentTelemetry;

        return Scaffold(
          backgroundColor: AppColors.warmCream,
          appBar: AppBar(
            title: Text(widget.method.title),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () {
                _scanService.stopScan();
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline_rounded, size: 22),
                onPressed: () {
                  _showSensorInfoModal();
                },
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  // Status Context Ribbon
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.naturalTeal,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'SENSOR SWEEP ACTIVE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.naturalTeal,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Checking your space',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepForestGreen,
                      letterSpacing: -0.4,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Analyzing wireless frequencies and optical reflections in real time',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // View Mode Toggle (Aria Scanning Guide vs Shield)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showGuideAvatar = !_showGuideAvatar;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.outlineLight),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _showGuideAvatar ? Icons.person_rounded : Icons.shield_rounded,
                            size: 14,
                            color: AppColors.naturalTeal,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _showGuideAvatar ? 'Guide Mode: Aria Active' : 'Guide Mode: Shield Focus',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepForestGreen,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.swap_horiz_rounded, size: 14, color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Central Dynamic Scanner Stage: Circular Gauge + Guide / 3D Shield + Progress Arc
                  SizedBox(
                    width: 260,
                    height: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Circular Progress Arc
                        CustomPaint(
                          size: const Size(260, 260),
                          painter: _ScanGaugePainter(
                            progress: telemetry.progress / 100.0,
                            arcColor: AppColors.naturalTeal,
                            trackColor: AppColors.surfaceContainerHigh,
                          ),
                        ),

                        if (_showGuideAvatar)
                          // Aria Attentive Pose with Animated Scanning Rings
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              const ScanRingsWidget(
                                size: 240,
                                isScanning: true,
                                ringColor: AppColors.naturalTeal,
                              ),
                              FemaleGuide3DWidget(
                                controller: _ariaGuideController,
                                height: 210,
                                enableTouch: false,
                              ),
                            ],
                          )
                        else
                          // Center 3D Shield with Scanning Rings
                          const Shield3DWidget(
                            state: ShieldState.scanning,
                            size: 130,
                            showRings: true,
                          ),

                        // Progress percentage badge overlay at bottom
                        Positioned(
                          bottom: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9999),
                              boxShadow: [AppColors.softShadow],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${telemetry.progress}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepForestGreen,
                                  ),
                                ),
                                const Text(
                                  '%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.naturalTeal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Aria Scanning Companion Advice Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.outlineLight),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 12,
                          backgroundImage: AssetImage('assets/images/female_guide_fallback.jpg'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Aria: Inspecting ${widget.method.title}. Keep device steady at eye level.',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepForestGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Realtime Telemetry Instruction Pill Box
                  RoundedCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.motion_photos_on_rounded,
                              size: 18,
                              color: AppColors.naturalTeal,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Move slowly around the area',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepForestGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Keep your phone steady at chest height.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.naturalTeal,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  telemetry.statusText,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.naturalTeal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Signal Metrics Grid (RF Spectrum & Lens Reflection)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [AppColors.softShadow],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: const BoxDecoration(
                                  color: AppColors.surfaceContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.wifi_find_rounded,
                                  size: 18,
                                  color: AppColors.naturalTeal,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'RF Radio',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textTertiary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '2.4 / 5.0 GHz',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.deepForestGreen,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [AppColors.softShadow],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: const BoxDecoration(
                                  color: AppColors.surfaceContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.filter_center_focus_rounded,
                                  size: 18,
                                  color: AppColors.softSageGreen,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Lenses',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textTertiary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Clear (0 peak)',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.deepForestGreen,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Bottom Action: Stop Scan
                  PrimaryButton(
                    text: 'Stop Scan',
                    icon: Icons.stop_circle_outlined,
                    backgroundColor: AppColors.deepForestGreen,
                    onPressed: _stopScanEarly,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'SafeLens does not store or transmit visual recordings.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSensorInfoModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_rounded, color: AppColors.naturalTeal),
                const SizedBox(width: 8),
                Text(
                  widget.method.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepForestGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'What it can detect:\n${widget.method.canDetect}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.deepForestGreen,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'What it cannot detect:\n${widget.method.cannotDetect}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Got it',
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanGaugePainter extends CustomPainter {
  final double progress;
  final Color arcColor;
  final Color trackColor;

  _ScanGaugePainter({
    required this.progress,
    required this.arcColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 12;

    // 1. Inset Track Groove with subtle 3D inner bevel
    final groovePaint = Paint()
      ..color = trackColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, groovePaint);

    // 2. Precision Radial Tech Ticks
    const int tickCount = 48;
    final tickPaint = Paint()
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < tickCount; i++) {
      final angle = (i * (2 * math.pi / tickCount)) - (math.pi / 2);
      final isPassed = (i / tickCount) <= progress;
      tickPaint.color = isPassed
          ? arcColor.withValues(alpha: 0.45)
          : trackColor.withValues(alpha: 0.35);

      final rIn = radius - ((i % 4 == 0) ? 9.0 : 6.0);
      final rOut = radius - 3.0;

      final p1 = Offset(center.dx + math.cos(angle) * rIn, center.dy + math.sin(angle) * rIn);
      final p2 = Offset(center.dx + math.cos(angle) * rOut, center.dy + math.sin(angle) * rOut);

      canvas.drawLine(p1, p2, tickPaint);
    }

    if (progress <= 0.001) return;

    final sweepAngle = 2 * math.pi * progress;
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    // 3. Ambient Neon Glow behind the active arc
    final glowPaint = Paint()
      ..color = arcColor.withValues(alpha: 0.32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      sweepAngle,
      false,
      glowPaint,
    );

    // 4. Luminous Gradient Progress Arc
    final arcShader = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: -math.pi / 2 + sweepAngle,
      colors: [
        arcColor.withValues(alpha: 0.45),
        arcColor,
        const Color(0xFF67D8CD),
      ],
      stops: const [0.0, 0.75, 1.0],
    ).createShader(arcRect);

    final arcPaint = Paint()
      ..shader = arcShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      sweepAngle,
      false,
      arcPaint,
    );

    // 5. Glowing Head Spark / Pulse Bead at the tip of the arc
    final tipAngle = (-math.pi / 2) + sweepAngle;
    final tipX = center.dx + math.cos(tipAngle) * radius;
    final tipY = center.dy + math.sin(tipAngle) * radius;
    final tipPoint = Offset(tipX, tipY);

    // Outer glow for the tip
    final tipGlowPaint = Paint()
      ..color = const Color(0xFF67D8CD).withValues(alpha: 0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(tipPoint, 6.0, tipGlowPaint);

    // Solid bright core
    final tipCorePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(tipPoint, 3.2, tipCorePaint);
  }

  @override
  bool shouldRepaint(covariant _ScanGaugePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

