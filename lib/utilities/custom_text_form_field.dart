import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final bool obscure;
  final TextInputType keyboardType;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final String hint;

  CustomTextFormField(
      {this.onSaved,
      this.obscure = false,
      this.validator,
      this.keyboardType,
      this.hint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.center,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscure,
      onSaved: onSaved,
      decoration: kInputFieldDecoration.copyWith(hintText: hint),
    );
  }
}
