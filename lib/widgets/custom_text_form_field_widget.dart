import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String value) onSaved;
  final Function(String value) onChanged;
  final Function(String value) validator;
  final bool emailCheck;
  final String text;
  final Widget suffixIcon;
  final TextInputAction action;
  final TextInputType type;
  final bool obscure;
  final TextEditingController controller;
  final TextDirection direction;
  final int max;
  final InputBorder border;
  final String hintText;
  final List<TextInputFormatter> inputFormatters;
  final String counterText;
  final TextInputType keyboardType;
  final int minLines;
  final int maxLines;
  final String prefixText;
  final bool autocorrect;

  CustomTextFormField({
    this.onSaved,
    this.onChanged,
    this.validator,
    this.emailCheck,
    this.text,
    this.suffixIcon,
    this.action,
    this.type,
    this.obscure = false,
    this.controller,
    this.direction = TextDirection.ltr,
    this.max,
    this.border,
    this.hintText,
    this.inputFormatters,
    this.counterText,
    this.keyboardType,
    this.minLines,
    this.maxLines,
    this.prefixText,
    this.autocorrect = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: this.autocorrect,
      inputFormatters: this.inputFormatters,
      maxLength: this.max,
      textDirection: this.direction,
      controller: this.controller,
      obscureText: this.obscure,
      cursorColor: Colors.black,
      keyboardType: this.keyboardType,
      decoration: InputDecoration(
        prefixText: this.prefixText,
        counterText: this.counterText,
        labelText: this.text,
        border: this.border,
        suffixIcon: this.suffixIcon,
        hintText: this.hintText,
      ),
      onChanged: (value) => this.onChanged(value),
      onSaved: (value) => this.onSaved(value),
      validator: (value) => this.validator(value),
      textInputAction: this.action,
      minLines: this.minLines,
      maxLines: this.minLines,
    );
  }
}
