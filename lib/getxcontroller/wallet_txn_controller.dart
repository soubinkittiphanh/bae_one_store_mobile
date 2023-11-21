// SELECT h.*,t.txn_id,t.txn_code,c.txn_code_id,c.txn_code_name,c.txn_sign FROM transaction_history h
// LEFT JOIN transaction t ON t.txn_id=h.txn_id
// LEFT JOIN transaction_code c ON c.txn_code_id=t.txn_code
// WHERE h.user_id='1000'

import 'dart:developer';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:onestore/models/wallet_txn_model.dart';

class WalletTxnController extends GetxController {
  List<WalletTxnModel> walletTxnItem = [];
  void setWalletTxnItem(List<WalletTxnModel> item) {
    walletTxnItem = item;
    log("WALLET TXN COUNT: " + walletTxnItem.length.toString());
    log("WALLET TXN 0: " + walletTxnItem[0].sign);
    update();
  }

  void addWalletTxnItem(List<WalletTxnModel> item) {
    for (var el in item) {
      walletTxnItem.add(WalletTxnModel(
          code: el.code,
          sign: el.sign,
          txn: el.txn,
          amount: el.amount,
          date: el.date));
      update();
    }
    log("WALLET TXN AFTER: " + walletTxnItem.length.toString());
  }

  List<WalletTxnModel> get loadWalletTxn {
    return [...walletTxnItem];
  }

  List<WalletTxnModel> get loadWalletTxnCR {
    final drTxn = walletTxnItem.where((element) => element.sign.contains("CR"));
    return [...drTxn];
  }

  List<WalletTxnModel> get loadWalletTxnDR {
    final drTxn = walletTxnItem.where((element) => element.sign.contains("DR"));
    return [...drTxn];
  }

  double get totalDR {
    double total = 0;
    for (var element in loadWalletTxnDR) {
      total += element.amount;
    }
    return total;
  }

  double get totalCR {
    double total = 0;
    for (var element in loadWalletTxnCR) {
      total += element.amount;
    }
    return total;
  }
}
