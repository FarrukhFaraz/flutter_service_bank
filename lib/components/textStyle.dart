import 'package:flutter/cupertino.dart';
import 'package:service_bank/Utils/text.dart';

Widget textWidget(
    String text,
    TextAlign align,
    int maxLines,
    TextOverflow overflow,
    double fontSize,
    Color color,
    FontWeight weight,
    String family) {
  return Text(
    text,
    textAlign: align,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      fontSize: fontSize,
      height: 1.4,
      color: color,
      fontWeight: weight,
      fontFamily: family==''?font_family:family,
    ),
  );
}
