/// Animation states for the SafeLens Female Guide character (Aria).
///
/// Designed specifically for the hybrid animation pipeline combining
/// pre-rendered video moments with interactive 3D playback.
enum GuideAnimationState {
  /// Subtle breathing, occasional blinking, and gentle natural movement.
  idle,

  /// The character smiles and performs a friendly hand wave.
  greeting,

  /// The character uses gentle hand gestures as if explaining a safety tip.
  explaining,

  /// The character adopts an attentive pose and makes a small scanning-related gesture.
  /// Animated teal rings appear around the shield.
  scanning,

  /// The character gently points towards a button, instruction, or safety tip.
  pointing,

  /// The character remains calm with subtle movement.
  /// A separate progress indicator communicates the actual application state.
  processing,

  /// The character gives a gentle nod and maintains a calm expression.
  reassuring,

  /// The character transitions to a neutral pose and stops unnecessary animation.
  paused,
}

extension GuideAnimationStateExtension on GuideAnimationState {
  /// Name of the animation clip stored in the GLB asset.
  String get clipName {
    switch (this) {
      case GuideAnimationState.idle:
        return 'idle';
      case GuideAnimationState.greeting:
        return 'greeting';
      case GuideAnimationState.explaining:
        return 'explaining';
      case GuideAnimationState.scanning:
        return 'scanning';
      case GuideAnimationState.pointing:
        return 'pointing';
      case GuideAnimationState.processing:
        return 'processing';
      case GuideAnimationState.reassuring:
        return 'reassuring';
      case GuideAnimationState.paused:
        return 'paused';
    }
  }

  /// Whether this animation typically loops indefinitely.
  bool get isLooping {
    switch (this) {
      case GuideAnimationState.idle:
      case GuideAnimationState.explaining:
      case GuideAnimationState.scanning:
      case GuideAnimationState.processing:
        return true;
      case GuideAnimationState.greeting:
      case GuideAnimationState.pointing:
      case GuideAnimationState.reassuring:
      case GuideAnimationState.paused:
        return false;
    }
  }

  /// Human-readable label for accessibility and debug output.
  String get label {
    switch (this) {
      case GuideAnimationState.idle:
        return 'Idle';
      case GuideAnimationState.greeting:
        return 'Greeting';
      case GuideAnimationState.explaining:
        return 'Explaining';
      case GuideAnimationState.scanning:
        return 'Scanning';
      case GuideAnimationState.pointing:
        return 'Pointing';
      case GuideAnimationState.processing:
        return 'Processing';
      case GuideAnimationState.reassuring:
        return 'Reassuring';
      case GuideAnimationState.paused:
        return 'Paused';
    }
  }
}
