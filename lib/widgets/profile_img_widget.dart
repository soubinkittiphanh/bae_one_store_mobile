import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageWidget extends StatefulWidget {
  const ProfileImageWidget({Key? key}) : super(key: key);

  @override
  _ProfileImageWidgetState createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  var _selImage;

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          InkWell(
            // child: Material(
            //   color: Colors.transparent,
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
                      icon: const Icon(Icons.add_a_photo, color: Colors.white)),
                )),
              ),
            ),
          ),
        ],
      ),

      // IconButton(
      //   onPressed: () {
      //     Map<String, String> body = {
      //       'remark': "FILE FROM USER PROFILE PHOTO",
      //       'ref': UserInfoController().userId,
      //       'app_id': "IMG_PROFILE",
      //     };
      //     log("Image path: " + _selImage.path);
      //     ImageUploadService.uploadImage2(
      //         body, _selImage.path, _selImage);
      //   },

      // ),
    );
  }
}
