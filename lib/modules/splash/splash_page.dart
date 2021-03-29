import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatslink/routes/pages.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void initState() {
    super.initState();
    Future.delayed(
        Duration(milliseconds: 2500), () => Get.offAllNamed(Routes.HOME));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                'teste',
              ),
            )
          ],
        ),
      ),
    );
  }
}
