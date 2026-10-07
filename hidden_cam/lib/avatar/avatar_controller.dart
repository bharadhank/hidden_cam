import 'package:flutter/foundation.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'avatar_state.dart';

class SafeLensAvatarController extends ChangeNotifier {
  final Flutter3DController controller = Flutter3DController();
  AvatarState _state = AvatarState.idle;
  bool _isLoaded = false;
  List<String> _availableAnimations = [];

  AvatarState get state => _state;
  bool get isLoaded => _isLoaded;
  List<String> get availableAnimations => List.unmodifiable(_availableAnimations);

  SafeLensAvatarController() {
    controller.onModelLoaded.addListener(_handleModelLoaded);
  }

  Future<void> _handleModelLoaded() async {
    _isLoaded = controller.onModelLoaded.value;
    if (_isLoaded) {
      try {
        _availableAnimations = await controller.getAvailableAnimations();
        debugPrint('SafeLens avatar animations: $_availableAnimations');
        await play(AvatarState.idle);
      } catch (e) {
        debugPrint('Could not read avatar animations: $e');
      }
    }
    notifyListeners();
  }

  String _animationName(AvatarState state) {
    switch (state) {
      case AvatarState.idle:
        return 'IDLE';
      case AvatarState.greeting:
        return 'GREETING_WAVE';
      case AvatarState.talking:
        return 'TALKING';
      case AvatarState.pointingLeft:
        return 'POINT_LEFT';
      case AvatarState.pointingRight:
        return 'POINT_RIGHT';
      case AvatarState.pointingDown:
        return 'POINT_DOWN';
      case AvatarState.thinking:
        return 'THINKING';
      case AvatarState.scanning:
        return 'SCANNING';
      case AvatarState.safe:
        return 'SAFE';
      case AvatarState.caution:
        return 'CAUTION';
      case AvatarState.warning:
        return 'WARNING';
      case AvatarState.success:
        return 'SUCCESS';
    }
  }

  Future<void> play(
    AvatarState newState, {
    int loopCount = 0,
  }) async {
    if (!_isLoaded) {
      debugPrint('Avatar is not loaded yet.');
      return;
    }

    final animationName = _animationName(newState);
    if (_availableAnimations.isNotEmpty &&
        !_availableAnimations.contains(animationName)) {
      debugPrint('Animation "$animationName" was not found in GLB.');
      return;
    }

    _state = newState;
    notifyListeners();

    controller.playAnimation(
      animationName: animationName,
      loopCount: loopCount,
    );
  }

  Future<void> idle() async {
    await play(AvatarState.idle);
  }

  Future<void> greeting() async {
    await play(AvatarState.greeting, loopCount: 1);
  }

  Future<void> talking() async {
    await play(AvatarState.talking);
  }

  Future<void> thinking() async {
    await play(AvatarState.thinking);
  }

  Future<void> scanning() async {
    await play(AvatarState.scanning);
  }

  Future<void> safe() async {
    await play(AvatarState.safe, loopCount: 1);
  }

  Future<void> caution() async {
    await play(AvatarState.caution, loopCount: 1);
  }

  Future<void> warning() async {
    await play(AvatarState.warning, loopCount: 1);
  }

  Future<void> success() async {
    await play(AvatarState.success, loopCount: 1);
  }

  Future<void> pointLeft() async {
    await play(AvatarState.pointingLeft, loopCount: 1);
  }

  Future<void> pointRight() async {
    await play(AvatarState.pointingRight, loopCount: 1);
  }

  Future<void> pointDown() async {
    await play(AvatarState.pointingDown, loopCount: 1);
  }

  void pause() {
    controller.pauseAnimation();
  }

  void stop() {
    controller.stopAnimation();
  }

  void reset() {
    controller.resetAnimation();
  }

  @override
  void dispose() {
    controller.onModelLoaded.removeListener(_handleModelLoaded);
    controller.stopAnimation();
    super.dispose();
  }
}
