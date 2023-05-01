import 'dart:convert' as convert;
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:onestore/config/host_con.dart';
import 'package:onestore/models/register_data.dart';

import 'firbase_service.dart';

class RegisterService {
  final fireService = FirebaseService();
  final fireAuth = FirebaseAuth.instance;
  Future registerCustomer(RegisterData cus) async {
    final url = Uri.parse(hostname + "register_i");
    final respones = await http.post(url,
        body: convert.json.encode({
          "cust_name": cus.custName,
          "cust_pass": cus.custPassword,
          "cust_phone": cus.custTel,
          "cust_email": cus.custEmail,
          "cust_gameId": cus.custGameId,
          "cust_village": cus.custVillage,
          "cust_district": cus.custDistrict,
          "cust_province": cus.custProvince,
        }),
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
          // 'Content-Type': 'multipart/form-data' ,
        });
    if (respones.statusCode == 200) {
      if (respones.body.contains("completed")) {
        //Transaction complete
        //         Map<String, String> body = {
        //     'remark': "FILE FROM USER PROFILE PHOTO",
        //     'ref': cus.custEmail.isEmpty?cus.custTel:cus.custEmail,
        //     'app_id': "IMG_PROFILE",
        //   };
        //   log("Image path: " + _selImage.path);
        //   ImageUploadService.uploadImage2(
        //       body, _selImage.path, _selImage);
        // };

        return 200;
      } else {
        //Transaction fail
        log("Server error: " + respones.body);
        return 503;
      }
    } else {
      // Network problem
      return 404;
    }
  }

  // Future uploadProfilePhoto(image) async {
  //   var url = Uri.parse(hostname + "uploadProfile");
  //   var response = await http.post(url, headers: {
  //     'Content-Type': 'multipart/form-data',
  //   });
  // }
}
