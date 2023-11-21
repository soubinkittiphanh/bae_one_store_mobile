import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onestore/config/host_con.dart';
import 'dart:convert' as convert;

class Ad {
  static String imgPath = '';
  static String imgName = '';
  static int isActive = 0;
  static Future loadAd() async {
    var uri = Uri.parse(hostname + "ad_f");
    final response = await http.get(
      uri,
      // body: jsonEncode({"cus_id": loginId, "cus_pwd": _txtPassController.text}),
      headers: {
        "accept": "application/json",
        "content-type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      var responseJson = convert.jsonDecode(response.body);
      isActive = responseJson[0]['isactive'];
      imgPath = hostname + responseJson[0]['img_path'];
      // imgPath = Hostname +
      //     "uploads/1641548893177b92b6534-cb5f-4cab-8182-c89ab72ad149.jpg";
      imgName = responseJson[0]['img_name'];
      log("Response assignment: " +
          isActive.toString() +
          " " +
          imgPath +
          " " +
          imgName);
    } else {
      log("AD Loading not succeed");
    }
  }

  static void disableAd() {
    isActive = 0;
  }

  static get isactive {
    return isActive;
  }

  static Widget showInfoDialogIos(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return CupertinoAlertDialog(
      title: const Text(
        "ໂປໂມຊັ່ນ",
        style: TextStyle(fontFamily: 'noto san lao'),
      ),
      content: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0.1),
        width: deviceSize.width * 0.98,
        height: deviceSize.height * 0.55,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: imgPath,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error_outline),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1, color: Colors.red),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  static Widget showInfoDialogAndroid(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return AlertDialog(
      title: const Text(
        "ໂປໂມຊັ່ນ",
        style: TextStyle(fontFamily: 'noto san lao'),
      ),
      // insetPadding: EdgeInsets.zero,
      content: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0.1),
        width: deviceSize.width * 0.98,
        height: deviceSize.height * 0.55,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: imgPath,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 0.1, color: Colors.red),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Ok"),
        ),
      ],
    );
  }
}
