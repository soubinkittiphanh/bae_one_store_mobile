import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestore/models/geography_model.dart';
import 'package:onestore/screens/home_screen.dart';
import 'dart:convert' as convert;
import '../config/host_con.dart';
import '../getxcontroller/user_info_controller.dart';
import 'package:http/http.dart' as http;

Future<void> loadGeography() async {
  // var request = Uri.parse(hostname + "order_f").resolveUri(
  final userInfoController = Get.put(UserInfoController());
  final geoController = Get.put(GeographyController());
  var request = Uri.parse(hostname + "api/geography/find").resolveUri(
    Uri(),
  );
  var response = await http.get(
    request,
    headers: {
      "accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + userInfoController.userToken,
    },
  );

  if (response.statusCode == 200) {
    log("Transaction completed");
    var jsonResponse = convert.jsonDecode(response.body) as List;

    for (var element in jsonResponse) {
      log("Pushing geography =>");
      geoController.add(GeographyModel.fromJson(element));
    }
    log("All Geography count => ${geoController.geography.length}");
  } else {
    log("Transaction fail");
    log("ERROR: " + response.body);
  }
  // return "aa";
}

class CommonService {
  Future<void> signOn(
    BuildContext context,
    String userId,
    String password,
    bool rememberMe,
    Function _setCredentail,
    Function _clearCredentail,
  ) async {
    log("Login in ....");

    var uri = Uri.parse(hostname + "userLogin");
    log("Waiting for loginn response");
    final response = await http.post(
      uri,
      body: jsonEncode({
        "mem_id": userId,
        "mem_pwd": password,
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
      } else {
        final responseJson = convert.jsonDecode(response.body);

        // String token = responseJson["accessToken"];
        // if (token.isEmpty) {}
        // String name = responseJson["userName"];
        // String id = responseJson["userId"].toString();
        // String phone = responseJson["userPhone"].toString();
        // String email = responseJson["userEmail"].toString();
        // double debit = double.parse(responseJson["userDebit"].toString());
        // double credit = double.parse(responseJson["userCredit"].toString());
        // String profileImage = responseJson["img_path"].toString();
        // userInfoContoller.setUserInfo(
        //   name,
        //   token,
        //   id,
        //   phone,
        //   email,
        //   debit,
        //   credit,
        //   profileImage,
        // );
        //Credential remember
        rememberMe ? await _setCredentail() : await _clearCredentail();
        // await Ad.loadAd();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            // builder: (ctx) => const MyHomePage(title: "ONLINE STORE JFILL"),
            builder: (ctx) => const HomeScreen(),
          ),
        );
      }
    } else {
      log("error: " + response.body);
    }
  }
}

class GeographyController extends GetxController {
  List<GeographyModel> geographyList = [];
  void add(GeographyModel geography) {
    geographyList.add(geography);

    update();
  }

  List<GeographyModel> get geography {
    return [...geographyList];
  }
}
