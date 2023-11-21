import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onestore/models/register_data.dart';
import 'package:onestore/screens/login_screen.dart';
import 'package:onestore/service/image_upload_service.dart';
import 'package:onestore/service/register_service.dart';

class RegisterFormScreen extends StatefulWidget {
  const RegisterFormScreen({Key? key, this.email = '', this.phone = ''})
      : super(key: key);
  final String email;
  final String phone;

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  final txtControllerName = TextEditingController();
  final txtControllerVill = TextEditingController();
  final txtControllerDist = TextEditingController();
  final txtControllerPro = TextEditingController();
  final txtControllerPhone = TextEditingController();
  final txtControllerEmail = TextEditingController();
  final txtControllerGameId = TextEditingController();
  final txtControllerPassword = TextEditingController();
  final txtControllerPasswordConfirm = TextEditingController();
  final getisterFormKey = GlobalKey<FormState>();
  final registerService = RegisterService();

  var _selImage;
  // Function _validator(String errorText) {
  //   return (val) {
  //     if (val!.isEmpty) {
  //       return errorText;
  //     }
  //     return null;
  //   };
  // }

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

  void _imageSrc(String src) async {
    final pickedFile = await ImagePicker().pickImage(
        source:
            src.contains("Camera") ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile == null) {
      return;
    } else {
      setState(() {
        _selImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage() async {
    final cusEmail = txtControllerEmail.text;
    final cusTel = txtControllerPhone.text;
    if (_selImage == null) {
      return 'ບໍ່ສຳເລັດ';
    }
    Map<String, String> body = {
      'remark': "FILE FROM USER PROFILE PHOTO",
      'ref': cusEmail.isEmpty ? cusTel : cusEmail,
      'app_id': "IMG_PROFILE",
    };
    log("uploading progile");
    // log("Image path: " + _selImage.path);
    bool isImageUploadDone = await ImageUploadService.uploadImage(
        body, _selImage == null ? '' : _selImage.path, _selImage);
    return isImageUploadDone ? 'ສຳເລັດ' : "ບໍ່ສຳເລັດ";
  }

  @override
  Widget build(BuildContext context) {
    txtControllerPhone.text = widget.phone;
    txtControllerEmail.text = widget.email;
    return Scaffold(
      body: LoaderOverlay(
        child: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: getisterFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          InkWell(
                            child: ClipOval(
                              child: _selImage == null
                                  ? Image.asset(
                                      "asset/images/profile-icon.png",
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
                            // ),
                            onTap: selectImage,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: ClipOval(
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                color: Colors.white,
                                child: ClipOval(
                                    child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.blueAccent,
                                  child: IconButton(
                                      onPressed: selectImage,
                                      icon: const Icon(Icons.add_a_photo,
                                          color: Colors.white)),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: txtControllerName,
                      cursorColor: Colors.purple,
                      style: const TextStyle(fontFamily: "noto san lao"),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "ກະລຸນາໃສ່ຊື່ ໃຫ້ຖືກຕ້ອງ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'ຊຶ້ ແລະ ນານສະກຸນ',
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
                    if (widget.phone.isNotEmpty)
                      TextFormField(
                        controller: txtControllerPhone,
                        cursorColor: Colors.purple,
                        style: const TextStyle(fontFamily: "noto san lao"),
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: 'ເບີໂທ',
                          label: const Text('Login ID'),
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
                    if (widget.phone.isEmpty)
                      const Text(
                        "ເບີໂທຈຳເປັນຕ້ອງໃສ່ເມື່ອທ່ານ ຕ້ອງການ ກູ້ລະຫັດຜ່ານ",
                      ),
                    if (widget.phone.isEmpty)
                      TextFormField(
                        controller: txtControllerPhone,
                        cursorColor: Colors.purple,
                        style: const TextStyle(fontFamily: "noto san lao"),
                        // enabled: false,
                        validator: (phone) {
                          if (phone!.isEmpty || phone.length < 8) {
                            return "ກະລຸນາໃສ່ ເບີໂທໃຫ້ຖືກຕ້ອງ";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'ເບີໂທ',
                          label: const Text('Phone number'),
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
                    if (widget.email.isNotEmpty)
                      buildTextFormField(txtControllerEmail, 'Email'),
                    const SizedBox(
                      height: 20,
                    ),
                    buildTextFormField(txtControllerGameId, 'ໄອດີ ເກມ'),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: txtControllerPassword,
                      cursorColor: Colors.purple,
                      style: const TextStyle(fontFamily: "noto san lao"),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "ກະລຸນາຕັ້ງລະຫັດຜ່ານ";
                        } else if (val.length < 4) {
                          return "ກະລຸນາຕັ້ງລະຫັດຜ່ານ ໃຫ້ສູງກ່ວາ 4 ໂຕ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'ລະຫັດຜ່ານ',
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
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: txtControllerPasswordConfirm,
                      cursorColor: Colors.purple,
                      // style: const TextStyle(fontFamily: "noto san lao"),
                      style: const TextStyle(fontFamily: "noto san lao"),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "ກະລຸນາຢືນຢັນລະຫັດຜ່ານ";
                        } else if (val != txtControllerPassword.text) {
                          return "ລະຫັດຜ່ານບໍ່ຕົງກັນ";
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
                    buildTextFormField(txtControllerVill, 'ບ້ານ'),
                    const SizedBox(
                      height: 20,
                    ),
                    buildTextFormField(txtControllerDist, 'ເມືອງ'),
                    const SizedBox(
                      height: 20,
                    ),
                    buildTextFormField(txtControllerPro, 'ແຂວງ'),
                    const SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        if (getisterFormKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );

                          context.loaderOverlay.show();
                          final custData = RegisterData(
                            custName: txtControllerName.text,
                            custPassword: txtControllerPassword.text,
                            custEmail: widget.email,
                            custGameId: txtControllerGameId.text,
                            custTel: txtControllerPhone.text,
                            custVillage: txtControllerVill.text,
                            custDistrict: txtControllerDist.text,
                            custProvince: txtControllerPro.text,
                          );
                          dynamic response =
                              await registerService.registerCustomer(custData);
                          if (response == 200) {
                            String isImageDone = await _uploadImage();
                            context.loaderOverlay.hide();
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'ລົງທະບຽນສຳເລັດ  ກະລຸນາ ເຂົ້າສູ້ລະບົບ',
                                    style:
                                        TextStyle(fontFamily: 'noto san lao'),
                                  ),
                                  Text(
                                    "Upload profile: " + isImageDone,
                                    style: const TextStyle(
                                        fontFamily: 'noto san lao'),
                                  ),
                                ],
                              )),
                            );

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (ctx) => const LoginScreen(),
                              ),
                            );
                          } else if (response == 503) {
                            context.loaderOverlay.hide();
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Server error: ຜູ້ໃຊ້ ຊ້ຳກັນ'),
                              ),
                            );
                          } else {
                            context.loaderOverlay.hide();
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'ບໍ່ສາມາດລົງທະບຽນໄດ້ ກະລຸນາລອງໃຫມ່ ພາຍຫລັງ'),
                              ),
                            );
                          }
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
                            "ບັນທຶກ",
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(
      TextEditingController txtControllerPro, String hinTxt) {
    return TextFormField(
      controller: txtControllerPro,
      cursorColor: Colors.purple,
      style: const TextStyle(fontFamily: "noto san lao"),
      decoration: InputDecoration(
        hintText: hinTxt,
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
    );
  }
}
