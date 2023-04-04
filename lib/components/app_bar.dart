
import 'package:flutter/material.dart';
import 'package:service_bank/Utils/text.dart';

import '../Authorization/change_password.dart';
import '../Utils/colors.dart';
import '../Utils/navigator.dart';
import 'logout.dart';

PreferredSizeWidget appBar(BuildContext context , String title){
  return AppBar(
    title: Text(title),
    centerTitle: true,
    titleTextStyle: TextStyle(fontFamily: font_family, fontSize: 20),
    backgroundColor: primaryColor,
    leading: Container(),
    elevation: 0,
    actions: [
      PopupMenuButton<String>(
        onSelected: (val) {
          if (val == 'changePassword') {
            // Navigator.pop(context);
            navPush(context, const ChangePassword());
          } else if (val == 'logout') {
            logOut(context);
          }
        },
        elevation: 1,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'changePassword',
            textStyle: TextStyle(fontFamily: font_family , fontSize: 16,color: textLightColor),
            child: const Text('Change Password'),
          ),
           PopupMenuItem<String>(
            value: 'logout',
            textStyle: TextStyle(fontFamily: font_family , fontSize: 16,color: textLightColor),
            child:const Text('LogOut'),
          ),
        ],
      ),
    ],
  );
}