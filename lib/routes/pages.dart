import 'package:get/get.dart';
import 'package:whatslink/modules/history/history_bindings.dart';
import 'package:whatslink/modules/history/history_page.dart';
import 'package:whatslink/modules/home/home_bindings.dart';
import 'package:whatslink/modules/home/home_page.dart';
import 'package:whatslink/modules/splash/splash_page.dart';

part './routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashPage(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.HISTORY,
      page: () => HistoryPage(),
      binding: HistoryBinding(),
    ),
  ];
}
