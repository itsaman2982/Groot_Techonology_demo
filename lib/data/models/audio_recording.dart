class AudioRecording {
  final String id;
  final String filePath;
  final DateTime timestamp;
  final Duration duration;

  AudioRecording({
    required this.id,
    required this.filePath,
    required this.timestamp,
    required this.duration,
  });
}
