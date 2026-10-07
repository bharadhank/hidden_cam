import 'package:flutter/material.dart';
import 'avatar_controller.dart';
import 'avatar_widget.dart';

class SafeLensAvatarGuide extends StatelessWidget {
  final SafeLensAvatarController controller;
  final String message;
  final double height;

  const SafeLensAvatarGuide({
    super.key,
    required this.controller,
    required this.message,
    this.height = 320,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (message.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F1E8),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        SafeLensAvatar(
          avatarController: controller,
          height: height,
        ),
      ],
    );
  }
}
