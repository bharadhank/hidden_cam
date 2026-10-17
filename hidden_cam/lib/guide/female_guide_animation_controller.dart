import 'package:flutter/foundation.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'guide_animation_state.dart';

/// Unified animation controller for the SafeLens 3D Female Guide (Aria).
///
/// Orchestrates state transitions, wraps the 3D model engine, handles
/// loading and fallback states, and synchronizes guide speech bubble updates.
class FemaleGuideAnimationController extends ChangeNotifier {
  final Flutter3DController controller = Flutter3DController();

  GuideAnimationState _state = GuideAnimationState.idle;
  bool _isLoaded = false;
  bool _isLoading = true;
  String? _errorMessage;
  List<String> _availableAnimations = [];
  String? _speechText;
  bool _isReducedMotion = false;

  GuideAnimationState get state => _state;
  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get availableAnimations => List.unmodifiable(_availableAnimations);
  String? get speechText => _speechText;
  bool get isReducedMotion => _isReducedMotion;

  FemaleGuideAnimationController({
    GuideAnimationState initialState = GuideAnimationState.idle,
    String? initialSpeechText,
    bool isReducedMotion = false,
  })  : _state = initialState,
        _speechText = initialSpeechText {
    _isReducedMotion = isReducedMotion;
    controller.onModelLoaded.addListener(_handleModelLoaded);
  }

  /// Update the speech text shown in the guide's companion dialog bubble.
  void setSpeechText(String? text) {
    if (_speechText != text) {
      _speechText = text;
      notifyListeners();
    }
  }

  /// Update reduced motion setting.
  void setReducedMotion(bool value) {
    if (_isReducedMotion != value) {
      _isReducedMotion = value;
      if (_isReducedMotion) {
        pause();
      } else {
        play(_state);
      }
      notifyListeners();
    }
  }

  Future<void> _handleModelLoaded() async {
    _isLoaded = controller.onModelLoaded.value;
    _isLoading = false;
    if (_isLoaded) {
      try {
        _availableAnimations = await controller.getAvailableAnimations();
        debugPrint('SafeLens female guide animations available: $_availableAnimations');
        if (!_isReducedMotion) {
          await play(_state);
        }
      } catch (e) {
        debugPrint('Could not read guide animations: $e');
      }
    }
    notifyListeners();
  }

  void handleLoadError(String error) {
    _isLoading = false;
    _errorMessage = error;
    debugPrint('FemaleGuide3D load error: $error');
    notifyListeners();
  }

  /// Transition to a new animation state.
  Future<void> play(
    GuideAnimationState newState, {
    int? loopCount,
  }) async {
    _state = newState;
    notifyListeners();

    if (_isReducedMotion || !_isLoaded) {
      return;
    }

    final clipName = newState.clipName;
    final int effectiveLoopCount = loopCount ?? (newState.isLooping ? 0 : 1);

    try {
      controller.playAnimation(
        animationName: clipName,
        loopCount: effectiveLoopCount,
      );
    } catch (e) {
      debugPrint('Error triggering animation "$clipName": $e');
    }
  }

  /// Subtle breathing, blinking, and natural gentle posture.
  Future<void> idle() async => play(GuideAnimationState.idle);

  /// Friendly smile and warm hand wave.
  Future<void> greeting() async => play(GuideAnimationState.greeting, loopCount: 1);

  /// Gentle explanatory hand gestures.
  Future<void> explaining() async => play(GuideAnimationState.explaining);

  /// Attentive scanning pose with holographic shield gesture.
  Future<void> scanning() async => play(GuideAnimationState.scanning);

  /// Gentle pointing gesture toward UI element or tip.
  Future<void> pointing() async => play(GuideAnimationState.pointing, loopCount: 1);

  /// Calm, focused processing posture.
  Future<void> processing() async => play(GuideAnimationState.processing);

  /// Serene, comforting nod and reassuring smile.
  Future<void> reassuring() async => play(GuideAnimationState.reassuring, loopCount: 1);

  /// Pause current animation (e.g., when screen loses focus).
  void pause() {
    _state = GuideAnimationState.paused;
    notifyListeners();
    try {
      controller.pauseAnimation();
    } catch (_) {}
  }

  /// Stop current animation.
  void stop() {
    try {
      controller.stopAnimation();
    } catch (_) {}
  }

  /// Reset model animation to initial frame.
  void reset() {
    try {
      controller.resetAnimation();
    } catch (_) {}
  }

  @override
  void dispose() {
    controller.onModelLoaded.removeListener(_handleModelLoaded);
    try {
      controller.stopAnimation();
    } catch (_) {}
    super.dispose();
  }
}
