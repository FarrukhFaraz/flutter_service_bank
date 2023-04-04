import 'dart:async';

import 'package:flutter/material.dart';
import 'package:service_bank/Utils/text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authorization/sign_in.dart';
import '../Utils/colors.dart';
import '../Utils/messages.dart';
import '../Utils/navigator.dart';


bool logOutLoader = false;

logOut(BuildContext context) async {
  return showDialog(
    useSafeArea: true,
    barrierDismissible: false,
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, StateSetter setState) {
        return AlertDialog(
          title: const Text("Logout"),
          titleTextStyle: TextStyle(fontSize: 22,fontFamily: font_family,color: textHeadingColor,fontWeight: FontWeight.w500),
          content: logOutLoader
              ? Container(
              height: MediaQuery.of(context).size.height * 0.09,
              alignment: Alignment.center,
              child: const CircularProgressIndicator())
              : const Text("Are you sure to logout"),
          contentTextStyle: TextStyle(fontFamily: font_family,fontSize: 16,color: textLightColor),
          actions: [
            logOutLoader
                ? const Text("")
                : TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6)),
                width: MediaQuery.of(context).size.width * 0.18,
                child: Text(
                  "No",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                      fontFamily: font_family,
                      fontSize: 16),
                ),
              ),
            ),
            logOutLoader
                ? const Text("")
                : TextButton(
              onPressed: () async {
                setState(() {
                  logOutLoader = true;
                });
                SharedPreferences prefs =
                await SharedPreferences.getInstance();

                await prefs.clear();
                Timer.periodic(const Duration(seconds: 4), (t) {
                  t.cancel();
                  Navigator.pop(context);
                  setState((){
                    logOutLoader=false;
                  });
                  showSnackMessage(context, "Logout successfully");
                  navRemove(context, const SignInScreen());
                });

              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6)),
                width: MediaQuery.of(context).size.width * 0.18,
                child: Text(
                  "Yes",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                      fontFamily: font_family,
                      fontSize: 16),
                ),
              ),
            )
          ],
        );
      },
    ),
  );
}
