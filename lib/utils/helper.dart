import 'package:url_launcher/url_launcher.dart';

class Utils {
  String generateUrl(String message, String number) {
    Map<String, String> queryParams = {};
    message == "" ? null : queryParams.addAll({'text': message});
    var uri = Uri.https('wa.me', '/55$number', queryParams).toString();
    return uri;
  }

  launchURL(uri) async {
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
