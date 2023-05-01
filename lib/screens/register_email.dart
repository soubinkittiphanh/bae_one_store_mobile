import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onestore/models/register_message.dart';
import 'package:onestore/screens/register_form_screen.dart';
import 'package:onestore/screens/verification_screen.dart';
import 'package:onestore/service/firbase_service.dart';

class RegistEmailScreen extends StatefulWidget {
  const RegistEmailScreen({Key? key}) : super(key: key);
  static const routerName = "register-email";

  @override
  State<RegistEmailScreen> createState() => _RegistEmailScreenState();
}

class _RegistEmailScreenState extends State<RegistEmailScreen> {
  String stage = '';
  String phoneNumber = '';
  int registerStatusCode = 0;
  final _textPhoneController = TextEditingController();
  final firebaseService = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [IconButton(onPressed: null, icon: Icon(Icons.arrow_back))],
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: LoaderOverlay(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60),
              topRight: Radius.circular(60),
            ),
            color: Colors.cyan,
          ),
          // color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      autocorrect: false,
                      controller: _textPhoneController,
                      cursorColor: Colors.purple,
                      style: const TextStyle(fontFamily: "noto san lao"),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "ກະລຸນາໃສ່ຊື່ ໃຫ້ຖືກຕ້ອງ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'ເບີໂທລະສັບ ຫລື ອີເມວ',
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
                        if (_textPhoneController.text.contains("@")) {
                          //Email verification
                          context.loaderOverlay.show();
                          RegisterMessage response = await firebaseService
                              .registerWithEmailAndPassword(
                            _textPhoneController.text,
                            "123456",
                            registerStatusCode,
                          );

                          // 200 Register succeed and email verified
                          // 503 Register succeed and email unverified
                          // 404 Error firebase : Email aready exist, Weak password,
                          log("KEY: " + response.statusCode.toString());
                          if (response.statusCode == 200) {
                            context.loaderOverlay.hide();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (ctx) => RegisterFormScreen(
                                  email: _textPhoneController.text,
                                ),
                              ),
                            );
                          } else {
                            context.loaderOverlay.hide();
                            setState(() {
                              stage = response.message;
                              registerStatusCode = response.statusCode;
                              log("Status code: " +
                                  registerStatusCode.toString());
                            });
                          }
                        } else {
                          context.loaderOverlay.hide();
                          //Phone verification
                          String phone = _textPhoneController.text;
                          String trimPhone = phone.replaceAll(" ", "");
                          String validPhone =
                              "20" + trimPhone.substring(trimPhone.length - 8);
                          log("Vlaid phone: " + validPhone);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => VerificationScreen(
                                phoneNumberOrMail: validPhone,
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
                    const SizedBox(height: 30),
                    Text(
                      stage,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
