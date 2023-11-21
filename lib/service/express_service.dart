import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:onestore/getxcontroller/rider_controller.dart';
import 'package:onestore/getxcontroller/user_info_controller.dart';

import '../config/host_con.dart';
import '../models/rider_model.dart';

class ExpressService {
  Future<void> changeOrderStatus(String trackingNumber, String status) async {
    // var request = Uri.parse(hostname + "order_f").resolveUri(
    final userInfoController = Get.put(UserInfoController());
    final riderController = Get.put(RiderController());
    final url =
        Uri.parse(hostname + "api/order/changeStatus/${trackingNumber}");
    Map<String, dynamic> body = <String, dynamic>{};
    body['status'] = status;
    var response = await http.put(url,
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer " + userInfoController.userToken,
        },
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      log("Transaction completed");
      var responseData = json.decode(response.body);
      var message = responseData['message'];

      log("Change order status => ${message}");
    } else {
      log("Transaction fail");
      var responseData = json.decode(response.body);
      var message = responseData['message'];
      log("ERROR: " + message);
    }
  }
}
