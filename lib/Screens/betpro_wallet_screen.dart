import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:service_bank/Utils/CheckConnection.dart';
import 'package:service_bank/Utils/colors.dart';
import 'package:service_bank/Utils/messages.dart';
import 'package:service_bank/Utils/offline_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/urls.dart';

class BetProWalletScreen extends StatefulWidget {
  const BetProWalletScreen({Key? key}) : super(key: key);

  @override
  State<BetProWalletScreen> createState() => _BetProWalletScreenState();
}

class _BetProWalletScreenState extends State<BetProWalletScreen> {
  TextEditingController controller = TextEditingController();

  String from = 'My BetPro Account';
  String to = 'This wallet';

  bool betpro = false; ////// if we deposit to betpro its value is true
  ////// for withdraw it is false

  int amount = 0;
  int balance = 0;
  int showBalance = 0;
  bool limitError = false;
  bool loader = false;
  bool checkConnection=false;

  getBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var id = prefs.getString('id');
      print(id);
      var bal = prefs.getString('balance');
      print(bal);
      if (bal != null) {
        double bb = double.parse(bal.toString());
        balance = bb.toInt();
        showBalance = balance;
      }
      print('$balance\n$showBalance');
    });
  }

  bool isNumeric(String str) {
    final numericRegex = RegExp(r'^-?[0-9]+$');
    return numericRegex.hasMatch(str);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBalance();
  }

  checkConnectivity() async {
    print('connection');
    if(await connection()){
      setState(() {
        checkConnection=false;
      });

      callApi();
    }else{
      setState(() {
        checkConnection=true;
      });
    }
  }

  callApi() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map body = {
      'payment': amount.toString(),
      'payment_method': 'betpro',
      'type': betpro ? '4' : '3',
      'account': 'betpro',
      'title': 'betpro',
    };
    print(token);
    print(body);

    try {
      http.Response response = await http.post(
        Uri.parse(withdrawRequestURL),
        headers: {"Authorization": "Bearer $token"},
        body: body,
      );
      print(response.body);

      Map jsonData = jsonDecode(response.body);

      if(jsonData['status'] == 200){
        showSnackMessage(context, 'Your transaction has been successfully submitted');
        setState(() {
          controller.clear();
          amount=0;
          limitError=false;
        });
      }else{
        showSnackMessage(context, 'Your transaction can\'t be processed\nPlease try again later');
      }
    } catch (e) {
      print(e);
      showSnackMessage(context, "Something went wrong!\nTry again later");
    }

    setState(() {
      loader=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      checkConnection?OfflineUI(function: checkConnectivity):
      SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'From    ',
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          betpro ? to : from,
                          style: TextStyle(color: kBlack),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.arrow_downward,
                            color: Colors.black54,
                          ),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  betpro = !betpro;
                                  controller.clear();
                                  amount = 0;
                                  limitError = false;
                                });
                              },
                              child: Image.asset(
                                'assets/sync.png',
                                width: 20,
                                color: const Color(0xffe39e07),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'To         ',
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          betpro ? from : to,
                          style: TextStyle(color: kBlack),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'\d'))
              ],
              onChanged: (val) {
                setState(() {
                  if (val.toString().isEmpty) {
                    amount = 0;
                  } else {
                    if (val.toString()[0] == '0') {
                      print("first is one");
                      controller.text = '';
                    }
                    amount = int.parse(val.toString());
                    if (betpro) {
                      if (amount > showBalance) {
                        print('limit exceed');
                        limitError = true;
                      } else {
                        limitError = false;
                      }
                    }
                  }
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
                hintText: "Amount",
              ),
              cursorColor: primaryColor,
            ),
            const SizedBox(
              height: 3,
            ),
            betpro
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          limitError ? 'limit exceed' : '',
                          style: TextStyle(fontSize: 12, color: kRed),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Available Balance Rs:$showBalance',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 25),
            InkWell(
              onTap: () {
                if (limitError == false && amount > 0 && loader == false) {
                  print('ok');
                  print(betpro);
                  print(amount);
                  checkConnectivity();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (amount == 0 || limitError == true)
                      ? primaryColor.withOpacity(0.4)
                      : primaryColor,
                ),
                child: loader
                    ? const Center(child: CircularProgressIndicator())
                    : Text(
                        'Send Request',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: (amount == 0 || limitError == true)
                              ? kWhite.withOpacity(0.4)
                              : kWhite,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
