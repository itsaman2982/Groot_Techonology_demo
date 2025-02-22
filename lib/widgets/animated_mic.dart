import 'package:flutter/material.dart';

class AnimatedMic extends StatefulWidget {
  final bool isRecording;
  const AnimatedMic(this.isRecording, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedMicState createState() => _AnimatedMicState();
}

class _AnimatedMicState extends State<AnimatedMic>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
      lowerBound: 0.8,
      upperBound: 1.2,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedMic oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent.withOpacity(0.5),
        ),
        child: const Icon(
          Icons.mic,
          size: 80,
          color: Colors.white,
        ),
      ),
    );
  }
}
