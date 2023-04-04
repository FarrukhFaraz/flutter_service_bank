import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:service_bank/Models/TransactionHistoryModel.dart';
import 'package:service_bank/Utils/CheckConnection.dart';
import 'package:service_bank/Utils/colors.dart';
import 'package:service_bank/Utils/offline_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/urls.dart';

class AccountHistory extends StatefulWidget {
  const AccountHistory({Key? key}) : super(key: key);

  @override
  State<AccountHistory> createState() => _AccountHistoryState();
}

class _AccountHistoryState extends State<AccountHistory> {

  GlobalKey<ScaffoldState> key = GlobalKey();
  bool loader = true;
  bool checkConnection = false;
  List<TransactionHistoryModel> list = <TransactionHistoryModel>[];

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    var token = prefs.getString('token');

    Map body = {
      'user_id': id.toString(),
    };
    try {
      http.Response response = await http.post(Uri.parse(transactionHistoryURL),
          headers: {"Authorization": "Bearer $token"}, body: body);
      Map jsonData = jsonDecode(response.body);
      print(jsonData);

      if (jsonData['status'] == 200) {
        print(list.length);
        list.clear();
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> obj = jsonData['data'][i];
          TransactionHistoryModel pos = TransactionHistoryModel();
          pos = TransactionHistoryModel.fromJson(obj);
          list.add(pos);
        }

        setState(() {
          loader = false;
        });
      } else {
        setState(() {
          loader = false;
        });
        // showSnackMessage(context, 'Something went wrong');
      }
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
      // showSnackMessage(context, 'Something went wrong');
    }
  }

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection=false;
      });
      getData();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();
  }

  Future<void> _refresh() async {
    if (await connection()) {
      setState(() {
        checkConnection=false;
      });
      getData();
      return Future.delayed(const Duration(seconds: 4));
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return checkConnection?OfflineUI(function: checkConnectivity): SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transaction History'),
          backgroundColor: primaryColor,
          elevation: 0,
          leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: loader
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : list.isEmpty
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      height: 200,
                      alignment: Alignment.center,
                      child: const Text(
                          'You don\'t perform any transaction\n OR \nYour no transaction is approved by admin'),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: kWhite,
                            border:
                                Border.all(width: 1, color: textHeadingColor),
                          ),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 95,
                                child:
                                    list[index].status.toString() == 'Pending'
                                        ? Image.asset(
                                            'assets/pending.jpg',
                                            fit: BoxFit.fill,
                                            // color: kBlack,
                                            // height: 700,
                                          )
                                        : list[index].status.toString() ==
                                                'Approved'
                                            ? Image.asset(
                                                'assets/successful.jpg',
                                                fit: BoxFit.fill,
                                                // height: 700,
                                              )
                                            : list[index].status.toString() ==
                                                    'Blocked'
                                                ? Image.asset(
                                                    'assets/cancelled.png',
                                                    fit: BoxFit.fill,
                                                    // height: 700,
                                                  )
                                                : const SizedBox(),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 23,
                                        width: 23,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.5, color: kBlack),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Icon(
                                          list[index].type == 'deposit' ||
                                                  list[index].type ==
                                                      'wallet_withdraw'
                                              ? Icons.arrow_upward
                                              : Icons.arrow_downward_outlined,
                                          size: 15,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${list[index].type}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Bank: ${list[index].bank}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                              "Ac#: ${list[index].acNumber.toString()}",
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                          Text(
                                              "Ac Title: ${list[index].acTitle.toString()}",
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                        ],
                                      )),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Rs. ${(double.parse(list[index].amount.toString())).toInt()}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Balance:${list[index].balance}',
                                            style:
                                                const TextStyle(fontSize: 11),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: textLightColor,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${list[index].status}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                list[index].status == 'Pending'
                                                    ? const Color(0xfff5d6a2)
                                                    : list[index].status ==
                                                            'Approved'
                                                        ? Colors.green
                                                        : Colors.red),
                                      ),
                                      Text(DateFormat('dd MMM yyyy HH:mm')
                                          .format(DateTime.parse(list[index]
                                              .createdAt
                                              .toString()))),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
