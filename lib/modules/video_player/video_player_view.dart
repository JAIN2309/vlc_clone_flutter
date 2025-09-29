import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart' as vp;
import 'video_player_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoPlayerView extends StatelessWidget {
  VideoPlayerView({Key? key}) : super(key: key);

  Future<bool> _ensurePermissions(bool isNetwork) async {
    if (isNetwork) return true;
    if (await Permission.storage.isGranted) return true;
    final res = await Permission.storage.request();
    if (res.isGranted) return true;
    if (await Permission.photos.isGranted) return true;
    return false;
  }

  @override

  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final source = args['source'] as String? ?? '';
    final isNetwork = args['isNetwork'] as bool? ?? true;
    final ctrl = Get.find<VideoPlayerControllerX>();
    if (!ctrl.isPlayerInitialized.value) {
      _ensurePermissions(isNetwork).then((granted) {
        if (!granted) {
          Get.snackbar('Permission', 'Storage permission required to play local files');
          return;
        }
        ctrl.init(source: source, isNetwork: isNetwork);
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Player'), backgroundColor: Colors.black87),
      body: Obx(() {
        if (!ctrl.isPlayerInitialized.value) return const Center(child: CircularProgressIndicator());
        final player = ctrl.player!;
        return Stack(children: [
          Center(child: AspectRatio(aspectRatio: player.value.aspectRatio, child: vp.VideoPlayer(player))),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildControls(ctrl)),
        ]);
      }),
    );
  }

  Widget _buildControls(VideoPlayerControllerX c) {
    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Obx(() => Slider(
          value: c.position.value.inMilliseconds.toDouble().clamp(0.0, c.duration.value.inMilliseconds.toDouble() == 0 ? 1.0 : c.duration.value.inMilliseconds.toDouble()),
          max: c.duration.value.inMilliseconds.toDouble() == 0 ? 1.0 : c.duration.value.inMilliseconds.toDouble(),
          onChanged: (v) => c.seekTo(Duration(milliseconds: v.toInt())),
        )),
        Row(children: [
          Obx(() => IconButton(icon: Icon(c.isPlaying.value ? Icons.pause : Icons.play_arrow), color: Colors.white, onPressed: c.togglePlay)),
          Obx(() => Text(_formatDuration(c.position.value) + ' / ' + _formatDuration(c.duration.value), style: TextStyle(color: Colors.white))),
          Spacer(),
          PopupMenuButton<double>(color: Colors.black87, onSelected: (v) => c.setSpeed(v), itemBuilder: (ctx) => [0.5,1.0,1.5,2.0].map((e) => PopupMenuItem(value: e, child: Text('${e}x'))).toList(), child: Padding(padding: const EdgeInsets.symmetric(horizontal:8.0), child: Text('Speed', style: TextStyle(color: Colors.white)))),
        ]),
      ]),
    );
  }

  String _formatDuration(Duration d) {
    if (d == Duration.zero) return '00:00';
    String two(int n) => n.toString().padLeft(2, '0');
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return '$m:$s';
  }
}
