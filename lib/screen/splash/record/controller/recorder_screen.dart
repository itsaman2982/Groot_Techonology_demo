import 'package:demoproject/screen/splash/record/controller/recorder_controller.dart';
import 'package:demoproject/widgets/custom_fab.dart';
import 'package:demoproject/widgets/recording_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioRecorderScreen extends GetView<RecordController> {
  const AudioRecorderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Audio Recorder',
          style: TextStyle(color: Colors.amber),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Obx(() => ListView.builder(
                  itemCount: controller.recordings.length,
                  itemBuilder: (context, index) {
                    final recording =
                        controller.recordings.reversed.toList()[index];
                    return RecordingListItem(
                      recording: recording,
                      onPlay: () =>
                          controller.playRecording(recording.filePath),
                      onPause: () => controller.stopPlaying(),
                      onDelete: () => controller.deleteRecording(recording),
                      onShare: () =>
                          controller.shareRecording(recording.filePath),
                    );
                  },
                )),
          ),
        ],
      ),
      floatingActionButton: CustomFAB(onPressed: () {
        controller.goToAudioVisualizationScreen();
      }),
    );
  }
}
