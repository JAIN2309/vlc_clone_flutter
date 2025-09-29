import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _player = AudioPlayer();
  MediaItem? _current;

  MyAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    _player.playbackEventStream.listen((event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {MediaAction.seek},
        androidCompactActionIndices: const [0,1,3],
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ));
    }, onError: (e, st) {
      if (kDebugMode) print('Audio handler error: $e');
     playbackState.add(
  playbackState.value.copyWith(
    processingState: AudioProcessingState.idle,
    playing: false,
  ),
);
 });
  }

  Future<void> playMediaItem(MediaItem item, {bool isLocal = true}) async {
    _current = item;
    mediaItem.add(item);

    try {
      if (isLocal) {
        await _player.setFilePath(item.extras?['filePath'] ?? item.id);
      } else {
        await _player.setUrl(item.id);
      }
      await play();
    } catch (e) {
      if (kDebugMode) print('Failed to load media: $e');
    }
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);
}
