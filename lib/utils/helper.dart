class Utils {
  String generateUrl(String message, String number) {
    Map<String, String> queryParams = {};
    message == "" ? null : queryParams.addAll({'text': message});
    var uri = Uri.https('wa.me', '/55$number', queryParams).toString();
    return uri;
  }
}
