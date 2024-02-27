import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText({
    super.key,
    required this.text,
    this.fw = FontWeight.w500,
    this.fs = 14,
    this.color,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
    this.center = false,
  });

  final String text;
  final double fs;
  final FontWeight fw;
  final dynamic color;
  final double top;
  final double right;
  final double bottom;
  final double left;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: top, right: right, bottom: bottom, left: left),
      child: Builder(builder: (context) {
        if (center) {
          return Text(
            text,
            style: TextStyle(fontSize: fs, fontWeight: fw, color: color),
            textAlign: TextAlign.center,
          );
        } else {
          return Text(
            text,
            style: TextStyle(fontSize: fs, fontWeight: fw, color: color),
            softWrap: true,
          );
        }
      }),
    );
  }
}
