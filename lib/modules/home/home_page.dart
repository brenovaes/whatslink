import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:share/share.dart';
import 'package:whatslink/modules/about/about_page.dart';
import 'package:whatslink/theme/colors_theme.dart';
import 'package:whatslink/widgets/custom_text_form_field_widget.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  final controller = Get.put(HomeController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var maskFormatter = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusScope.of(context).requestFocus(FocusNode())},
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF075E54),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('WhatsLink'),
          elevation: 0,
          backgroundColor: Color(0xFF075E54),
          actions: [
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () => Get.toNamed('/history'),
            ),
            IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) =>
                            AboutPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          animation = CurvedAnimation(
                              curve: Curves.easeOut, parent: animation);
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    )),
          ],
        ),
        body: SafeArea(
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
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20, top: 50),
                          child: Text(
                            "Digite o telefone e a mensagem:",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        CustomTextFormField(
                          onChanged: (value) => controller.onChangedNumber(
                              maskFormatter.getUnmaskedText().toString(),
                              context),
                          validator: (value) => controller.validateNumber(
                              maskFormatter.getUnmaskedText().toString()),
                          onSaved: (value) => controller.onSavedNumber(
                              maskFormatter.getUnmaskedText().toString()),
                          text: 'DDD + Telefone',
                          border: OutlineInputBorder(),
                          max: 15,
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          hintText: '(99) 99999-9999',
                          prefixText: '+55 ',
                          inputFormatters: [maskFormatter],
                          counterText: "",
                          action: TextInputAction.next,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                          onChanged: (value) =>
                              controller.onChangedMessage(value),
                          validator: (value) =>
                              controller.validateMessage(value),
                          onSaved: (value) => controller.onSavedMessage(value),
                          text: 'Mensagem',
                          border: OutlineInputBorder(),
                          max: 150,
                          hintText: 'Ex: Olá!',
                          keyboardType: TextInputType.text,
                          minLines: 3,
                          maxLines: 5,
                          action: TextInputAction.done,
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        Container(
                          width: Get.width,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                              Color(0xFF075E54),
                            )),
                            onPressed: () async {
                              final FormState form = formKey.currentState;
                              if (form.validate()) {
                                form.save();
                                await controller.saveItem();
                                //form.reset();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FontAwesomeIcons.whatsapp),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Enviar pelo WhatsApp'),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: Get.width,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                              Color(0xFF075E54),
                            )),
                            onPressed: () {
                              final FormState form = formKey.currentState;
                              if (form.validate()) {
                                form.save();
                                controller.url = controller.generateUrl();
                                Get.dialog(
                                  AlertDialog(
                                    title: Text('Link gerado'),
                                    content: Text(
                                        'Seu link está pronto! Deseja copiar ou compartilhar?'),
                                    actions: [
                                      FlatButton(
                                        child: Text(
                                          'COPIAR',
                                          style: TextStyle(color: whatsColor),
                                        ),
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                              text: controller.url));
                                          Get.back();
                                          scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Copiado para a área de transferência",
                                              ),
                                              action: SnackBarAction(
                                                label: 'FECHAR',
                                                onPressed: () => scaffoldKey
                                                    .currentState
                                                    .hideCurrentSnackBar(),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      FlatButton(
                                          child: Text(
                                            'COMPARTILHAR',
                                            style: TextStyle(color: whatsColor),
                                          ),
                                          onPressed: () async {
                                            Get.back();
                                            await Share.share(controller.url);
                                          }),
                                    ],
                                  ),
                                  barrierDismissible: false,
                                );
                                //await controller.saveItem();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.link),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Gerar link'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
