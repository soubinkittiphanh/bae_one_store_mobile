import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:onestore/config/host_con.dart';
import 'dart:convert' as convert;

class UserInfService {
  static Future<String> username(id, name) async {
    final url = Uri.parse(hostname + "username_e");
    final response = await http.post(url,
        body: jsonEncode({"user_id": id, "user_name": name}),
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
        });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      log("ERROR: ====> " + response.body);

      return response.body;
    }
  }

  static Future<String> usertel(id, tel) async {
    final url = Uri.parse(hostname + "usertel_e");
    final response = await http.post(url,
        body: jsonEncode({"user_id": id, "user_phone": tel}),
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
        });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      log("ERROR: ====> " + response.body);
      return response.body;
    }
  }

  static Future<String> userpass(id, pass) async {
    final url = Uri.parse(hostname + "userpass_e");
    final response = await http.post(url,
        body: jsonEncode({"user_id": id, "user_password": pass}),
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
        });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      log("ERROR: ====> " + response.body);
      return response.body;
    }
  }

  static Future<String> useremail(id, mail) async {
    final url = Uri.parse(hostname + "useremail_e");
    final response = await http.post(url,
        body: jsonEncode({"user_id": id, "user_email": mail}),
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
        });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      log("ERROR: ====> " + response.body);
      return response.body;
    }
  }

  static Future<dynamic> userbalance(id) async {
    final url = Uri.parse(hostname + "userbalance_f");
    final response =
        await http.post(url, body: jsonEncode({"user_id": id}), headers: {
      "accept": "application/json",
      "content-type": "application/json",
    });
    if (response.statusCode == 200) {
      log(response.body);
      final responseData = convert.jsonDecode(response.body) as List;
      List<double> bal = [
        double.parse(responseData[0]["credit"].toString()),
        double.parse(responseData[0]["debit"].toString()),
        double.parse(responseData[0]["balance"].toString()),
      ];
      return bal;
    } else {
      log("ERROR: ====> " + response.body);
      return response.body;
    }
  }

  static Future<int> resetPasswordByPhoneNumber(
      phoneNumber, String password) async {
    final url = Uri.parse(hostname + "resetpassword_e");
    final response = await http.post(url,
        body: jsonEncode({"user_phone": phoneNumber, "password": password}),
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
        });
    if (response.statusCode == 200) {
      log(response.body);
      if (response.body.contains("completed")) {
        return 200; //reset complete
      } else {
        log("message from server: " + response.body);
        return 503; //Reset not succeed
      }
    } else {
      log("ERROR: ====> " + response.body);
      return 404; // Server error;
    }
  }
}
