import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatslink/modules/about/about_controller.dart';
import 'package:whatslink/utils/whats_link_icons.dart';

class AboutPage extends GetView<AboutController> {
  final controller = Get.put(AboutController());
  final String git = 'https://github.com/brenovaes/whatslink';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.85),
      body: SafeArea(
        child: Container(
          height: Get.height,
          width: Get.width,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                height: 57,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 32,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        WhatsLink.whatslink,
                        size: 140,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      InkWell(
                        child: Text(
                          git,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onTap: () => controller.launchUrl(git),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Made with',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Flutter',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Version:',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Obx(
                            () => Text(
                              "${controller.version}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
