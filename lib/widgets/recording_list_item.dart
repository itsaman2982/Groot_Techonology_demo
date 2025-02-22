import 'package:demoproject/data/models/audio_recording.dart';
import 'package:demoproject/screen/splash/record/controller/recorder_controller.dart';
import 'package:demoproject/widgets/waveform_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordingListItem extends StatefulWidget {
  final AudioRecording recording;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  const RecordingListItem({
    super.key,
    required this.recording,
    required this.onPlay,
    required this.onPause,
    required this.onDelete,
    required this.onShare,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RecordingListItemState createState() => _RecordingListItemState();
}

class _RecordingListItemState extends State<RecordingListItem> {
  bool isPlaying = false;
  final RecordController controller = Get.find<RecordController>();

  void _togglePlayback() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      widget.onPlay();
    } else {
      widget.onPause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _togglePlayback,
      child: Card(
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Recording ${widget.recording.timestamp.toString().split('.').first}',
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                'Duration: ${widget.recording.duration.toString().split('.').first}',
                style: TextStyle(color: Colors.black.withOpacity(0.7)),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Container(
                      height: 50,
                      width: 50,
                      color: Colors.black,
                      child: InkWell(
                        onTap: _togglePlayback,
                        child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (isPlaying)
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: WaveformWidget(
                    amplitude: controller.currentAmplitude.value,
                    maxDuration: controller.maxDuration.value,
                    elapsedDuration: controller.elapsedDuration.value,
                    samples: List.of(controller.samples),
                  ),
                );
              }),
            if (isPlaying)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.black),
                    onPressed: widget.onShare,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
