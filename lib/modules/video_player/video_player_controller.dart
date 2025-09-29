import 'package:get/get.dart';
import 'package:video_player/video_player.dart' as vp;
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class VideoPlayerControllerX extends GetxController {
  vp.VideoPlayerController? player;

  // Reactive variables
  final RxBool isPlayerInitialized = false.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final RxBool isPlaying = false.obs;
  final RxDouble speed = 1.0.obs;

  AudioHandler? audioHandler;

  @override
  void onInit() {
    super.onInit();
    _initAudioHandler();
  }

  /// Initialize AudioHandler
  Future<void> _initAudioHandler() async {
    audioHandler ??= await AudioService.init(
      builder: () => MyAudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.vividplay.channel.audio',
        androidNotificationChannelName: 'VividPlay Audio',
        androidNotificationOngoing: true,
      ),
    );
  }

  /// Initialize the video player
  Future<void> init({required String source, bool isNetwork = true}) async {
    // Dispose existing player if any
    if (player != null) {
      await player!.pause();
      player!.removeListener(_listener);
      await player!.dispose();
      player = null;
    }

    // Create new player
    player = isNetwork
        ? vp.VideoPlayerController.network(source)
        : vp.VideoPlayerController.file(File(source));

    await player!.initialize();

    // Update reactive values
    duration.value = player!.value.duration;
    isPlayerInitialized.value = true;

    player!.addListener(_listener);
    player!.setLooping(false);
    player!.setPlaybackSpeed(speed.value);
    player!.play();

    // AudioService media item
    final mediaItem = MediaItem(
      id: source,
      album: 'Local',
      title: source.split('/').last,
      extras: {'filePath': source},
    );

    // Play via AudioHandler
   if (audioHandler != null) {
  await (audioHandler as MyAudioPlayerHandler).playMediaItem(mediaItem, isNetwork: isNetwork);
}

  }

  /// Listener for video player updates
  void _listener() {
    if (player == null) return;
    position.value = player!.value.position;
    isPlaying.value = player!.value.isPlaying;
    duration.value = player!.value.duration;
  }

  /// Toggle play/pause
  void togglePlay() {
    if (player == null) return;
    if (player!.value.isPlaying) {
      player!.pause();
      isPlaying.value = false;
    } else {
      player!.play();
      isPlaying.value = true;
    }
  }

  /// Seek to a specific position
  void seekTo(Duration to) {
    if (player == null) return;
    player!.seekTo(to);
    position.value = to;
  }

  /// Set playback speed
  void setSpeed(double s) {
    speed.value = s;
    player?.setPlaybackSpeed(s);
  }

  @override
  void onClose() {
    player?.removeListener(_listener);
    player?.dispose();
    super.onClose();
  }
}

/// Custom AudioHandler using just_audio
class MyAudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  MyAudioPlayerHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        _player.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: 0,
    );
  }

Future<void> playMediaItem(MediaItem mediaItem, {bool isNetwork = true}) async {
  if (isNetwork) {
    await _player.setUrl(mediaItem.id);
  } else {
    await _player.setFilePath(mediaItem.extras!['filePath']);
  }
  await _player.play();
}


  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();
}
