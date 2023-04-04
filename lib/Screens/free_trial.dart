import 'package:flutter/material.dart';
import 'package:service_bank/Utils/colors.dart';
import 'package:service_bank/Utils/text.dart';
import 'package:service_bank/components/textStyle.dart';

import '../Utils/constants.dart';

class FreeTrail extends StatefulWidget {
  const FreeTrail({
    Key? key,
  }) : super(key: key);

  @override
  State<FreeTrail> createState() => _FreeTrailState();
}

class _FreeTrailState extends State<FreeTrail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: appBar(context , 'User Profile' , ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Image.asset(
                'assets/oh_no.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(
                height: 10,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     textWidget('Status:', TextAlign.center, 2, TextOverflow.clip,
              //         16, textLightColor, FontWeight.w500, font_family),
              //     const SizedBox(
              //       width: 60,
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              // Container(
              //     alignment: Alignment.center,
              //     child: textWidget(
              //         lblUnderVerificationTitle,
              //         TextAlign.center,
              //         3,
              //         TextOverflow.clip,
              //         16,
              //         textLightColor,
              //         FontWeight.w500,
              //         font_family)),
              // const SizedBox(
              //   height: 10,
              // ),
              // Container(
              //     alignment: Alignment.center,
              //     child: textWidget(
              //         lblUnderVerificationSubtitle,
              //         TextAlign.center,
              //         3,
              //         TextOverflow.clip,
              //         16,
              //         textLightColor,
              //         FontWeight.w500,
              //         font_family)),
              Container(
                  alignment: Alignment.center,
                  child: textWidget(
                      lblFreeTrial,
                      TextAlign.center,
                      3,
                      TextOverflow.clip,
                      16,
                      kRed,
                      FontWeight.w500,
                      font_family)),
            ],
          ),
        ),
      ),
    );
  }
}
