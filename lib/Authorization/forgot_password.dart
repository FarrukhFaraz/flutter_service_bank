import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:service_bank/Authorization/reset_password.dart';
import 'package:service_bank/Utils/navigator.dart';
import 'package:service_bank/Utils/urls.dart';

import '../Utils/colors.dart';
import '../Utils/constants.dart';
import '../Utils/messages.dart';
import '../Utils/text.dart';
import '../components/textField.dart';
import '../components/textStyle.dart';



class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController mailController = TextEditingController();

  bool mailError = false;
  bool invalidMail = false;
  bool loader = false;


  bool validateEmail(String email) {
    // Define a regex pattern to match email addresses
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    // Use the pattern to validate the email address
    return regex.hasMatch(email);
  }

  formValidate(){
    setState(() {
      mailError=false;
    });
    if(mailController.text.isEmpty){
      setState(() {
        mailError=true;
      });
    }else{
      if(!validateEmail(mailController.text)){
        setState(() {
          invalidMail=true;
        });
      }else{
        searchAccountApi();
      }
    }
  }

  searchAccountApi()async{
    setState(() {
      loader=true;
    });

    Map body = {"email": mailController.text.trim()};
    try {
      http.Response response =
      await http.post(Uri.parse(searchURL), body: body);
      Map jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 200) {
        // auth = EmailAuth(sessionName: "Education");
        setState(() {
          loader = false;
        });
        navPush(context, ResetPassword(id: jsonData['user']['id'].toString()));
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, 'No user found with this email');
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
      showSnackMessage(
          context, 'Check your internet connection\nTry again later');
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.95),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
              vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: textWidget(
                    lblForgotPassTitle,
                    TextAlign.center,
                    3,
                    TextOverflow.clip,
                    16,
                    textLightColor,
                    FontWeight.w300,
                    font_family),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              textField(context , mailController, 'Email', TextInputType.phone),
              mailError
                  ? Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '  email is required',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 12, color: kRed, fontFamily: font_family),
                  ))
                  : const SizedBox(),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.035,
              ),
              InkWell(
                  onTap: () {
                    if (!loader) {
                      formValidate();
                      // navPush(context, const ResetPassword(id: '2'));
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.06,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: primaryColor),
                    alignment: Alignment.center,
                    child: loader
                        ? Center(
                        child: CircularProgressIndicator(color: kWhite))
                        : textWidget(
                        'Search',
                        TextAlign.center,
                        1,
                        TextOverflow.clip,
                        18,
                        kWhite,
                        FontWeight.bold,
                        font_family),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
