
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Utils/colors.dart';
import '../Utils/text.dart';

Widget textField(BuildContext context,TextEditingController controller , String hint, TextInputType inputType){
  return Container(
    alignment: Alignment.center,
    //height: MediaQuery.of(context).size.height*0.06,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: textFieldBackgroundColor
    ),
    child: TextFormField(
      controller: controller,
      cursorColor: focusBorderColor,
      keyboardType: inputType,
      inputFormatters: hint=='Phone number'?[
        FilteringTextInputFormatter.allow(RegExp(r'\d')),
        LengthLimitingTextInputFormatter(11),
      ]:[],
      decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: hint,
          labelText: hint,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          floatingLabelStyle:  TextStyle(
              fontFamily: font_family,
              color: textLightColor
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 12
          ),
          suffixIcon: Icon(hint=='Name'?Icons.person_2_outlined:hint=='Username'?Icons.person_2_outlined:hint=='Email'?Icons.mail_outline:Icons.call_outlined, color: textLightColor,size: 25,),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: errorBorderColor , width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: focusBorderColor,
                width: 1
            ),
          )

      ),
    ),
  );
}