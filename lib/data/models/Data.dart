class Data {
  final int id;
  final String number;
  final String message;
  final String uri;
  final int isSaved;

  Data({this.id, this.number, this.message, this.uri, this.isSaved});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'message': message,
      'uri': uri,
      'isSaved': isSaved
    };
  }
}
