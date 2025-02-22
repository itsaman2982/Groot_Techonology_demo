import 'package:demoproject/widgets/waveform_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demoproject/screen/splash/record/controller/recorder_controller.dart';
import 'package:wave_blob/wave_blob.dart';

class AudioVisualizationScreen extends StatefulWidget {
  const AudioVisualizationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AudioVisualizationScreenState createState() =>
      _AudioVisualizationScreenState();
}

class _AudioVisualizationScreenState extends State<AudioVisualizationScreen> {
  final RecordController controller = Get.put(RecordController());

  bool isApplyTapped = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        controller.startRecording();
      }
    });
  }

  @override
  void dispose() {
    if (controller.isRecording.value) {
      controller.stopRecording();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Recording Visualization',
          style: TextStyle(color: Colors.amber),
        ),
        iconTheme: const IconThemeData(color: Colors.amber),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Obx(() {
            final elapsed = controller.elapsedDuration.value;
            final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
            final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');

            return Text(
              "$minutes:$seconds",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            );
          }),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.4,
              height: MediaQuery.sizeOf(context).width * 0.4,
              child: const WaveBlob(
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Listening...",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Obx(() {
            return WaveformWidget(
              amplitude: controller.currentAmplitude.value,
              maxDuration: controller.maxDuration.value,
              elapsedDuration: controller.elapsedDuration.value,
              samples: List.of(controller.samples),
            );
          }),
        ],
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () {
            if (controller.isRecording.value) {
              controller.stopRecording();
              Get.back();
            } else {
              controller.startRecording();
            }
          },
          backgroundColor: Colors.amber,
          child: Icon(
            controller.isRecording.value ? Icons.stop : Icons.mic,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
