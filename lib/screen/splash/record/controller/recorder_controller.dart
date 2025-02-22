import 'dart:async';

import 'package:demoproject/data/models/audio_recording.dart';
import 'package:demoproject/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class RecordController extends GetxController {
  final _recorder = FlutterSoundRecorder();
  final _player = FlutterSoundPlayer();
  final isRecording = false.obs;
  final isPlaying = false.obs;
  final recordings = <AudioRecording>[].obs;
  final currentAmplitude = 0.0.obs;

  final maxDuration = Duration.zero.obs;
  final elapsedDuration = Duration.zero.obs;
  final samples = <double>[].obs;
  Timer? _amplitudeTimer;
  Timer? _playbackTimer;

  List<double> amplitudeBuffer = [];
  static const int bufferSize = 5; // Adjust to control smoothness
  @override
  void onInit() {
    super.onInit();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      Get.snackbar('Error', 'Microphone permission is required');
      return;
    }

    await _recorder.openRecorder();
    await _player.openPlayer();
  }

  Future<void> startRecording() async {
    if (_recorder.isRecording || isRecording.value) {
      if (kDebugMode) {
        print("Recording is already running. Skipping start.");
      }
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';

    try {
      await _recorder
          .setSubscriptionDuration(const Duration(milliseconds: 100));

      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.pcm16WAV,
        audioSource: AudioSource.microphone,
      );

      isRecording.value = true;
      maxDuration.value = Duration.zero;
      elapsedDuration.value = Duration.zero;
      samples.clear(); // ✅ Clear old waveform data before new recording starts

      _recorder.onProgress!.listen((event) {
        if (!isRecording.value) return;

        elapsedDuration.value = event.duration;

        // ✅ Generate waveform data dynamically
        double amplitude = event.decibels != null
            ? (event.decibels! / 120).clamp(0.0, 1.0)
            : 0.0;

        currentAmplitude.value = amplitude;

        samples.add(amplitude);
        if (samples.length > 100) {
          samples.removeAt(0); // ✅ Maintain a rolling buffer of 100 values
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error starting recorder: $e");
      }
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording.value) return;

    try {
      final path = await _recorder.stopRecorder();
      isRecording.value = false;

      _amplitudeTimer?.cancel();

      if (path != null) {
        final duration = await getAudioDuration(path);
        final waveform = await extractWaveformSamples(path);

        maxDuration.value = duration;
        samples.assignAll(waveform);

        final recording = AudioRecording(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          filePath: path,
          timestamp: DateTime.now(),
          duration: duration,
        );

        if (!recordings.any((rec) => rec.filePath == recording.filePath)) {
          recordings.add(recording);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error stopping recorder: $e");
      }
    }
  }

  void goToAudioVisualizationScreen() {
    if (isRecording.value) return;

    startRecording();

    Get.toNamed(Routes.visulizerecorder)!.then((_) {});
  }

  Future<void> playRecording(String filePath) async {
    if (isPlaying.value) return;

    try {
      await _player.startPlayer(
        fromURI: filePath,
        codec: Codec.pcm16WAV,
        whenFinished: () {
          isPlaying.value = false;
          _playbackTimer?.cancel(); // Stop waveform animation
        },
      );

      isPlaying.value = true;
      elapsedDuration.value = Duration.zero;

      _player.onProgress!.listen((event) {
        elapsedDuration.value = event.position; // Update progress dynamically
      });

      _playbackTimer =
          Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (!isPlaying.value) {
          timer.cancel();
          return;
        }

        // Generate smooth waveform effect for visualization
        double amplitude =
            (0.5 + 0.5 * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000);
        currentAmplitude.value = amplitude;

        samples.add(amplitude);
        if (samples.length > 100) {
          samples.removeAt(0);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error playing recording: $e");
      }
    }
  }

  Future<void> stopPlaying() async {
    if (isPlaying.value) {
      await _player.stopPlayer();
      isPlaying.value = false;
      elapsedDuration.value = Duration.zero;
      _playbackTimer?.cancel();
      await _player.pausePlayer();
    }
  }

  Future<void> shareRecording(String filePath) async {
    // ignore: deprecated_member_use
    await Share.shareFiles([filePath]);
  }

  Future<void> deleteRecording(AudioRecording recording) async {
    final file = File(recording.filePath);
    if (await file.exists()) {
      await file.delete();
    }
    recordings.remove(recording);
  }

  @override
  void onClose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.onClose();
  }

  Future<Duration> getAudioDuration(String path) async {
    final player = FlutterSoundPlayer();

    try {
      await player.openPlayer();
      Duration? duration = await player.startPlayer(fromURI: path);
      await player.closePlayer();
      return duration ?? Duration.zero;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting duration: $e");
      }
      return Duration.zero;
    }
  }

  Future<List<double>> extractWaveformSamples(String path) async {
    return List.generate(100, (index) => (index % 10) * 0.1);
  }
}
