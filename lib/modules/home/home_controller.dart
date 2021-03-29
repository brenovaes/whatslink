import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:whatslink/data/models/Data.dart';
import 'package:whatslink/data/provider/database_helper.dart';
import 'package:whatslink/utils/helper.dart';

class HomeController extends GetxController {
  final Utils utils = Utils();

  final _number = "".obs;
  get number => this._number.value;
  set number(value) => this._number.value = value;

  final _message = "".obs;
  get message => this._message.value;
  set message(value) => this._message.value = value;

  final _url = "".obs;
  get url => this._url.value;
  set url(value) => this._url.value = value;

  onChangedNumber(value, context) {
    this.number = value;
    this.number.toString().length == 11
        ? FocusScope.of(context).nextFocus()
        : null;
  }

  onChangedMessage(value) => this.message = value;

  onSavedNumber(value) => this.number = value;
  onSavedMessage(value) => this.message = value;

  validateNumber(value) => value.length == 10 || value.length == 11
      ? null
      : 'Insira um número válido.';

  validateMessage(value) =>
      value.length >= 0 ? null : 'Insira uma mensagem válida.';

  // launchURL(uri) async {
  //   if (await canLaunch(uri)) {
  //     await launch(uri);
  //   } else {
  //     throw 'Could not launch $uri';
  //   }
  // }

  String generateUrl() => utils.generateUrl(this.message, this.number);

  saveItem() {
    String uri = generateUrl();

    final Data item = Data(
      number: this.number,
      message: this.message,
      uri: uri,
      isSaved: 0,
    );

    DatabaseHelper.instance.insert(item);

    utils.launchURL(uri);
  }
}
