import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatslink/data/models/Data.dart';
import 'package:whatslink/data/provider/database_helper.dart';

class HistoryController extends GetxController {
  var listItems = List<Data>().obs;

  static const platform =
      const MethodChannel('flutter_contacts/launch_contacts');

  @override
  void onInit() {
    getAllItems();
    super.onInit();
  }

  final _name = "".obs;
  get name => this._name.value;
  set name(value) => this._name.value = value;

  onChangedName(value) {
    this.name = value;
  }

  validateNumber(value) =>
      value.length > 0 ? null : 'O nome não pode ficar em branco.';

  onSavedName(value) => this.name = value;

  getAllItems() {
    DatabaseHelper.instance.queryAllRows().then((value) {
      value.forEach((element) {
        listItems.add(Data(
          id: element['id'],
          message: element['message'],
          number: element['number'],
          uri: element['uri'],
          isSaved: element['isSaved'],
        ));
      });
    });
  }

  launchURL(String uri) async {
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  void launchContacts() async {
    try {
      await platform.invokeMethod('launch');
    } on PlatformException catch (e) {
      print("Failed to launch contacts: ${e.message}");
    }
  }

  void addToContacts({String number, String name}) async {
    try {
      PermissionStatus permission = await Permission.contacts.status;
      if (permission != PermissionStatus.granted) {
        await Permission.contacts.request();
        PermissionStatus permission = await Permission.contacts.status;
        if (permission == PermissionStatus.granted) {
          List<Item> phones = [
            Item(label: 'mobile', value: '+55$number'),
          ];
          Contact newContact = Contact(givenName: name, phones: phones);
          await ContactsService.addContact(newContact);
        } else {
          Get.dialog(
            AlertDialog(
              title: Text("Permissão necessária"),
              content: Text(
                  "A permissão de acesso aos contatos é necessária para o correto funcionamento do aplicativo."),
              actions: [
                FlatButton(
                  onPressed: () => Get.back(),
                  child: Text("FECHAR"),
                ),
              ],
            ),
          );
          //_handleInvalidPermissions(context);
        }
      } else {
        List<Item> phones = [
          Item(label: 'mobile', value: '+55$number'),
        ];
        Contact newContact = Contact(givenName: name, phones: phones);
        await ContactsService.addContact(newContact);
      }
    } catch (e) {
      print(e);
    }
  }

  findContact() async {
    Iterable<Contact> contact = await ContactsService.getContacts(query: "");
    for (var item in contact) {
      print(item.identifier);
    }
  }

  void updateIsSaved(Data item) async {
    print(item.toMap());
    await DatabaseHelper.instance.update(item);
  }

  void deleteItem(int id) async {
    await DatabaseHelper.instance.delete(id);
    listItems.removeWhere((element) => element.id == id);
  }

  void deleteAllItems(String table) async {
    await DatabaseHelper.instance.clearTable(table);
    listItems.clear();
  }
}