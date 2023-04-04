import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_bank/Screens/funds_transfer.dart';
import 'package:service_bank/Utils/colors.dart';
import 'package:service_bank/Utils/navigator.dart';
import 'package:service_bank/components/textStyle.dart';

import '../Utils/text.dart';

class DepositAmountScreen extends StatefulWidget {
  const DepositAmountScreen({
    Key? key,
    required this.bank,
    required this.ac_number,
    required this.ac_title,
    required this.limit,
    required this.type,
  }) : super(key: key);

  final String bank;

  final String ac_number;

  final String ac_title;

  final int limit;
  final String type;

  @override
  State<DepositAmountScreen> createState() => _DepositAmountScreenState();
}

class _DepositAmountScreenState extends State<DepositAmountScreen> {
  TextEditingController controller = TextEditingController();
  int amount = 0;
  bool limitError = false;

  formValidate() {
    navPush(
        context,
        TransferFunds(
          bank: widget.bank,
          ac_title: widget.ac_title,
          ac_number: widget.ac_number,
          type: widget.type,
          amount: amount.toString(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 22,
                  )),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.28),
            Container(
              alignment: Alignment.centerLeft,
              child: textWidget(
                  'Enter amount you want to deposit in My Wallet',
                  TextAlign.start,
                  3,
                  TextOverflow.clip,
                  20,
                  textHeadingColor,
                  FontWeight.w600,
                  font_family),
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              child: textWidget(
                  'Minimum amount is Rs. 500',
                  TextAlign.center,
                  2,
                  TextOverflow.clip,
                  14,
                  textLightColor,
                  FontWeight.w500,
                  font_family),
            ),
            const SizedBox(height: 10),
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
                    amount = int.parse(val.toString());
                    if ((amount > (widget.limit))) {
                      limitError = true;
                    } else {
                      limitError = false;
                    }
                  }
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: primaryColor, width: 1)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor, width: 1),
                ),
                isDense: true,
                hintText: 'Enter Amount',
              ),
              textAlign: TextAlign.center,
              cursorColor: primaryColor,
            ),
            const SizedBox(
              height: 3,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  limitError
                      ? Text(
                          'Limit exceeds',
                          style: TextStyle(color: kRed),
                        )
                      : const SizedBox(),
                  Text('limit:${widget.limit}'),
                ],
              ),
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () {
                if (amount >= 500 && limitError ==false) {
                  formValidate();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (amount == 0 || amount < 500 || limitError == true)
                      ? primaryColor.withOpacity(0.4)
                      : primaryColor,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                child: textWidget(
                    'Next',
                    TextAlign.center,
                    2,
                    TextOverflow.clip,
                    16,
                    (amount == 0 || amount < 500)
                        ? kWhite.withOpacity(0.4)
                        : kWhite,
                    FontWeight.w600,
                    font_family),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
