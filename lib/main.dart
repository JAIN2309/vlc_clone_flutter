import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'splash/splash_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/audio/my_audio_handler.dart';
import 'package:audio_service/audio_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('vivid_play_box'); // playlists

  // Initialize audio service with our handler
  await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.vividplay.channel.audio',
      androidNotificationChannelName: 'VividPlay Audio',
      androidNotificationOngoing: true,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VividPlay',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.SPLASH,
      getPages: AppPages.pages,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
    );
  }
}
