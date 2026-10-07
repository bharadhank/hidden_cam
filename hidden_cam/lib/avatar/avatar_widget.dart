import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'avatar_controller.dart';

class SafeLensAvatar extends StatefulWidget {
  final SafeLensAvatarController avatarController;
  final double height;
  final bool enableTouch;

  const SafeLensAvatar({
    super.key,
    required this.avatarController,
    this.height = 360,
    this.enableTouch = false,
  });

  @override
  State<SafeLensAvatar> createState() => _SafeLensAvatarState();
}

class _SafeLensAvatarState extends State<SafeLensAvatar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Flutter3DViewer(
        src: 'assets/avatar/safelens_avatar.glb',
        controller: widget.avatarController.controller,
        enableTouch: widget.enableTouch,
        activeGestureInterceptor: true,
        progressBarColor: Colors.transparent,
        onProgress: (double progress) {
          debugPrint(
            'Avatar loading: '
            '${(progress * 100).toStringAsFixed(0)}%',
          );
        },
        onLoad: (String modelAddress) {
          debugPrint('SafeLens avatar loaded: $modelAddress');
        },
        onError: (String error) {
          debugPrint('SafeLens avatar error: $error');
        },
      ),
    );
  }
}
