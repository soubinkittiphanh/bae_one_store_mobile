import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onestore/screens/login_screen.dart';
import 'package:onestore/service/user_info_service.dart';

class ResetPasswordFormScreen extends StatefulWidget {
  const ResetPasswordFormScreen({Key? key, required this.phoneNumber})
      : super(key: key);
  final String phoneNumber;
  @override
  _ResetPasswordFormScreenState createState() =>
      _ResetPasswordFormScreenState();
}

class _ResetPasswordFormScreenState extends State<ResetPasswordFormScreen> {
  final _textControllerPassword = TextEditingController();
  final _textControllerPasswordConfirm = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int statusCode = 00;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoaderOverlay(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _textControllerPassword,
                      cursorColor: Colors.purple,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: const TextStyle(fontFamily: "noto san lao"),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "ກະລຸນາໃສ່ ລະຫັດຜ່ານ";
                        } else if (val.length < 6) {
                          return "ລະຫັດຜ່ານ ຕ້ອງ 6 ຕົວຂື້ນໄປ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'ລະຫັດຜ່ານໃຫມ່',
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
                    TextFormField(
                      controller: _textControllerPasswordConfirm,
                      cursorColor: Colors.purple,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: const TextStyle(fontFamily: "noto san lao"),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "ກະລຸນາ ຢືນຢັນລະຫັດຜ່ານ";
                        } else if (_textControllerPassword.text !=
                            _textControllerPasswordConfirm.text) {
                          return "ລະຫັດບໍ່ຕົງກັນ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'ຢືນຢັນ ລະຫັດຜ່ານ',
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
                        if (_formKey.currentState!.validate()) {
                          context.loaderOverlay.show();
                          log("Reset processing...");
                          final response =
                              await UserInfService.resetPasswordByPhoneNumber(
                            widget.phoneNumber,
                            _textControllerPassword.text,
                          );
                          setState(() {
                            statusCode = response;
                          });
                          if (response == 200) {
                            log("Reset succeed");
                          } else if (response == 404) {
                            log("Server error");
                          } else {
                            log("Reset not succeed");
                          }
                          context.loaderOverlay.hide();
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
                            "Reset password",
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
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      statusCode == 200
                          ? "ລັດຫັດຜ່ານ ຣີເສັດ ສຳເລັດ"
                          : statusCode == 404
                              ? "ກະລຸນາກວດສອບ ການເຊື່ອມຕໍ່"
                              : statusCode == 00
                                  ? ""
                                  : "ບໍ່ສາມາດປ່ຽນແປງລະຫັດຜ່ານໄດ້ ເກີດຂໍ້ຜິດພາດ SQL",
                    ),
                    if (statusCode == 200)
                      TextButton(
                        onPressed: () => {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (ctx) => const LoginScreen(),
                            ),
                          ),
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: 'noto san lao',
                          ),
                        ),
                      ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
