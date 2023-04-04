import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:service_bank/Utils/urls.dart';
import 'package:service_bank/components/passwordTextField.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/colors.dart';
import '../Utils/constants.dart';
import '../Utils/messages.dart';
import '../Utils/text.dart';
import '../components/textStyle.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key,}) : super(key: key);


  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  bool loader = false;
  bool passError = false;
  bool confirmPassError = false;


  formValidate(){
    setState(() {
      passError=false;
      confirmPassError=false;
    });
    if(passController.text.isEmpty){
      setState(() {
        passError=true;
      });
    }if(confirmPassController.text.isEmpty || confirmPassController.text !=passController.text){
      setState(() {
        confirmPassError=true;
      });
    }else{
      resetPass();
    }
  }

  resetPass() async{
    setState(() {
      loader=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    // var token = prefs.getString('token');
    Map body = {
      'id':id.toString(),
      'password':passController.text
    };
    try {
      http.Response response = await http.post(
          Uri.parse(changePasswordURL),
          body: body);
      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['status'] == 200) {
        showSnackMessage(context, 'Password changed successfully');
        setState(() {
          loader=false;
        });
        Navigator.pop(context);
      } else {
        setState(() {
          loader=false;
        });
        showSnackMessage(context, 'Something went wrong');
      }
    }catch(e){
      print(e);
      setState(() {
        loader=false;
      });
      showSnackMessage(context, 'Something went wrong!\nCheck your inetrnet connection');
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
              Container(
                  alignment: Alignment.centerLeft,

                  child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios,size: 22,color: textLightColor,))),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: textWidget(
                    lblChangePassTitle,
                    TextAlign.center,
                    3,
                    TextOverflow.clip,
                    14,
                    textLightColor,
                    FontWeight.w300,
                    font_family),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              PasswordTextField(controller: passController , hint: 'Password'),
              passError
                  ? Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '  password is required',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 12, color: kRed, fontFamily: font_family),
                  ))
                  : const SizedBox(),
              const SizedBox(height: 20),
              PasswordTextField(controller: confirmPassController , hint: 'Re-enter password'),
              confirmPassError
                  ? Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '  password don\'t match' ,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 12, color: kRed, fontFamily: font_family),
                  ))
                  : const SizedBox(),
              const SizedBox(height: 30),
              InkWell(
                  onTap: () {
                    if (!loader) {
                      formValidate();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: primaryColor),
                    alignment: Alignment.center,
                    child: loader
                        ? Center(
                        child: CircularProgressIndicator(color: kWhite))
                        : textWidget(
                        'Change Password',
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