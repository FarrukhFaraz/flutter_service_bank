import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:service_bank/Authorization/sign_in.dart';
import 'package:service_bank/Utils/navigator.dart';
import 'package:service_bank/Utils/urls.dart';
import 'package:service_bank/components/passwordTextField.dart';

import '../Utils/colors.dart';
import '../Utils/constants.dart';
import '../Utils/messages.dart';
import '../Utils/text.dart';
import '../components/textField.dart';
import '../components/textStyle.dart';


class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

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

   Map body = {
     'id':widget.id.toString(),
     'password':passController.text
   };
   try {
     http.Response response = await http.post(
         Uri.parse(resetPasswordURL), body: body);
     Map jsonData = jsonDecode(response.body);
     print(jsonData);

     if (jsonData['status'] == 200) {
       showSnackMessage(context, 'Password changed successfully');
       setState(() {
         loader=false;
       });
       navRemove(context, const SignInScreen());
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
     showSnackMessage(context, 'Something went wrong');
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
                    lblLoginSubtitle,
                    TextAlign.center,
                    3,
                    TextOverflow.clip,
                    16,
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
              SizedBox(
                height: MediaQuery.of(context).size.height*0.025,
              ),
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
              SizedBox(
                height: MediaQuery.of(context).size.height*0.035,
              ),
              InkWell(
                  onTap: () {
                    if (!loader) {
                      formValidate();
                      // navPush(context, const SignInScreen());
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
                        'Reset',
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