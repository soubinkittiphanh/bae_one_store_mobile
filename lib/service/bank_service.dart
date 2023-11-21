import 'dart:developer';

import 'package:get/get.dart';
import 'package:onestore/config/host_con.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:onestore/getxcontroller/bank_controller.dart';
import 'package:onestore/models/bank_model.dart';

class BankService {
  static final bankContr = Get.put(BankController());
  static loadBank() async {
    var url = Uri.parse(hostname + "bank_com_f");
    var response = await http.get(url, headers: {
      "accept": "application/json",
      "content-type": "application/json",
    });
    if (response.statusCode == 200) {
      //Good connection
      var responseJsonData = convert.jsonDecode(response.body) as List;
      bankContr.setBank(
        responseJsonData
            .map((e) => BankComp(
                bankCode: e["code"],
                bankName: e["bank_name"],
                bankAbbr: e["bank_remark"]))
            .toList(),
      );
    } else {
      //Bad connection
      log("Bad connection on loading bank");
    }
  }
}
