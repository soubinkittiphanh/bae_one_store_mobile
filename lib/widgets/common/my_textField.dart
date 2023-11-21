import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.textEditingController,
    required this.onChangeFuction,
    this.hintText = '',
  }) : super(key: key);
  final TextEditingController textEditingController;
  final String hintText;
  final Function onChangeFuction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.4),
      ),
      child: TextField(
        // keyboardType: TextInputType.text,
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        enableSuggestions: false,
        autocorrect: false,
        controller: textEditingController,
        cursorColor: Colors.white,
        style: const TextStyle(
          fontFamily: "noto san lao",
          color: Colors.white,
        ),

        onChanged: (val) {
          onChangeFuction(val);
        },
        // onTapOutside: pressOutsideEvent(),
        decoration: InputDecoration(
          hintStyle:
              const TextStyle(fontFamily: "noto san lao", color: Colors.white),
          hintText: hintText,
          // fillColor: Colors.white,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
        ),
      ),
    );
  }
}
