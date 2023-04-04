import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:service_bank/Utils/colors.dart';
import 'package:service_bank/Utils/messages.dart';
import 'package:service_bank/Utils/text.dart';
import 'package:service_bank/components/app_bar.dart';
import 'package:service_bank/components/textStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/constants.dart';
import '../Utils/navigator.dart';
import '../Utils/urls.dart';
import 'home_screen.dart';

class UnderVerification extends StatefulWidget {
  const UnderVerification({Key? key}) : super(key: key);

  @override
  State<UnderVerification> createState() => _UnderVerificationState();
}

class _UnderVerificationState extends State<UnderVerification> {

  Future<void> _refresh() async {
    checkStatus(false);
    return Future.delayed(const Duration(seconds: 5));
  }

  var status;
  bool loader = true;

  checkStatus(bool check) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    var token = prefs.getString('token');
    print('$id\n$token');
    Map body = {'id': id.toString()};
    try {
      http.Response response = await http.post(Uri.parse(findUserURL),
          headers: {"Authorization": "Bearer $token"}, body: body);

      print(response.body);
      Map jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 200) {
        if (jsonData['user']['status'] == 'Approved') {
          showSnackMessage(context, "Congratulation:\nyou are approved by admin");
          navRemove(context, const HomeScreen());
        } else {
          setState(() {
            status = jsonData['user']['status'];
          });
          prefs.setString('status', status.toString());
        }
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loader=false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: appBar(
        context,
        'User Profile',
      ),
      body: loader
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              semanticsLabel: "Pull to refresh",
              displacement: 10,
              semanticsValue: 'pull ',
              child: ListView(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: 25),
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                  ),
                  Image.asset(
                    'assets/patience.png',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(
                          'Status:',
                          TextAlign.center,
                          2,
                          TextOverflow.clip,
                          16,
                          textLightColor,
                          FontWeight.w500,
                          font_family),
                      const SizedBox(
                        width: 60,
                      ),
                      textWidget(
                          status.toString(),
                          TextAlign.center,
                          2,
                          TextOverflow.clip,
                          16,
                          Colors.red,
                          FontWeight.w500,
                          font_family)
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: textWidget(
                          lblUnderVerificationTitle,
                          TextAlign.center,
                          3,
                          TextOverflow.clip,
                          16,
                          textLightColor,
                          FontWeight.w500,
                          font_family)),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: textWidget(
                          lblUnderVerificationSubtitle,
                          TextAlign.center,
                          3,
                          TextOverflow.clip,
                          16,
                          textLightColor,
                          FontWeight.w500,
                          font_family)),
                ],
              ),
            ),
    );
  }
}
