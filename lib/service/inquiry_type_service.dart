import 'dart:developer';

import 'package:get/get.dart';
import 'package:onestore/config/host_con.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:onestore/getxcontroller/chat_type_controller.dart';
import 'package:onestore/models/chat_type_model.dart';

class InquiryTypeService {
  static final chattypeController = Get.put(ChatTypeController());
  static Future<void> initChatType() async {
    final url = Uri.parse(hostname + "chattype_f");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //Connection good
      log("Connection good: Chat type fetch");
      final jsonResponse = convert.jsonDecode(response.body) as List;
      List<ChatTypeModel> chatype = jsonResponse.map((element) {
        log(element["name"]);
        return ChatTypeModel(
            id: element["id"], code: element["code"], name: element["name"]);
      }).toList();
      chattypeController.addChatTypeItem(chatype);
    } else {
      log("Connection fail");
    }
  }
}
