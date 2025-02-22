import 'package:demoproject/bindings/recorder_binding.dart';
import 'package:demoproject/screen/splash/record/controller/AudioVisualizationScreen.dart';
import 'package:demoproject/screen/splash/record/controller/recorder_screen.dart';
import 'package:demoproject/screen/splash/splash_screen.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.recorder,
      page: () => const AudioRecorderScreen(),
      binding: RecorderBinding(),
    ),
    GetPage(
      name: Routes.visulizerecorder,
      page: () => const AudioVisualizationScreen(),
    ),
  ];
}
