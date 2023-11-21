import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onestore/config/host_con.dart';
import 'package:onestore/getxcontroller/dyn_customer_controller.dart';
import 'package:onestore/models/cart_item_model.dart';
import 'package:http/http.dart' as http;
import 'package:onestore/models/dyn_customer_model.dart';
import 'package:onestore/models/order_item_model.dart';
import 'dart:convert' as convert;

import '../getxcontroller/user_info_controller.dart';

class OrderHelper {
  static List<OrderItemModel> _orderItem = [];
  static Future<String> sendOrder(
      List<CartItemModel> cart, userId, token) async {
    final url = Uri.parse(hostname + "order_i");
    //********** Get customer information ************//
    final dyCustomerCtr = Get.put(DynCustomerController());
    DynCustomerModel dynCustomerModel = dyCustomerCtr.currentCustomerModel();
    log("cart: $cart");
    var response = await http.post(
      url,
      body: json.encode({
        "cart_data": cart,
        "user_id": userId,
        "customer": dynCustomerModel,
      }),
      headers: {
        "accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer " + token,
      },
    );
    log("response: ${response.statusCode}");
    if (response.statusCode == 200) {
      //connection succeed
      log("Transaction completed");
      log("message server: " + response.body);
    } else {
      //connection fail
      log("Transactino fail");
      log("ERROR: " + response.body);
    }

    return response.body;
  }

  static Future<String> cancelOrder(
    String orderId,
    int status,
    String reason,
  ) async {
    final userInfoController = Get.put(UserInfoController());
    log("Prepared data =====>");
    log(orderId.toString());
    log(status.toString());
    log(userInfoController.userId);
    var request = Uri.parse(hostname + "api/changeOrderStatus");
    var response = await http.put(
      request,
      headers: {
        "accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer " + userInfoController.userToken,
      },
      body: json.encode({
        'orderId': orderId,
        'status': status,
        'userId': userInfoController.userId,
        'reason': reason,
      }),
    );
    if (response.statusCode == 200) {
      // ******** Request status fine *********
      if (response.body.contains("completed")) {
        return 'ດຳເນີນການສຳເລັດ';
      } else {
        log("Error " + response.body);
        return 'ດຳເນີນການລົ້ມເຫລວ ${response.body}';
      }
    } else {
      // ******** Request http fail **********
      log("Error: " + response.body);
      return 'ດຳເນີນການລົ້ມເຫລວ ${response.body}';
    }
  }

  static Future<List<OrderItemModel>> fetchOrder(dateF, dateT) async {
    // var request = Uri.parse(hostname + "order_f").resolveUri(
    final userInfoController = Get.put(UserInfoController());
    var request = Uri.parse(hostname + "api/findByUserId").resolveUri(
      Uri(
        queryParameters: {
          "f_date": DateFormat('yyyy-MM-dd').format(dateF),
          "t_date": DateFormat('yyyy-MM-dd').format(dateT),
          "mem_id": userInfoController.userId,
        },
      ),
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
      _orderItem = jsonResponse.map(
        (el) {
          log("Customer name => " + el['name'].toString());
          log("Discount => " + el['discount'].toString());
          return OrderItemModel.fromJson(el);
        },
      ).toList();
      return _orderItem;
    } else {
      log("Transaction fail");
      log("ERROR: " + response.body);
      return _orderItem;
    }
    // return "aa";
  }

  static Future<List<OrderItemModel>> fetchMaxOrder(userId) async {
    var request = Uri.parse(hostname + "max_order_f").resolveUri(
      Uri(
        queryParameters: {
          "mem_id": userId,
        },
      ),
    );
    var response = await http.get(request);
    if (response.statusCode == 200) {
      log("Transaction completed");
      var jsonResponse = convert.jsonDecode(response.body) as List;
      _orderItem = jsonResponse
          .map(
            (el) => OrderItemModel.fromJson(el),
          )
          .toList();
      return _orderItem;
    } else {
      log("Transaction fail");
      log("ERROR: " + response.body);
      return _orderItem;
    }
    // return "aa";
  }
}
