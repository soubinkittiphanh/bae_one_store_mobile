import 'package:flutter/material.dart';

class TextFieldComp extends StatelessWidget {
  const TextFieldComp({
    Key? key,
    required this.lable,
    required this.hintlable,
    required this.icon,
  }) : super(key: key);
  final String lable;
  final String hintlable;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.bodyText2,
      decoration: InputDecoration(
        labelText: lable,
        hintText: hintlable,
        icon: CircleAvatar(
          child: icon,
        ),
      ),
    );
  }
}
