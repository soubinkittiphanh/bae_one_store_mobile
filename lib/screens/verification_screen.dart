import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onestore/screens/register_form_screen.dart';
import 'package:onestore/screens/reset_password_form_screen.dart';
import 'package:onestore/service/firbase_service.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen(
      {Key? key, required this.phoneNumberOrMail, this.method = 00})
      : super(key: key);
  final String phoneNumberOrMail;
  final int method;
  //metho 00 = register; 01 = reset password

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final fireAuth = FirebaseAuth.instance;
  String errorMessage = '';
  String _secretOTP = '';
  final TextEditingController userOTP = TextEditingController();
  final firebaseService = FirebaseService();

  @override
  void initState() {
    // TODO: implement initState
    _firebaseOTPverification();

    super.initState();
  }

  void _firebaseOTPverification() async {
    log("=====> Runing ....");
    context.loaderOverlay.show();
    await fireAuth.verifyPhoneNumber(
      phoneNumber: "+856${widget.phoneNumberOrMail}",
      verificationCompleted: (phoneAuthCredential) {
        log("====>Completed");
        log('$phoneAuthCredential');
        context.loaderOverlay.hide();
        // _loginUser();
      },
      verificationFailed: (FirebaseAuthException e) {
        context.loaderOverlay.hide();
        log("========> FAIIL");
        log("${e.message}");
        if (e.message
            .toString()
            .contains("Please enter the phone number in a format")) {
          setState(() {
            errorMessage =
                "ກະລຸນາກວດສອບ ຮູບແບບເບີໂທໃຫ້ຖືກຕ້ອງ ເຊັ່ນ: 20 9999 9999";
          });
        } else {
          setState(() {
            errorMessage = e.message.toString();
          });
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 20,
            content: Text(
              errorMessage,
              style: const TextStyle(fontFamily: "Noto San Lao"),
            ),
            duration: const Duration(
              seconds: 20,
            ),
          ),
        );
        // context.loaderOverlay.hide();
      },
      codeSent: (String otpMessage, resentOtp) {
        log("====> OTP SEND");
        setState(() {
          _secretOTP = otpMessage;
        });
        log(otpMessage + " OTP Message");
        log(resentOtp.toString() + " => OTP Resent");
        // context.loaderOverlay.hide();
      },
      codeAutoRetrievalTimeout: (String timeOutOTP) {
        log("Timerout " + timeOutOTP);
        _secretOTP = timeOutOTP;
        // context.loaderOverlay.hide();
      },
      timeout: const Duration(
        seconds: 60,
      ),
    );
    // context.loaderOverlay.hide();
  }

  Future<void> _loginUser(userOTP) async {
    try {
      //_firebaseOTPverification();
      await fireAuth
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _secretOTP, smsCode: userOTP))
          .then((value) async {
        if (value.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) => widget.method == 00
                  ? RegisterFormScreen(
                      phone: widget.phoneNumberOrMail,
                    )
                  : ResetPasswordFormScreen(
                      phoneNumber: widget.phoneNumberOrMail,
                    ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('invalid OTP'),
            ),
          );
        }
      });
    } catch (e) {
      FocusScope.of(context).unfocus();
      log("=> error e " + e.toString());
      // if(e)
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 20,
          content: Text(
            "$e",
            style: const TextStyle(fontFamily: "Noto San Lao"),
          ),
          duration: const Duration(
            seconds: 20,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: LoaderOverlay(
        overlayOpacity: 0.5,
        child: Container(
            color: Colors.cyan,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  children: [
                    const Text("OTP Verification "),
                    _secretOTP.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  "Enter OTP sent to: ${widget.phoneNumberOrMail}"),
                              const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                            ],
                          )
                        : errorMessage.isEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "ກຳລັງສົ່ງ OTP ....",
                                    style:
                                        TextStyle(fontFamily: "Noto san lao"),
                                  ),
                                  Icon(
                                    Icons.access_time_rounded,
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "ເກີດຂໍ້ຜິດພາດ",
                                    style:
                                        TextStyle(fontFamily: "Noto san lao"),
                                  ),
                                  Icon(
                                    Icons.close_outlined,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                    CupertinoTextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      style: const TextStyle(
                        // wordSpacing: 30,
                        letterSpacing: 30,
                        fontSize: 30,
                      ),
                      onChanged: (userOTP) async {
                        if (userOTP.length == 6) {
                          context.loaderOverlay.show();
                          await _loginUser(userOTP);
                          context.loaderOverlay.hide();
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "ປ່ຽນເບີໃຫມ່",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontFamily: "Noto San Lao"),
                          ),
                        ),
                        TextButton(
                          onPressed: _firebaseOTPverification,
                          child: const Text(
                            "ບໍ່ໄດ້ຮັບ OTP ສົ່ງລະຫັດໃຫມ່",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontFamily: "Noto San Lao"),
                          ),
                        ),
                      ],
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            )),
      ),
    );
  }
}
