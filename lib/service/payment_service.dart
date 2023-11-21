import 'dart:developer';

import 'package:get/get.dart';
import 'package:onestore/getxcontroller/payment_controller.dart';
import 'package:http/http.dart' as http;
import 'package:onestore/models/payment_model.dart';
import '../config/host_con.dart';
import 'dart:convert' as convert;

class PaymentService {
  static final paymentCtr = Get.put(PaymentController());
  static loadPayment() async {
    var url = Uri.parse(hostname + "payment");
    var response = await http.get(url, headers: {
      "accept": "application/json",
      "content-type": "application/json",
    });
    if (response.statusCode == 200) {
      //Good connection
      var responseJsonData = convert.jsonDecode(response.body) as List;
      for (var element in responseJsonData) {
        paymentCtr.pushPayment(PaymentModel(
            code: element["payment_code"], name: element["payment_name"]));
      }
    } else {
      //Bad connection
      log("Bad connection on loading bank");
    }
  }
}
