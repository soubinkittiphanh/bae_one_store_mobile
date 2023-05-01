import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onestore/getxcontroller/order_controller.dart';
import 'package:onestore/getxcontroller/wallet_txn_controller.dart';
import 'package:onestore/models/order_item_model.dart';
import 'package:onestore/widgets/widget_order_item_detail.dart';

class WithdrawComp extends StatelessWidget {
  const WithdrawComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat("#,###");
    final deviceSize = MediaQuery.of(context).size;
    final walletTxnController = Get.put(WalletTxnController());
    final orderController = Get.put(OrderController());
    List<OrderItemModel> loadOrder = orderController.orderItemNotDuplicate;

    void _showDialog(orderId) {
      OrderItemModel order = loadOrder.firstWhere(
        (element) => element.orderId == orderId,
        // orElse: () => OrderItemModel(
        //   orderId
        // ),
      );
      if (order.orderId.contains("No ele")) {
        log("No element check");
        return;
      }
      if (!Platform.isIOS) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Order detail:"),
            content: Container(
              // width: double.infinity,
              width: deviceSize.width * 0.98,
              height: deviceSize.height * 0.4,
              padding: const EdgeInsets.all(5),
              child: OrderItemDetailWidget(
                loadOrder: loadOrder
                    .firstWhere((element) => element.orderId == orderId),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
        );
      } else {
        showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: const Text('Order detail:'),
            content: Card(
              // width: double.infinity,
              child: OrderItemDetailWidget(
                loadOrder: loadOrder
                    .firstWhere((element) => element.orderId == orderId),
              ),
            ),
            actions: [
              CupertinoDialogAction(
                  child: TextButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
            ],
          ),
        );
      }
    }

    return Center(
      child: GetBuilder<WalletTxnController>(builder: (ctr) {
        return ListView.builder(
          itemBuilder: (ctx, id) => Card(
            child: ListTile(
              onTap: () {
                if (ctr.loadWalletTxnDR[id].code.toString().length < 5) {
                  return;
                }
                log("Order id=>: " + ctr.loadWalletTxnDR[id].code.toString());
                _showDialog(ctr.loadWalletTxnDR[id].code.toString());
              },
              leading: const CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ctr.loadWalletTxnDR[id].date.split("T").first +
                      " " +
                      ctr.loadWalletTxnDR[id].date
                          .split("T")
                          .last
                          .substring(0, 8)),
                  Text(
                    ctr.loadWalletTxnDR[id].txn,
                    style: const TextStyle(fontFamily: "noto san lao"),
                  ),
                  // Text(ctr.loadWalletTxnCR[id].code.toString())
                ],
              ),
              subtitle: Text(
                f.format(ctr.loadWalletTxnDR[id].amount),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
          itemCount: walletTxnController.loadWalletTxnDR.length > 30
              ? (walletTxnController.loadWalletTxnDR.length + 20) -
                  walletTxnController.loadWalletTxnDR.length
              : walletTxnController.loadWalletTxnDR.length,
        );
      }),
    );
  }
}
