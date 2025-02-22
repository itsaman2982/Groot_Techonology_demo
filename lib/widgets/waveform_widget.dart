import 'package:flutter/material.dart';

import 'dart:math';

import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';

class WaveformWidget extends StatelessWidget {
  final double amplitude;
  final Duration maxDuration;
  final Duration elapsedDuration;
  final List<double> samples;

  const WaveformWidget({
    super.key,
    required this.amplitude,
    required this.maxDuration,
    required this.elapsedDuration,
    required this.samples,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(1.0, -1.0),
      child: Container(
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: PolygonWaveform(
          samples: samples.isNotEmpty
              ? samples
              : List.generate(60, (index) => amplitude * sin(index * pi / 30)),
          height: 100,
          width: screenWidth - 40,
          style: PaintingStyle.stroke,
          activeColor: Colors.red,
          inactiveColor: Colors.grey,
          absolute: false,
          showActiveWaveform: true,
        ),
      ),
    );
  }
}
