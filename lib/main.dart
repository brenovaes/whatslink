import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatslink/routes/pages.dart';
import 'package:whatslink/theme/app_theme.dart';

import 'modules/home/home_page.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    defaultTransition: Transition.fadeIn,
    home: HomePage(),
    getPages: AppPages.pages,
    initialRoute: Routes.HOME,
    theme: appThemeData,
  ));
}
