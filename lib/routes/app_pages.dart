import 'package:get/get.dart';
import '../splash/splash_view.dart';
import '../modules/home/home_view.dart';
import '../modules/browser/browser_view.dart';
import '../modules/playlist/playlist_view.dart';
import '../modules/video_player/video_player_binding.dart';
import '../modules/video_player/video_player_view.dart';

part 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.SPLASH, page: () => SplashView()),
    GetPage(name: Routes.HOME, page: () => HomeView()),
    GetPage(name: Routes.BROWSER, page: () => BrowserView()),
    GetPage(name: Routes.PLAYLIST, page: () => PlaylistView()),
    GetPage(name: Routes.VIDEO, page: () => VideoPlayerView(), binding: VideoPlayerBinding()),
  ];
}
