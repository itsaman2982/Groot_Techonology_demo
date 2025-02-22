import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final Function() onPressed;

  const CustomFAB({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: onPressed,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        mini: false,
        heroTag: null,
        child: const Icon(
          Icons.mic,
          color: Colors.black,
        ),
      ),
    );
  }
}
