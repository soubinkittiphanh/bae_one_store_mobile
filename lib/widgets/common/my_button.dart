import 'package:flutter/material.dart';
import 'package:onestore/config/const_design.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {Key? key,
      required this.text,
      required this.press,
      this.verticalPadding = 10,
      this.horizontalPadding = 40,
      this.fontSize = 16,
      this.btnColor = kTextPrimaryColor})
      : super(key: key);
  final String text;
  final double verticalPadding;
  final double horizontalPadding;
  final double fontSize;
  final Function press;
  final Color btnColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        press();
      },
      child: Container(
        // width: double.infinity,
        // alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 15),
              blurRadius: 30,
              color: const Color(0xFF666666).withOpacity(.11),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: fontSize,
              // fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }
}
