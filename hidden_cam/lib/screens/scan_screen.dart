import 'dart:async';
import 'package:flutter/material.dart';
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int _progress = 0;
  Timer? _scanTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    _startScanning();
  }

  void _startScanning() {
    _scanTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (_progress < 100) {
        setState(() {
          _progress += (5 + (15 * (1 - (_progress / 100)))).toInt();
          if (_progress > 100) _progress = 100;
        });
      } else {
        timer.cancel();
        _finishScan();
      }
    });
  }

  void _finishScan() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const ResultScreen(isSuspicious: false), // Hardcoded for demo
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Checking your space',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF23483F),
                ),
              ),
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        width: 240 + (_pulseController.value * 40),
                        height: 240 + (_pulseController.value * 40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFA8C3A0).withValues(alpha:0.1 - (_pulseController.value * 0.1)),
                          border: Border.all(
                            color: const Color(0xFFA8C3A0).withValues(alpha:0.3 - (_pulseController.value * 0.3)),
                            width: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFA8C3A0).withValues(alpha:0.4), width: 8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.radar, color: Color(0xFF4F8F89), size: 32),
                          const SizedBox(height: 8),
                          Text(
                            '$_progress%',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFF4F8F89),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                'Move slowly around the area.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF23483F),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Keep your phone steady.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF5A716A),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Checking signals...',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4F8F89),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF4F8F89),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Stop Scan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
