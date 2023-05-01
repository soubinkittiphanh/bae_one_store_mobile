import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onestore/getxcontroller/wallet_txn_controller.dart';

class TopupComp extends StatelessWidget {
  const TopupComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat("#,###.##");
    final walletTxnController = Get.put(WalletTxnController());
    return Center(
      child: GetBuilder<WalletTxnController>(builder: (ctr) {
        return ListView.builder(
          itemBuilder: (ctx, id) => ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ctr.loadWalletTxnCR[id].date.split("T").first +
                      " " +
                      ctr.loadWalletTxn[id].date
                          .split("T")
                          .last
                          .substring(0, 8),
                ),
                Text(
                  ctr.loadWalletTxnCR[id].txn,
                  style: const TextStyle(fontFamily: "noto san lao"),
                ),
              ],
            ),
            subtitle: Text(
              f.format(ctr.loadWalletTxnCR[id].amount),
              style: const TextStyle(color: Colors.green),
            ),
          ),
          itemCount: walletTxnController.loadWalletTxnCR.length > 30
              ? (walletTxnController.loadWalletTxnCR.length + 20) -
                  walletTxnController.loadWalletTxnCR.length
              : walletTxnController.loadWalletTxnCR.length,
        );
      }),
    );
  }
}
