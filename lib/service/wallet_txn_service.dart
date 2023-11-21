import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onestore/config/host_con.dart';
import 'package:onestore/getxcontroller/user_info_controller.dart';
import 'package:onestore/getxcontroller/wallet_txn_controller.dart';
import 'dart:convert' as convert;

import 'package:onestore/models/wallet_txn_model.dart';

class WalletTxnService {
  static final walletTxnController = Get.put(WalletTxnController());
  final userInfoController = Get.put(UserInfoController());
  static Future<void> loadTxn(String userId) async {
    log("Loading Txn ===>");
    final url = Uri.parse(hostname + "wallettxn_crndr_f")
        .resolveUri(Uri(queryParameters: {"user_id": userId}));
    final response = await http.get(
      url,
      headers: {
        "accept": "application/json",
        "content-type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      //Good connection
      var jsonResponse = convert.jsonDecode(response.body) as List;
      List<WalletTxnModel> walletTxnItem = jsonResponse
          .map(
            (e) => WalletTxnModel(
              code: e["txn_his_id"],
              sign: e["txn_sign"],
              txn: e["txn_code_name"],
              amount: double.parse(e["txn_his_amount"].toString()),
              date: e["txn_his_date"],
            ),
          )
          .toList();
      log("======> WALLET TXN LEN: " + walletTxnItem.length.toString());
      walletTxnController.setWalletTxnItem(walletTxnItem);
      loadTxnFromOrders(userId);
    } else {
      //Bad connectoin
      log("Bad connection");
    }
  }

  static Future<void> loadTxnFromOrders(String userId) async {
    final url = Uri.parse(hostname + "wallettxn_order_f")
        .resolveUri(Uri(queryParameters: {"user_id": userId}));
    final response = await http.get(
      url,
      headers: {
        "accept": "application/json",
        "content-type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      //Good connection
      var jsonResponse = convert.jsonDecode(response.body) as List;
      List<WalletTxnModel> walletTxnItem = jsonResponse
          .map(
            (e) => WalletTxnModel(
              code: e["order_id"],
              sign: "DR",
              txn: "ລາຍການສັ່ງຊື້",
              amount: double.parse(e["order_price_total"].toString()),
              date: e["txn_date"],
            ),
          )
          .toList();

      walletTxnController.addWalletTxnItem(walletTxnItem);
    } else {
      //Bad connectoin
      log("Bad connection");
    }
  }
}
