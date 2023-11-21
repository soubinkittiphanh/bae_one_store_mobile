import 'dart:convert';
import 'dart:developer';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onestore/api/alert_smart.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/config/host_con.dart';
import 'package:onestore/getxcontroller/user_info_controller.dart';
import 'package:onestore/screens/home.dart';
import 'package:onestore/screens/home_screen.dart';
import 'package:onestore/screens/register_email.dart';
import 'package:onestore/screens/reset_password_screen.dart';
import 'package:onestore/service/common_service.dart';
import 'package:onestore/service/sescure_store.dart';
import 'package:onestore/widgets/common/my_button.dart';
import '../localdb/ticket_print_count_db.dart';
import '../models/ticket_print_count_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _txtUserController = TextEditingController();
  final _txtPassController = TextEditingController();
  int txnCount = 0;
  File? image;
  bool rememberMe = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    String _txtUser = await SecureStore.getLoginId() ?? "";
    String _txtPass = await SecureStore.getLoginPass() ?? "";
    String _txtIsRemember = await SecureStore.getRemember() ?? "";
    log("Remember: " + _txtIsRemember);
    setState(() {
      _txtUserController.text = _txtUser;
      _txtPassController.text = _txtPass;
      rememberMe = _txtIsRemember.toString().contains("true") ? true : false;
    });
  }

  Future<void> _showInfoDialog(String info) async {
    return AlertSmart.errorDialog(context, info);
  }

  @override
  Widget build(BuildContext context) {
    final userInfoContoller = Get.put(UserInfoController());

    Future _setCredentail() async {
      await SecureStore.setLoginId(_txtUserController.text);
      await SecureStore.setLoginPassword(_txtPassController.text);
      await SecureStore.setRemember(rememberMe.toString());
    }

    Future _clearCredentail() async {
      await SecureStore.setLoginId("");
      await SecureStore.setLoginPassword("");
      await SecureStore.setRemember("");
    }

    // Future<void> _login() async {
    //   String userId = _txtUserController.text;
    //   String password = _txtPassController.text;
    //   context.loaderOverlay.show();
    //   log("User Signon ====>");
    //   await CommonService().signOn(
    //     context,
    //     userId,
    //     password,
    //     rememberMe,
    //     _setCredentail,
    //     _clearCredentail,
    //   );
    //   context.loaderOverlay.hide();
    // }
    void _login() async {
      context.loaderOverlay.show();
      log("Login in ....");
      if (_txtUserController.text.length < 7 &&
          !_txtUserController.text.contains("@")) {
        context.loaderOverlay.hide();
        return;
      }
      final loginId = _txtUserController.text.contains("@")
          ? _txtUserController.text
          : "20" +
              _txtUserController.text.substring(
                _txtUserController.text.length - 8,
              );
      var uri = Uri.parse(hostname + "cus_auth");
      log("Waiting for loginn response");
      final response = await http.post(
        uri,
        body: jsonEncode({
          "cus_id": loginId,
          "cus_pwd": _txtPassController.text,
          "version": release,
        }),
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        log("response: => " + response.body);
        if (response.body.contains("Error")) {
          log("Body contain error");
          context.loaderOverlay.hide();
          await _showInfoDialog(
              "Server Error: " + response.body.split(":").last);
        } else {
          var responseJson = convert.jsonDecode(response.body);

          String token = responseJson["accessToken"];
          if (token.isEmpty) {
            context.loaderOverlay.hide();
            return await _showInfoDialog("ລະຫັດຜ່ານ ຫລື ໄອດີບໍ່ຖືກຕ້ອງ");
          }
          String name = responseJson["userName"];
          String id = responseJson["userId"].toString();
          String phone = responseJson["userPhone"].toString();
          String email = responseJson["userEmail"].toString();
          double debit = double.parse(responseJson["userDebit"].toString());
          double credit = double.parse(responseJson["userCredit"].toString());
          String profileImage = responseJson["img_path"].toString();
          userInfoContoller.setUserInfo(
            name,
            token,
            id,
            phone,
            email,
            debit,
            credit,
            profileImage,
          );
          //Credential remember
          rememberMe ? await _setCredentail() : await _clearCredentail();
          // await Ad.loadAd();
          context.loaderOverlay.hide();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => const MyHomePage(title: "ONLINE STORE JFILL"),
              // builder: (ctx) => const HomeScreen(),
            ),
          );
        }
      } else {
        log("error: " + response.body);
        await _showInfoDialog("ເກີດຂໍ້ຜິດພາດທາງເຊີເວີ: " + response.body);
        context.loaderOverlay.hide();
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: LoaderOverlay(
        child: Stack(children: [
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "DCOMMERCE",
                  style: TextStyle(
                      fontSize: 30,
                      // fontStyle: FontStyle.italic,
                      color: kPri,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  "ເຂົ້າສູ່ລະບົບ",
                  style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold, color: kPri),
                ),
                const Text(
                  "ຍິນດີຕ້ອນຮັບ ເຂົ້າສູ່ ລະບົບການຂາຍ Dcommerce",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 100,
                ),
                Form(
                  child: Column(
                    children: [
                      Container(
                        // padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: kPri, //.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: _txtUserController,
                          cursorColor: Colors.white,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: const TextStyle(
                            fontFamily: "noto san lao",
                            color: Colors.white,
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "ກະລຸນາໃສ່ ລັອກອິນ ໄອດີ";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'ເບີໂທ ຫລື ອີເມວ',
                            hintStyle: TextStyle(color: Colors.white),
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kPri, //white.withOpacity(0.4),
                        ),
                        child: TextFormField(
                          controller: _txtPassController,
                          cursorColor: Colors.white,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: const TextStyle(
                            fontFamily: "noto san lao",
                            color: Colors.white,
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              log("ກະລຸນາໃສ່ຊື່ ໃຫ້ຖືກຕ້ອງ");
                              return "ກະລຸນາໃສ່ຊື່ ໃຫ້ຖືກຕ້ອງ";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.admin_panel_settings_sharp,
                              color: Colors.white,
                            ),
                            hintText: 'ລະຫັດຜ່ານ',
                            hintStyle: TextStyle(color: Colors.white),
                            fillColor: Colors.white,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ຈື່ລະຫັດຜ່ານ ຂອງຂ້ອຍ?',
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Checkbox(
                      checkColor: kPrimaryColor,
                      activeColor: kPri,
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                  ],
                ),
                MyButton(
                  press: _login,
                  text: "ເຂົ້າສູ່ລະບົບ",
                  btnColor: kPri,
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => {
                        Navigator.of(context).pushNamed(
                          RegistEmailScreen.routerName,
                        )
                      },
                      child: Text(
                        "ລົງທະບຽນ    |",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 20, color: kPri),
                      ),
                    ),
                    TextButton(
                      onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const ResetPassScreen(),
                          ),
                        )
                      },
                      child: Text(
                        "ລືມລະຫັດຜ່ານ ",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 20, color: kPri),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

Future<int> createRecordInLocalDb() async {
  DateTime txnDate = DateTime.now();
  final TicketPrintCountModel txn =
      TicketPrintCountModel(ticketOrderNumber: "9999", lastPrint: txnDate);
  final txnResponse = await TicketPrintCountDb.instance.create(txn);
  return txnResponse.id!;
}


// Future pickImage() async {
//   try {
//     final image = await ImagePicker().pickImage(source: ImageSource.camera);
//     if (image == null) return;
//   } on PlatformException catch (e) {
//     log("Error: " + e.message.toString());
//   }
// }

// class _SecItem {
//   _SecItem(this.key, this.value);

//   final String key;
//   final String value;
// }
