import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_bank/Authorization/change_password.dart';
import 'package:service_bank/Screens/deposit.dart';
import 'package:service_bank/Screens/withdraw.dart';
import 'package:service_bank/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/start_page.dart';
import '../components/logout.dart';
import 'colors.dart';
import 'navigator.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool logOutLoader = false;
  String? username;

  //////////////// Displaying user name on drawer
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('user');
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.025, vertical: 6),
      width: MediaQuery.of(context).size.width / 1.25,
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.close),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              Icon(
                CupertinoIcons.person_circle,
                size: MediaQuery.of(context).size.width * 0.4,
                color: kBlack,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    navPush(context, const Withdraw());
                  },
                  child: drawerWidget('assets/withdraw.png', 'Withdraw'),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    navPush(context, const DepositScreen());
                  },
                  child: drawerWidget('assets/deposit.png', 'Deposit'),
                ),
              ),
              const SizedBox(height: 25),
              // const SizedBox(height: 25),
              /* Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    navPush(context, const BetProWalletScreen());
                  },
                  child: drawerWidget('assets/deposit.png', 'BetPro-wallet'),
                ),
              ),
              const SizedBox(height: 25),*/
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    navPush(context, LinkScreen(link: linkUrl));
                  },
                  child: drawerWidget('assets/navigator.png', 'Betpro'),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    navPush(context, const ChangePassword());
                  },
                  child:
                      drawerWidget('assets/changePass.png', 'Change Password'),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: InkWell(
                  onTap: () {
                    logOut(context);
                  },
                  child: drawerWidget('assets/logout.png', 'Log Out'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget drawerWidget(String icon, String text) {
  return Row(
    children: [
      Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.5),
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(6),
        child: Image.asset(
          icon,
          width: 5,
          height: 5,
          color: kWhite,
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Container(
          height: 40,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: primaryColor,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.7),
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: kWhite),
          ),
        ),
      )
    ],
  );
}
