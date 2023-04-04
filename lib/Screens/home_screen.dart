import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:service_bank/Screens/account_history.dart';
import 'package:service_bank/Screens/under_verification.dart';
import 'package:service_bank/Utils/CheckConnection.dart';
import 'package:service_bank/Utils/drawer.dart';
import 'package:service_bank/Utils/navigator.dart';
import 'package:service_bank/Utils/offline_ui.dart';
import 'package:service_bank/Utils/text.dart';
import 'package:service_bank/Utils/urls.dart';
import 'package:service_bank/components/textStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/colors.dart';
import '../Utils/constants.dart';
import '../Utils/messages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> key = GlobalKey();

  bool loader = true;
  bool checkConnection = false;

  var name;

  var email;

  var phone;

  var balance;

  getUserProfile(bool check) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    var token = prefs.getString('token');
    print(token);
    Map body = {
      'id': id.toString(),
    };
    try {
      http.Response response = await http.post(Uri.parse(findUserURL),
          headers: {"Authorization": "Bearer $token"}, body: body);
      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['status'] == 200) {
       if (jsonData['user']['status'] == "Approved") {
          setState(() {
            name = jsonData['user']['name'];
            email = jsonData['user']['email'];
            phone = jsonData['user']['phone'];
            balance = jsonData['user']['balance'];
            loader = false;
          });
          prefs.setString('balance', jsonData['user']['balance']);
          prefs.setString('status', jsonData['user']['status']);
        }
        else {
          setState(() {
            loader=false;
          });
          showSnackMessage(
              context, "Oh no!\nYour status has been changed by admin to ${jsonData['user']['status']}");
          navRemove(context, const UnderVerification());
        }
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, 'status code changed in api server');
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
      showSnackMessage(context, 'Something went wrong');
    }
  }

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      getUserProfile(true);
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  Future<void> _refresh() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      getUserProfile(true);
      return Future.delayed(const Duration(seconds: 4));
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserProfile(false);
  }

  @override
  Widget build(BuildContext context) {
    return checkConnection
        ? OfflineUI(function: checkConnectivity)
        : Scaffold(
            key: key,
            endDrawer: const DrawerScreen(),
            appBar: AppBar(
              title: const Text('BetPro'),
              centerTitle: true,
              titleTextStyle: TextStyle(fontFamily: font_family, fontSize: 20),
              backgroundColor: primaryColor,
              leading: Container(),
              elevation: 0,
              actions: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      key.currentState!.openEndDrawer();
                    },
                    child: const Icon(Icons.menu),
                  ),
                )
              ],
            ),
            body: loader
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
              onRefresh:_refresh,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                        vertical: 25),
                    children: [
                      const SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.12,
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: textFieldBackgroundColor,
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: textWidget(
                                      lblHomeName,
                                      TextAlign.center,
                                      2,
                                      TextOverflow.clip,
                                      16,
                                      textLightColor,
                                      FontWeight.w500,
                                      font_family),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: textWidget(
                                        name.toString(),
                                        TextAlign.center,
                                        2,
                                        TextOverflow.clip,
                                        15,
                                        textLightColor,
                                        FontWeight.w600,
                                        font_family),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 1.4,
                              width: double.infinity,
                              color: textFieldBackgroundColor,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: textWidget(
                                      lblHomePhone,
                                      TextAlign.center,
                                      2,
                                      TextOverflow.clip,
                                      16,
                                      textLightColor,
                                      FontWeight.w500,
                                      font_family),
                                ),
                                const SizedBox(
                                  width: 25,
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: textWidget(
                                        phone.toString(),
                                        TextAlign.center,
                                        2,
                                        TextOverflow.clip,
                                        15,
                                        textLightColor,
                                        FontWeight.w600,
                                        font_family),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 1.4,
                              width: double.infinity,
                              color: textFieldBackgroundColor,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: textWidget(
                                      lblHomeEmail,
                                      TextAlign.center,
                                      2,
                                      TextOverflow.clip,
                                      16,
                                      textLightColor,
                                      FontWeight.w500,
                                      font_family),
                                ),
                                const SizedBox(
                                  width: 35,
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: textWidget(
                                        email.toString(),
                                        TextAlign.center,
                                        3,
                                        TextOverflow.ellipsis,
                                        15,
                                        textLightColor,
                                        FontWeight.w600,
                                        font_family),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 1.4,
                              width: double.infinity,
                              color: textFieldBackgroundColor,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: textWidget(
                                      lblHomeBalance,
                                      TextAlign.center,
                                      2,
                                      TextOverflow.clip,
                                      16,
                                      textLightColor,
                                      FontWeight.w500,
                                      font_family),
                                ),
                                const SizedBox(
                                  width: 35,
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: textWidget(
                                        "Rs:$balance",
                                        TextAlign.center,
                                        2,
                                        TextOverflow.ellipsis,
                                        15,
                                        textLightColor,
                                        FontWeight.w600,
                                        font_family),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  navPush(context, const AccountHistory());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: primaryColor),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  child: textWidget(
                                      'View History',
                                      TextAlign.center,
                                      2,
                                      TextOverflow.clip,
                                      16,
                                      kWhite,
                                      FontWeight.w600,
                                      font_family),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
          );
  }
}
