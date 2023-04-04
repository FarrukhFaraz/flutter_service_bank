import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:service_bank/Authorization/forgot_password.dart';
import 'package:service_bank/Authorization/sign_up.dart';
import 'package:service_bank/Screens/home_screen.dart';
import 'package:service_bank/Screens/under_verification.dart';
import 'package:service_bank/Utils/colors.dart';
import 'package:service_bank/Utils/navigator.dart';
import 'package:service_bank/Utils/text.dart';
import 'package:service_bank/Utils/urls.dart';
import 'package:service_bank/components/passwordTextField.dart';
import 'package:service_bank/components/textField.dart';
import 'package:service_bank/components/textStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/CheckConnection.dart';
import '../Utils/constants.dart';
import '../Utils/messages.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Text Field Controller
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loader = false;
  bool usernameError = false;
  bool passError = false;

  formValidate() {
    setState(() {
      usernameError = false;
      passError = false;
    });
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      if (passwordController.text.isEmpty) {
        setState(() {
          passError = true;
        });
      }
      if (usernameController.text.isEmpty) {
        setState(() {
          usernameError = true;
        });
      }
    } else {
      // loginApi();
      checkConnectivity();
    }
  }

  checkConnectivity()async{
    if(await connection()){
      loginApi();
    }else{
      showSnackMessage(context, 'You are not connected to internet');
    }
  }

  loginApi() async {
    print('login');
    setState(() {
      loader=true;
    });
    Map body = {
      "username": usernameController.text,
      'password': passwordController.text
    };
    try {
      http.Response response = await http.post(Uri.parse(loginURL), body: body);

      Map jsonData = jsonDecode(response.body);
      print("jsondnadkka" + jsonData.toString());
      if (jsonData["status"] == 200) {
        setState(() {
          loader = false;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var id = jsonData['user']['id'];
        var token = jsonData['token'];
        print('id:$id\ntoken:$token');
        prefs.setString('id', id.toString());
        prefs.setString("token", token.toString());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Successfully'),duration: Duration(milliseconds: 1500),));
        if(jsonData['user']['status']=='Approved'){
          navRemove(context, const HomeScreen());
        }else{
          navRemove(context,  UnderVerification());
        }

      } else {
        setState(() {
          loader = false;
        });
        print("error message    ${jsonData['message']}");
        showSnackMessage(context, 'Invalid username/password');
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
      showSnackMessage(
          context, 'Something went wrong!\nTry again later');
    }

  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.95),
        //appBar: AppBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              textWidget(lblLoginTitle, TextAlign.center, 2, TextOverflow.clip,
                  20, textHeadingColor, FontWeight.w500, font_family),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.022,
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: textWidget(
                    lblLoginSubtitle,
                    TextAlign.center,
                    3,
                    TextOverflow.clip,
                    14,
                    textLightColor,
                    FontWeight.w300,
                    font_family),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              textField(context,usernameController, 'Username', TextInputType.name),
              usernameError
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '  username is required',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 12, color: kRed, fontFamily: font_family),
                      ))
                  : const SizedBox(),
               SizedBox(
                height: MediaQuery.of(context).size.height*0.025,
              ),
              PasswordTextField(
                controller: passwordController,
                hint: 'Password',
              ),
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
              // SizedBox(
              //   height: MediaQuery.of(context).size.height*0.025,
              // ),
              // Container(
              //   alignment: Alignment.centerRight,
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgotPassword()));
              //       //navPush(context, const ForgotPassword());
              //     },
              //
              //     child: Text(
              //       'Forgot Password',
              //       style: TextStyle(
              //           color: primaryColor,
              //           decoration: TextDecoration.underline,
              //           fontSize: 14,
              //           fontWeight: FontWeight.bold,
              //           fontStyle: FontStyle.italic,
              //           fontFamily: font_family),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.025,
              ),
              InkWell(
                  onTap: () {
                    if (!loader) {
                      formValidate();
                      // navPush(context, const HomeScreen());
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
                            'Login',
                            TextAlign.center,
                            1,
                            TextOverflow.clip,
                            18,
                            kWhite,
                            FontWeight.bold,
                            font_family),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.055,
              ),
              Text.rich(TextSpan(children: [
                 TextSpan(
                    text: 'Don\'t have an account?',
                    style: TextStyle(fontFamily: font_family)),
                const TextSpan(text: '   '),
                TextSpan(
                    text: 'Sign Up',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        fontFamily: font_family,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        navPush(context, const SignUpScreen());
                      }),
              ])),
            ],
          ),
        ),
      ),
    );
  }
}
