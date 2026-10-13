import 'package:flutter/material.dart';
import '../services/storage_service.dart';

enum ShieldState {
  idle,
  greeting,
  scanning,
  processing,
  safe,
  caution,
  success,
  paused,
}

class ShieldAnimationController extends ChangeNotifier {
  ShieldState _state = ShieldState.idle;
  bool _isReducedMotion = false;

  ShieldState get state => _state;
  bool get isReducedMotion => _isReducedMotion;

  ShieldAnimationController({ShieldState initialState = ShieldState.idle}) {
    _state = initialState;
    _isReducedMotion = StorageService().isReducedMotion;
  }

  void setState(ShieldState newState) {
    if (_state == newState) return;
    _state = newState;
    notifyListeners();
  }

  void setReducedMotion(bool value) {
    _isReducedMotion = value;
    notifyListeners();
  }

  void idle() => setState(ShieldState.idle);
  void greeting() => setState(ShieldState.greeting);
  void scanning() => setState(ShieldState.scanning);
  void processing() => setState(ShieldState.processing);
  void safeResult() => setState(ShieldState.safe);
  void cautionResult() => setState(ShieldState.caution);
  void success() => setState(ShieldState.success);
  void pause() => setState(ShieldState.paused);
}
