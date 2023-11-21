import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:onestore/screens/verification_screen.dart';

class ResetPassScreen extends StatelessWidget {
  const ResetPassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _phone = TextEditingController();
    final passWordResetFormKey = GlobalKey<FormState>();
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
          child: Form(
              key: passWordResetFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    // obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _phone,
                    cursorColor: Colors.purple,
                    style: const TextStyle(fontFamily: "noto san lao"),
                    keyboardType: TextInputType.phone,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "ກະລຸນາໃສ່ເບີໂທໃຫ້ຖືກຕ້ອງ";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'ເບີໂທ',
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors.purple,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors.purple,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 0.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      if (passWordResetFormKey.currentState!.validate()) {
                        //Phone verification
                        String phone = _phone.text;
                        String trimPhone = phone.replaceAll(" ", "");
                        String validPhone =
                            "20" + trimPhone.substring(trimPhone.length - 8);
                        log("Vlaid phone: " + validPhone);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => VerificationScreen(
                              phoneNumberOrMail: validPhone,
                              method: 10,
                            ),
                          ),
                        );
                      }
                    },
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(80.0)),
                    // padding: const EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.red, Colors.purple],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        constraints: const BoxConstraints(
                            maxWidth: 250.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: const Text(
                          "ດຳເນີນການຕໍ່",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: "noto san lao",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ))),
    ));
  }
}
