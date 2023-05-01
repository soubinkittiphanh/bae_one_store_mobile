import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:loader_overlay/loader_overlay.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/config/host_con.dart';
import 'package:onestore/getxcontroller/user_info_controller.dart';
import 'package:onestore/getxcontroller/wallet_txn_controller.dart';
import 'package:onestore/screens/login_screen.dart';
import 'package:onestore/screens/update_user_info_screen.dart';
import 'package:onestore/service/image_upload_service.dart';
import 'package:onestore/service/user_info_service.dart';
import 'package:onestore/widgets/common/my_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _selImage;
  @override
  Widget build(BuildContext context) {
    // final f = NumberFormat("#,###");
    // final userCreProvider = Provider.of<UserCredentialProvider>(context);
    // final userInfoService = UserInfService();
    void signOut() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const LoginScreen(),
        ),
      );
    }

    final walletController = Get.put(WalletTxnController());
    final userInfoController = Get.put(UserInfoController());
    void _updateInfo(String selectMetho, defaultValue) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => UpdateUserScreen(
            fieldUpdate: selectMetho,
            defaultValue: defaultValue,
          ),
        ),
      );
    }

    Future<void> _showUserNotification(String isImageUploadDone) async {
      if (Platform.isIOS) {
        showCupertinoModalPopup(
          context: context,
          builder: (ctx) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  isImageUploadDone,
                  style: const TextStyle(fontFamily: 'noto san lao'),
                ),
              )
            ],
          ),
        );
      } else {
        showModalBottomSheet(
          context: context,
          builder: (ctx) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: Text(
                    isImageUploadDone,
                    style: const TextStyle(fontFamily: 'noto san lao'),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        );
      }
    }

    uploadImage() async {
      if (_selImage == null) {
        log("No image");

        return await _showUserNotification("ບໍ່ໄດ້ເລືອກຮູບພາບ");
      }
      context.loaderOverlay.show();

      Map<String, String> body = {
        'remark': "FILE FROM USER PROFILE PHOTO",
        'ref': userInfoController.userId,
        'app_id': "IMG_PROFILE",
      };
      log("Image path: " + _selImage.path);
      bool isImageUploadDone = await ImageUploadService.updateProfileImage(
          body, _selImage.path, _selImage);
      context.loaderOverlay.hide();
      await _showUserNotification(isImageUploadDone ? 'ສຳເລັດ' : "ບໍ່ສຳເລັດ");
      // return isImageUploadDone ? 'ສຳເລັດ' : "ບໍ່ສຳເລັດ";
    }

    void _imageSrc(String src) async {
      final pickedFile = await ImagePicker().pickImage(
          source: src.contains("Camera")
              ? ImageSource.camera
              : ImageSource.gallery);
      if (pickedFile == null) {
        return;
      } else {
        setState(() {
          _selImage = File(pickedFile.path);
        });
      }
    }

    void selectImage() async {
      if (Platform.isIOS) {
        showCupertinoModalPopup(
          context: context,
          builder: (ctx) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  _imageSrc("Camera");
                },
                child: const Text("Camera"),
              ),
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _imageSrc("Gallery");
                  },
                  child: const Text("Gallery"))
            ],
          ),
        );
      } else {
        showModalBottomSheet(
          context: context,
          builder: (ctx) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Camera"),
                  onTap: () {
                    Navigator.of(context).pop();
                    _imageSrc("Camera");
                  }),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.of(context).pop();
                  _imageSrc("Gallery");
                },
              ),
            ],
          ),
        );
      }
    }

    return LoaderOverlay(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  ClipOval(
                    child: Stack(
                      children: [
                        Container(
                          color: kTextPrimaryColor,
                          padding: const EdgeInsets.all(3),
                          child: ClipOval(
                            child: _selImage == null
                                ? CachedNetworkImage(
                                    imageUrl:
                                        hostname + userInfoController.userImage,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'asset/images/profile-icon.png',
                                      height: 160,
                                      width: 160,
                                      fit: BoxFit.cover,
                                    ),
                                    height: 160,
                                    width: 160,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    _selImage,
                                    height: 160,
                                    width: 160,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: ClipOval(
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              // color: Colors.white,
                              child: ClipOval(
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  color: kPrimaryColor,
                                  child: IconButton(
                                      // onPressed: selectImage,
                                      onPressed: selectImage,
                                      icon: const Icon(Icons.add_a_photo,
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MyButton(text: "ບັນທຶກ", press: uploadImage),
                  // ConstDesign.myButton(context, uploadImage, "ບັນທຶກ"),
                  // const IconButton(onPressed: null, icon: Icon(Icons.save)),
                  const Divider(
                    thickness: 0.3,
                  ),
                  GestureDetector(
                    child: ListTile(
                      leading: const Icon(
                        Icons.person,
                      ),
                      title: Text(userInfoController.userName),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                    onTap: () {
                      _updateInfo("name", userInfoController.userName);
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      _updateInfo("tel", userInfoController.userPhone);
                    },
                    child: ListTile(
                      leading: const Icon(
                        Icons.phone_android,
                      ),
                      title: Text(userInfoController.userPhone),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _updateInfo("pass", '');
                    },
                    child: const ListTile(
                      leading: Icon(
                        Icons.security,
                      ),
                      title: Text("********"),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _updateInfo("mail", userInfoController.userEmail);
                    },
                    child: ListTile(
                      leading: const Icon(
                        Icons.email_outlined,
                      ),
                      title: Text(userInfoController.userEmail),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      context.loaderOverlay.show();
                      final balance = await UserInfService.userbalance(
                          userInfoController.userId);
                      log("Balance: " + balance.toString());
                      userInfoController.setUserBalance(balance);
                      context.loaderOverlay.hide();
                    },
                    child: ListTile(
                      leading: const Icon(
                        Icons.account_balance_wallet_outlined,
                      ),
                      title: GetBuilder<WalletTxnController>(builder: (ctr) {
                        return Text(
                          "ຍອດເງິນ: " +
                              numFormater.format(
                                  ctr.totalCR - walletController.totalDR),
                          style: const TextStyle(fontFamily: "noto san lao"),
                        );
                      }),
                      trailing: IconButton(
                        onPressed: () async {
                          context.loaderOverlay.show();
                          final balance = await UserInfService.userbalance(
                              userInfoController.userId);
                          log("Balance: " + balance.toString());
                          userInfoController.setUserBalance(balance);
                          context.loaderOverlay.hide();
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                    ),
                  ),

                  // Text("Image: " + userInfoController.userImage),
                  MyButton(text: "ອອກຈາກລະບົບ", press: signOut)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
