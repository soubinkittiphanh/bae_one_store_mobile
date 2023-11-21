import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:onestore/getxcontroller/rider_controller.dart';
import 'package:onestore/getxcontroller/user_info_controller.dart';

import '../config/host_con.dart';
import '../models/rider_model.dart';

class RiderService {
  Future<void> loadRider() async {
    // var request = Uri.parse(hostname + "order_f").resolveUri(
    final userInfoController = Get.put(UserInfoController());
    final riderController = Get.put(RiderController());
    var request = Uri.parse(hostname + "api/rider/find").resolveUri(
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
        log("Pushing data =>");
        riderController.addRider(RiderModel.fromJson(element));
      }
      log("All rider count => ${riderController.allRider.length}");
    } else {
      log("Transaction fail");
      log("ERROR: " + response.body);
    }
    // return "aa";
  }
}
