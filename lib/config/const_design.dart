import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF4DA768);
const Color kSecodaryColor = Color(0xFFD9D625);
const Color kLastColor = Color(0xFF4DA768);
const Color kTextPrimaryColor = Color(0xFFE6B91C);
const Color kTextSecondaryColor = Color(0xFFD9D625);
// const Color kPrimaryColor = Color(0xFFBFFFBF);
// const Color kSecodaryColor = Color(0xFFBFCCB8);
// const Color kLastColor = Color(0xFFFFFFFF);
// const Color kTextPrimaryColor = Color(0xFF996E5C);
// const Color kTextSecondaryColor = Color(0xFFCCBEB8);

class ConstDesign {
  static Widget myButton(
      BuildContext context, Function function, String btnText) {
    return OutlinedButton(
      onPressed: () {
        function();
      },
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.green, Colors.purple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
          alignment: Alignment.center,
          child: Text(
            btnText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: "noto san lao",
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildTextFormFiel(
    TextEditingController textEditingController,
    String errorMessage,
    String hintText,
    TextInputType textInputType,
    Function pressOutsideEvent,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.4),
      ),
      child: TextFormField(
        keyboardType: textInputType,
        enableSuggestions: false,
        autocorrect: false,
        controller: textEditingController,
        cursorColor: Colors.white,
        style: const TextStyle(
          fontFamily: "noto san lao",
          color: Colors.white,
        ),
        validator: (val) {
          if (val!.isEmpty) {
            return errorMessage;
          }
          return null;
        },
        onChanged: (val) => {pressOutsideEvent(val)},
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
