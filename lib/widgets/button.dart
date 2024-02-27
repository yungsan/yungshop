import 'package:flutter/material.dart';
import 'package:nguyen_manh_dung/widgets/text.dart';

double a = 690;

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.text,
    this.background = Colors.transparent,
    this.color = Colors.white,
    this.borderColor = const Color(0xff1f2029),
    this.borderRadius = 10,
    this.type = 'btn',
    this.onPressed,
  });

  final MyText text;
  final Color background;
  final Color color;
  final Color borderColor;
  final double borderRadius;
  final String type;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        minimumSize: const Size.fromHeight(40),
      ),
      child: text,
    );
  }
}
