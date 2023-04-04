import 'package:flutter/material.dart';

import '../Utils/colors.dart';
import '../Utils/text.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    Key? key,
    required this.controller,
    required this.hint,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool showPass = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      //height: MediaQuery.of(context).size.height*0.06,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: textFieldBackgroundColor),
      child: TextFormField(
        controller: widget.controller,
        cursorColor: focusBorderColor,
        obscureText: !showPass,
        decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            hintText: widget.hint,
            labelText: widget.hint,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle:  TextStyle(
                fontFamily: font_family, color: textLightColor),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    showPass = !showPass;
                  });
                },
                child: Icon(
                  showPass
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xff5b5959),
                  size: 25,
                )),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorBorderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: focusBorderColor, width: 1),
            )),
      ),
    );
  }
}
