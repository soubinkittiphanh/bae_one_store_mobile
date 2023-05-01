import 'dart:developer';

import 'package:get/get.dart';
import 'package:onestore/getxcontroller/shipping_controller.dart';
import 'package:http/http.dart' as http;
import 'package:onestore/models/shipping_model.dart';
import '../config/host_con.dart';
import 'dart:convert' as convert;

class ShippingService {
  static final shippingCtr = Get.put(ShippingController());
  static loadShipping() async {
    var url = Uri.parse(hostname + "shipping");
    var response = await http.get(url, headers: {
      "accept": "application/json",
      "content-type": "application/json",
    });
    if (response.statusCode == 200) {
      //Good connection
      var responseJsonData = convert.jsonDecode(response.body) as List;
      for (var element in responseJsonData) {
        shippingCtr.pushShipping(
            ShippingModel(code: element["code"], name: element["name"]));
      }
    } else {
      //Bad connection
      log("Bad connection on loading bank");
    }
  }
}
