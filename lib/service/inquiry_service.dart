import 'dart:developer';

import 'package:onestore/config/host_con.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class InquiryService {
  // final ;
  Future<void> submitChat(String chatType, String message, String userId,
      Function notifyUser, Function whatsappOpen) async {
    var url = Uri.parse(hostname + 'chat_c');
    var response = await http.post(
      url,
      body: convert.json.encode({
        "chat_type_id": chatType,
        "chat_msg": message,
        "chat_user_id": userId
      }),
      headers: {
        "accept": "application/json",
        "content-type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      //Connection good
      if (response.body.contains("completed")) {
        //Transaction complete
        log("Body" + response.body);
        log("Transaction done");
        notifyUser("Transaction completed: ດຳເນີນການ ສຳເລັດ");
        whatsappOpen();
      } else {
        //Transaction fail
        notifyUser("ດຳເນີນການ ບໍ່ສຳເລັດ: " + response.body);
        log("Transaction fail");
      }
    } else {
      //Connection fail
      notifyUser("Cannot connect server: ບໍ່ສາມາດເຊື່ອມຕໍ່ ເຊີເວີ");
      log("bad server connection ");
    }
  }

  Future<void> loadChatByID(String userId) async {
    var url = Uri.parse(hostname + 'chat_f');

    // Await the http get response, then decode the json-formatted response.
    log("Loading...");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as List;
      // InquiryModel inqModel = InquiryModel(
      //   bankCode: jsonResponse[0]['categ_id'],
      //   bankAcID: "bankAcID",
      //   bankAcName: "bankAcName",
      // );

      log(jsonResponse.toString());
      // productContr.addProductCategory(_loadCategory);
    } else {
      log('Request failed with status: ${response.statusCode}.');
    }
    // return _loadProduct;
  }
}
