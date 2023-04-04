import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:service_bank/Screens/home_screen.dart';
import 'package:service_bank/Utils/CheckConnection.dart';
import 'package:service_bank/Utils/colors.dart';
import 'package:service_bank/Utils/messages.dart';
import 'package:service_bank/Utils/navigator.dart';
import 'package:service_bank/Utils/offline_ui.dart';
import 'package:service_bank/Utils/text.dart';
import 'package:service_bank/Utils/urls.dart';
import 'package:service_bank/components/textStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({Key? key}) : super(key: key);

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  TextEditingController amountController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  bool loader = false;
  bool bank = false;
  bool check = false;
  String value = '';
  bool error = false;
  int type = 0;
  bool checkConnection = false;

  formValidate() {
    if (amountController.text.isEmpty) {
      showSnackMessage(context, 'Please Enter amount to withdraw');
    } else if (int.parse(amountController.text) > balance) {
      showSnackMessage(
          context, 'Entered amount is greater than available balance');
    } else if (accountController.text.isEmpty) {
      showSnackMessage(context, 'Account Number is required');
    } else if (titleController.text.isEmpty) {
      showSnackMessage(
          context, 'Account title is required for payment verification');
    } else {
      checkConnectivity();
    }
  }

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      confirmDialog();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  confirmDialog() {
    return showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, StateSetter setState) {
          return AlertDialog(
            title: const Text("Confirmation"),
            titleTextStyle: TextStyle(
                fontSize: 22,
                fontFamily: font_family,
                color: textHeadingColor,
                fontWeight: FontWeight.w500),
            content: const Text("Are you sure to perform this transaction"),
            contentTextStyle: TextStyle(
                fontFamily: font_family, fontSize: 16, color: textLightColor),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontFamily: font_family,
                      fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  callApi();
                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontFamily: font_family,
                      fontSize: 16),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  callApi() async {
    setState(() {
      loader = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    Map body = {
      'payment': amountController.text,
      'payment_method': value,
      'type': '2',
      'account': accountController.text,
      'title': titleController.text,
      'remark': remarkController.text.isEmpty ? '' : remarkController.text,
    };

    try {
      http.Response response = await http.post(Uri.parse(withdrawRequestURL),
          headers: {"Authorization": "Bearer $token"}, body: body);
      print(response.body);
      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['status'] == 200) {
        setState(() {
          loader = false;
          amountController.clear();
          accountController.clear();
          titleController.clear();
          remarkController.clear();
          value = '';
          check = false;
        });
        dialog();
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, 'Something went wrong');
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
      showSnackMessage(context, 'Something went wrong');
    }
  }

  dialog() {
    return showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, StateSetter setState) {
          return AlertDialog(
            title: const Text("Success"),
            titleTextStyle: TextStyle(
                fontSize: 22,
                fontFamily: font_family,
                color: textHeadingColor,
                fontWeight: FontWeight.w500),
            content: const Text(
                "Your request is successfully submitted.\nOnce request is approved, desired amount will be deducted from your wallet and send to beneficiary account"),
            contentTextStyle: TextStyle(
                fontFamily: font_family, fontSize: 16, color: textLightColor),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  navRemove(context, const HomeScreen());
                },
                child: Text(
                  "Ok",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontFamily: font_family,
                      fontSize: 16),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  int balance = 0;
  int showBalance = 0;

  getBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return checkConnection
        ? OfflineUI(function: checkConnectivity)
        : Scaffold(
            appBar: AppBar(
              leading: Container(),
              leadingWidth: 0,
              elevation: 0,
              backgroundColor: primaryColor,
              centerTitle: true,
              title: SizedBox(
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 22,
                          color: kWhite,
                        )),
                    Expanded(
                        child: Container(
                      alignment: Alignment.center,
                      child: textWidget(
                          'Withdraw Balance',
                          TextAlign.center,
                          1,
                          TextOverflow.clip,
                          18,
                          kWhite,
                          FontWeight.w600,
                          font_family),
                    ))
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: textWidget(
                        'Amount to withdraw',
                        TextAlign.center,
                        1,
                        TextOverflow.clip,
                        16,
                        textHeadingColor,
                        FontWeight.w600,
                        font_family),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'\d'))
                    ],
                    onChanged: (val) {
                      int aa = int.parse(val.toString());
                      if (aa > showBalance) {
                        setState(() {
                          error = true;
                        });
                      } else {
                        setState(() {
                          error = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 1,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(width: 1, color: primaryColor)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(width: 1, color: primaryColor)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(width: 1, color: primaryColor)),
                        hintText: "Amount",
                        errorText: error ? 'limit exceeds' : null,
                        suffixIcon: Container(
                            width: 1,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(
                              'Max',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: textHeadingColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: font_family),
                            )),
                        isDense: true),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textWidget(
                            'Avail Balance',
                            TextAlign.start,
                            1,
                            TextOverflow.clip,
                            14,
                            textLightColor,
                            FontWeight.w500,
                            font_family),
                        textWidget(
                            'Rs. $showBalance',
                            TextAlign.start,
                            1,
                            TextOverflow.clip,
                            14,
                            textLightColor,
                            FontWeight.w500,
                            font_family),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: textWidget(
                        ' Account Details',
                        TextAlign.start,
                        1,
                        TextOverflow.clip,
                        16,
                        textHeadingColor,
                        FontWeight.w600,
                        font_family),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kBlack, width: 1.5)),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: textWidget(
                              'Choose Payment Method',
                              TextAlign.start,
                              1,
                              TextOverflow.clip,
                              16,
                              textHeadingColor,
                              FontWeight.w600,
                              font_family),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              check = true;
                              bank = true;
                              type = 1;
                              value = 'MEEZAN Bank';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: kBlack, width: 1)),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Icon(
                                  value == 'MEEZAN Bank'
                                      ? Icons.circle
                                      : Icons.circle_outlined,
                                  color: value == 'MEEZAN Bank'
                                      ? primaryColor
                                      : primaryColor.withOpacity(0.4),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  'assets/meezan.png',
                                  width: 40,
                                  height: 40,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                textWidget(
                                    'MEEZAN Bank',
                                    TextAlign.start,
                                    1,
                                    TextOverflow.clip,
                                    16,
                                    textHeadingColor,
                                    FontWeight.w600,
                                    font_family),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              bank = false;
                              check = true;
                              type = 3;
                              value = 'Jazz Cash';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: kBlack, width: 1)),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Icon(
                                  value == 'Jazz Cash'
                                      ? Icons.circle
                                      : Icons.circle_outlined,
                                  color: value == 'Jazz Cash'
                                      ? primaryColor
                                      : primaryColor.withOpacity(0.4),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  'assets/jazzcash.png',
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                textWidget(
                                    'Jazz Cash',
                                    TextAlign.start,
                                    1,
                                    TextOverflow.clip,
                                    16,
                                    textHeadingColor,
                                    FontWeight.w600,
                                    font_family),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              check = true;
                              bank = false;
                              type = 2;
                              value = 'Easy Paisa';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: kBlack, width: 1)),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Icon(
                                  value == 'Easy Paisa'
                                      ? Icons.circle
                                      : Icons.circle_outlined,
                                  color: value == 'Easy Paisa'
                                      ? primaryColor
                                      : primaryColor.withOpacity(0.4),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  'assets/easypaisa.png',
                                  width: 35,
                                  height: 35,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                textWidget(
                                    'Easy Paisa',
                                    TextAlign.start,
                                    1,
                                    TextOverflow.clip,
                                    16,
                                    textHeadingColor,
                                    FontWeight.w600,
                                    font_family),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: textWidget(
                              bank
                                  ? 'Enter IBN Number'
                                  : 'Enter Account Number',
                              TextAlign.start,
                              1,
                              TextOverflow.clip,
                              14,
                              textHeadingColor,
                              FontWeight.w600,
                              font_family),
                        ),
                        TextFormField(
                          controller: accountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    width: 1,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      width: 1, color: primaryColor)),
                              hintText: bank ? "IBN Number" : "Account Number",
                              isDense: true),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: textWidget(
                              'Enter Account Title',
                              TextAlign.start,
                              1,
                              TextOverflow.clip,
                              14,
                              textHeadingColor,
                              FontWeight.w600,
                              font_family),
                        ),
                        TextFormField(
                          controller: titleController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    width: 1,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      width: 1, color: primaryColor)),
                              hintText: "Account Title",
                              isDense: true),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: textWidget(
                              'Enter Remarks',
                              TextAlign.start,
                              1,
                              TextOverflow.clip,
                              14,
                              textHeadingColor,
                              FontWeight.w600,
                              font_family),
                        ),
                        TextFormField(
                          controller: remarkController,
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    width: 1,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      width: 1, color: primaryColor)),
                              hintText: "Remark",
                              isDense: true),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      if (check == true && loader == false && error == false) {
                        formValidate();
                      }else{
                        print('not validate');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: (check == true && error == false)
                            ? primaryColor
                            : primaryColor.withOpacity(0.4),
                      ),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      alignment: Alignment.center,
                      child: loader
                          ? const Center(child: CircularProgressIndicator())
                          : textWidget(
                              'WITHDRAW',
                              TextAlign.start,
                              1,
                              TextOverflow.clip,
                              14,
                              (check == true && error == false)
                                  ? kWhite
                                  : kWhite.withOpacity(0.4),
                              FontWeight.w500,
                              font_family),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                ],
              ),
            ),
          );
  }
}
