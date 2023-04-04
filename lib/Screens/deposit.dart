import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:service_bank/Models/BankNameModel.dart';
import 'package:service_bank/Screens/deposit_amount.dart';
import 'package:service_bank/Utils/colors.dart';
import 'package:service_bank/Utils/navigator.dart';
import 'package:service_bank/Utils/text.dart';
import 'package:service_bank/Utils/urls.dart';
import 'package:service_bank/components/textStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/messages.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  bool check = false;
  bool meezanCheck = false;
  bool easyCheck = false;
  bool jazzCheck = false;
  bool loader = false;

  int limit = 0;

  var bank;
  var ac_title;
  var ac_number;

  String type = '0';

  List<BankName> list = <BankName>[];

  nextScreen() {
    navPush(
        context,
        DepositAmountScreen(
            ac_number: ac_number.toString(),
            ac_title: ac_title.toString(),
            bank: bank.toString(),
            type: type,
            limit: limit));
  }

  getBankName() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token');
    try {
      http.Response response = await http.get(
        Uri.parse(getBanksNameURL),
        headers: {"Authorization": "Bearer $token"},
      );
      print(response.body);
      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['status'] == 200) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          BankName pos = BankName();
          pos = BankName.fromJson(obj);
          list.add(pos);
        }
        print(list.length);
        setState(() {
          loader = false;
        });
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, 'No bank data found');
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
      showSnackMessage(context, 'Something went wrong');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBankName();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          if (check) {
            nextScreen();
          }
        },
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: check ? primaryColor : primaryColor.withOpacity(0.4),
          ),
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: 2),
          child: textWidget(
              'TRANSFER',
              TextAlign.center,
              2,
              TextOverflow.clip,
              16,
              check ? kWhite : kWhite.withOpacity(0.4),
              FontWeight.w600,
              font_family),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios, size: 22),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              alignment: Alignment.centerLeft,
              child: textWidget(
                  'Select an account',
                  TextAlign.center,
                  2,
                  TextOverflow.clip,
                  18,
                  textHeadingColor,
                  FontWeight.w600,
                  font_family),
            ),
            const SizedBox(height: 8),
            Container(
              alignment: Alignment.centerLeft,
              child: textWidget(
                  'Transfer funds on selected account and click Transfer Button',
                  TextAlign.start,
                  2,
                  TextOverflow.clip,
                  14,
                  textLightColor,
                  FontWeight.w500,
                  font_family),
            ),
            const SizedBox(height: 15),
            loader
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : list.isEmpty
                    ? Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: const Text('No Bank details are added yet!'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1.5, color: kBlack)),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: textWidget(
                                      list[index].name.toString(),
                                      TextAlign.start,
                                      2,
                                      TextOverflow.clip,
                                      16,
                                      textHeadingColor,
                                      FontWeight.w600,
                                      font_family),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: FadeInImage(
                                          placeholder: const AssetImage('assets/placeholder.png'),
                                          image: NetworkImage(list[index].image.toString()),
                                          width: 55,
                                          height: 55,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: textWidget(
                                                'Ac #: ${list[index].acNumber.toString()}',
                                                TextAlign.center,
                                                2,
                                                TextOverflow.clip,
                                                13,
                                                textHeadingColor,
                                                FontWeight.w500,
                                                font_family),
                                          ),
                                          // const SizedBox(height: 8,),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: textWidget(
                                                'Ac Title: ${list[index].acTitle.toString()}',
                                                // 'Ac Title: ',
                                                TextAlign.center,
                                                2,
                                                TextOverflow.clip,
                                                13,
                                                textHeadingColor,
                                                FontWeight.w500,
                                                font_family),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Container(
                                      alignment: Alignment.topCenter,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            for (int i = 0;
                                                i < list.length;
                                                i++) {
                                              list[i].value = false;
                                            }
                                            check = true;
                                            list[index].value = true;
                                            bank = list[index].name.toString();
                                            ac_number =
                                                list[index].acNumber.toString();
                                            ac_title =
                                                list[index].acTitle.toString();
                                            type = list[index].status.toString();

                                            limit = int.parse(
                                                list[index].limits.toString());
                                          });
                                          print(bank);
                                        },
                                        child: Icon(list[index].value
                                            ? Icons.check_box
                                            : Icons
                                                .check_box_outline_blank_sharp),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      )
          ],
        ),
      ),
    ));
  }
}
