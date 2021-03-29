import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:whatslink/data/models/Data.dart';
import 'package:whatslink/theme/colors_theme.dart';
import 'package:whatslink/widgets/custom_text_form_field_widget.dart';

import 'history_controller.dart';

class HistoryPage extends GetView<HistoryController> {
  final controller = Get.put(HistoryController());

  final maskFormatter = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusScope.of(context).requestFocus(FocusNode())},
      child: Scaffold(
        backgroundColor: Color(0xFF075E54),
        appBar: AppBar(
          title: Text('Histórico'),
          elevation: 0,
          backgroundColor: Color(0xFF075E54),
          actions: [
            Obx(
              () => controller.listItems.length > 0
                  ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => Get.dialog(
                        AlertDialog(
                          title: Text("Excluir tudo"),
                          content: Text(
                            "Tem certeza que deseja excluir todos os registros? Isso não exclui os contatos salvos por meio do aplicativo na agenda, apenas do histórico. Esta operação não poderá ser desfeita.",
                          ),
                          actions: [
                            FlatButton(
                              child: Text(
                                'CANCELAR',
                                style: TextStyle(color: whatsColor),
                              ),
                              onPressed: () => Get.back(),
                            ),
                            FlatButton(
                              child: Text(
                                'CONFIRMAR',
                                style: TextStyle(color: whatsColor),
                              ),
                              onPressed: () {
                                controller.deleteAllItems('items');
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: Container(
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  color: Colors.white,
                ),
                child: Obx(
                  () => (controller.listItems.isEmpty)
                      ? Center(
                          child: Text(
                            "Não há nada aqui...",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.listItems.length,
                          itemBuilder: (context, index) {
                            var item = controller.listItems[index];
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Card(
                                    elevation: 4,
                                    child: ListTile(
                                      trailing: PopUpMenu(
                                        id: item.id,
                                        uri: item.uri,
                                        number: item.number,
                                        isSaved: item.isSaved,
                                        message: item.message,
                                      ),
                                      title: Text(
                                          '+55 ${item.number.length == 11 ? maskFormatter.maskText(item.number) : MaskTextInputFormatter(mask: '(##) ####-####', filter: {
                                              "#": RegExp(r'[0-9]')
                                            }).maskText(item.number)} '),
                                      subtitle: Text(item.message),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
          //backgroundColor: Colors.black,
        ),
      ),
    );
  }
}

class PopUpMenu extends StatelessWidget {
  final controller = Get.put(HistoryController());
  final String uri;
  final int id;
  final String number;
  int isSaved;
  final String message;

  PopUpMenu({this.uri, this.id, this.number, this.isSaved, this.message});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case 'launch':
            {
              controller.launchURL(uri);
            }
            break;
          case 'add':
            {
              isSaved.isEqual(1)
                  ? Get.dialog(
                      AlertDialog(
                        title: Text('Ops!'),
                        content: Text('Esse contato foi salvo recentemente.'),
                        actions: [
                          FlatButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'FECHAR',
                              style: TextStyle(color: whatsColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Get.dialog(
                      AlertDialog(
                        title: Text("Salvar contato"),
                        content: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Para salvar esse contato, digite um nome:",
                              ),
                              SizedBox(height: 10),
                              CustomTextFormField(
                                onChanged: (value) =>
                                    controller.onChangedName(value),
                                validator: (value) =>
                                    controller.validateNumber(value),
                                onSaved: (value) =>
                                    controller.onSavedName(value),
                                text: 'Nome',
                                border: OutlineInputBorder(),
                                keyboardType: TextInputType.text,
                                counterText: "",
                                action: TextInputAction.done,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          FlatButton(
                            child: Text(
                              'CANCELAR',
                              style: TextStyle(color: whatsColor),
                            ),
                            onPressed: () => Get.back(),
                          ),
                          FlatButton(
                            child: Text(
                              'CONFIRMAR',
                              style: TextStyle(color: whatsColor),
                            ),
                            onPressed: () async {
                              final FormState form = formKey.currentState;
                              if (form.validate()) {
                                form.save();
                                if (await controller.addToContacts(
                                  name: controller.name,
                                  number: number,
                                )) {
                                  isSaved = 1;
                                  controller.updateIsSaved(
                                    new Data(
                                      id: id,
                                      uri: uri,
                                      message: message,
                                      number: number,
                                      isSaved: isSaved,
                                    ),
                                  );
                                  form.reset();
                                  Get.back();
                                  Get.dialog(
                                    AlertDialog(
                                      title: Text("Contato salvo!"),
                                      content: Text(
                                        "O novo contato foi salvo na sua agenda.",
                                      ),
                                      actions: [
                                        FlatButton(
                                          onPressed: () => Get.back(),
                                          child: Text('FECHAR'),
                                        ),
                                      ],
                                    ),
                                  );
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
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    );
            }
            break;
          case 'delete':
            {
              Get.dialog(
                AlertDialog(
                  title: Text("Excluir registro"),
                  content: Text(
                    "Tem certeza que deseja excluir esse registro? Isso não exclui o contato salvo por meio do aplicativo na agenda, apenas do histórico. Esta operação não poderá ser desfeita.",
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'CANCELAR',
                        style: TextStyle(color: whatsColor),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        controller.deleteItem(id);
                        Get.back();
                      },
                      child: Text(
                        'CONFIRMAR',
                        style: TextStyle(color: whatsColor),
                      ),
                    ),
                  ],
                ),
              );
            }
            break;
        }
      },
      itemBuilder: (context) => [
        buildPopupMenuItem(
          'launch',
          FontAwesomeIcons.whatsapp,
          'Abrir no WhatsApp',
          Color(0xFF075E54),
        ),
        buildPopupMenuItem(
          'add',
          Icons.person_add,
          'Adicionar aos contatos',
          Colors.blue,
        ),
        buildPopupMenuItem(
          'delete',
          Icons.delete,
          'Remover do histórico',
          Colors.red,
        ),
      ],
    );
  }

  PopupMenuItem<String> buildPopupMenuItem(
      String action, IconData iconData, String label, Color color,
      {bool isEnabled = true}) {
    return PopupMenuItem(
      enabled: isEnabled,
      value: action,
      child: Row(
        children: [
          Icon(
            iconData,
            size: 22,
            color: color,
          ),
          SizedBox(width: 7),
          Text(label),
        ],
      ),
    );
  }
}
