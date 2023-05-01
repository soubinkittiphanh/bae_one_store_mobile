import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestore/config/host_con.dart';
import 'package:onestore/getxcontroller/user_info_controller.dart';
import 'package:onestore/service/image_upload_service.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({Key? key}) : super(key: key);

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  var _selImage;

  void selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("ImageUpload"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _selImage == null
                  ? IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.camera,
                      ),
                    )
                  : Column(
                      children: [
                        IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.camera,
                          ),
                        ),
                        Stack(
                          children: [
                            InkWell(
                              // child: Material(
                              //   color: Colors.transparent,
                              child: ClipOval(
                                child: Image.file(
                                  _selImage,
                                  height: 160,
                                  width: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // ),
                              onTap: () {
                                showCupertinoModalPopup(
                                    context: context,
                                    builder: (ctx) => CupertinoActionSheet(
                                          actions: [
                                            CupertinoActionSheetAction(
                                              onPressed: () {},
                                              child: const Text("Camera"),
                                            ),
                                            CupertinoActionSheetAction(
                                                onPressed: () {},
                                                child: const Text("Gallery"))
                                          ],
                                        ));
                                showModalBottomSheet(
                                  context: context,
                                  builder: (ctx) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text("Camera"),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.image),
                                        title: Text("Gallery"),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
                                      child: const IconButton(
                                          onPressed: null,
                                          icon: Icon(Icons.add_a_photo,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(_selImage.path),
                      ],
                    ),
              IconButton(
                onPressed: () {
                  Map<String, String> body = {
                    'remark': "FILE FROM USER PROFILE PHOTO",
                    'ref': UserInfoController().userId,
                    'app_id': "IMG_PROFILE",
                  };
                  log("Image path: " + _selImage.path);
                  ImageUploadService.uploadImage(
                      body, _selImage.path, _selImage);
                },
                icon: const Icon(Icons.upload),
              ),
              CachedNetworkImage(
                imageUrl: hostname +
                    "uploads/1644481609877image_picker_E52451FA-9024-4970-8CD6-B3CC270F75E3-77905-00000C5CA3B1EC51.jpg",
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
