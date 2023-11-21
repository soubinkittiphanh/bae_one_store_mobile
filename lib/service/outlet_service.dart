import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onestore/getxcontroller/outlet_controller.dart';
import 'package:onestore/models/outlet_model.dart';
import '../config/host_con.dart';
import 'dart:convert' as convert;

class OutletService {
  static final outletCtr = Get.put(OutletController());
  static loadOutlet() async {
    var url = Uri.parse(hostname + "outlet");
    var response = await http.get(url, headers: {
      "accept": "application/json",
      "content-type": "application/json",
    });
    if (response.statusCode == 200) {
      //Good connection
      var responseJsonData = convert.jsonDecode(response.body) as List;
      log("Loading outlet");
      for (var element in responseJsonData) {
        outletCtr.pushOutlet(
          OutletModel(
              code: element["id"].toString(),
              name: element["name"],
              tel: element["tel"]),
        );
      }
    } else {
      //Bad connection
      log("Bad connection on loading bank");
    }
  }
}
