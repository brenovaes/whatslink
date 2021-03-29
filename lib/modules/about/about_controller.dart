import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:whatslink/utils/helper.dart';

class AboutController extends GetxController {
  final _version = ''.obs;

  get version => this._version.value;
  set version(value) => this._version.value = value;

  //AboutController({this.version});

  @override
  void onInit() {
    super.onInit();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    this.version = info.version;
    print(info.version);
  }

  final Utils utils = Utils();

  launchUrl(uri) {
    utils.launchURL(uri);
  }

  /*String getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      return packageInfo.version;
    });
  }*/
}
