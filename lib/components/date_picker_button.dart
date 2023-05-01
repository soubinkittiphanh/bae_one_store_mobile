import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onestore/widgets/common/my_button.dart';

import '../config/const_design.dart';

class DatePickerButton extends StatelessWidget {
  const DatePickerButton({Key? key, required this.text, required this.showDate})
      : super(key: key);
  final String text;
  final Function showDate;
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              showDate();
            },
          )
        : MyButton(
            text: text,
            press: showDate,
            btnColor: kTextPrimaryColor,
          );
    // TextButton(
    //     child: Text(
    //       text,
    //       style: const TextStyle(
    //         // fontWeight: FontWeight.bold,
    //         fontFamily: 'noto san lao',
    //         color: kTextPrimaryColor,
    //       ),
    //     ),
    //     onPressed: () {
    //       showDate();
    //     });
  }
}
