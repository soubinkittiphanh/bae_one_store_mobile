import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/getxcontroller/user_info_controller.dart';
import 'package:onestore/service/user_info_service.dart';
import 'package:onestore/widgets/common/my_button.dart';

enum SelectMeth {
  username,
  userpass,
  usertel,
  usermail,
}

class UpdateUserScreen extends StatelessWidget {
  const UpdateUserScreen(
      {Key? key, required this.fieldUpdate, this.defaultValue = ''})
      : super(key: key);
  final dynamic fieldUpdate;
  final dynamic defaultValue;

  @override
  Widget build(BuildContext context) {
    var txtUserInputControlloer = TextEditingController();
    txtUserInputControlloer.text = defaultValue;
    // final userInfoController = Provider.of<UserCredentialProvider>(context);
    final userInfoController = Get.put(UserInfoController());

    Future<void> _showInfoDialog(String info) async {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "ຂໍ້ມູນ",
                    style: TextStyle(
                        color: Colors.grey, fontFamily: "noto san lao"),
                  ),
                  info.contains("completed")
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.close,
                          color: Colors.red,
                        )
                ],
              ),
              content: FittedBox(
                fit: BoxFit.contain,
                child: Text(info),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Okay",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            );
          });
    }

    Future<void> saveButtonClick() async {
      context.loaderOverlay.show();
      String respones = '';
      dynamic selectMeth;
      switch (fieldUpdate) {
        case "name":
          {
            log("method: => name");
            selectMeth = SelectMeth.username;
            respones = await UserInfService.username(
                userInfoController.userId, txtUserInputControlloer.text);
          }

          break;
        case "pass":
          {
            log("method: => pass");
            selectMeth = SelectMeth.userpass;
            respones = await UserInfService.userpass(
                userInfoController.userId, txtUserInputControlloer.text);
          }

          break;
        case "tel":
          {
            log("method: => tel");
            selectMeth = SelectMeth.usertel;
            respones = await UserInfService.usertel(
                userInfoController.userId, txtUserInputControlloer.text);
          }

          break;
        case "mail":
          {
            log("method: => mail");
            selectMeth = SelectMeth.usermail;
            respones = await UserInfService.useremail(
                userInfoController.userId, txtUserInputControlloer.text);
          }

          break;
        default:
          {
            log("Invalid function");
          }
      }
      context.loaderOverlay.hide();
      await _showInfoDialog(respones);
      if (respones.contains("completed")) {
        switch (selectMeth) {
          case SelectMeth.username:
            {
              userInfoController.setUserInfo(
                txtUserInputControlloer.text,
                userInfoController.userToken,
                userInfoController.userId,
                userInfoController.userPhone,
                userInfoController.userEmail,
                userInfoController.userDebit,
                userInfoController.userCredit,
                userInfoController.userImage,
              );
            }
            break;
          case SelectMeth.usertel:
            {
              userInfoController.setUserInfo(
                userInfoController.userName,
                userInfoController.userToken,
                userInfoController.userId,
                txtUserInputControlloer.text,
                userInfoController.userEmail,
                userInfoController.userDebit,
                userInfoController.userCredit,
                userInfoController.userImage,
              );
            }
            break;
          case SelectMeth.usermail:
            {
              userInfoController.setUserInfo(
                userInfoController.userName,
                userInfoController.userToken,
                userInfoController.userId,
                userInfoController.userPhone,
                txtUserInputControlloer.text,
                userInfoController.userDebit,
                userInfoController.userCredit,
                userInfoController.userImage,
              );
            }
            break;
          default:
        }
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: LoaderOverlay(
        overlayOpacity: 1,
        child: Container(
          // color: Colors.yellow,
          margin: const EdgeInsets.all(20),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: txtUserInputControlloer,
                  decoration: InputDecoration(
                    hintText: fieldUpdate,
                    labelText: fieldUpdate,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.cyan,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                MyButton(text: "ບັນທຶກ", press: saveButtonClick),
                // Container(
                //   height: 50.0,
                //   margin: const EdgeInsets.all(10),
                //   child: OutlinedButton(
                //     onPressed: saveButtonClick,
                //     child: Ink(
                //       decoration: BoxDecoration(
                //           gradient: const LinearGradient(
                //             colors: [kPrimaryColor, kPrimaryColor],
                //             begin: Alignment.centerLeft,
                //             end: Alignment.centerRight,
                //           ),
                //           borderRadius: BorderRadius.circular(30.0)),
                //       child: Container(
                //         constraints: const BoxConstraints(
                //           maxWidth: 250.0,
                //           minHeight: 50.0,
                //         ),
                //         alignment: Alignment.center,
                //         child: const Text(
                //           "ບັນທຶກ",
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 15,
                //               fontFamily: "noto san lao"),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
