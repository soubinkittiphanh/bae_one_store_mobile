import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestore/getxcontroller/order_controller.dart';
import 'package:onestore/models/inbox_message.dart';
import 'package:onestore/models/order_item_model.dart';
import 'package:get/get.dart';

import '../api/pdf_api.dart';
import '../getxcontroller/message_controller.dart';
import '../getxcontroller/printer_check_constroller.dart';
import 'order_item_detail.dart';

class OrderItemDetailWidget extends StatefulWidget {
  const OrderItemDetailWidget({
    Key? key,
    required this.loadOrder,
  }) : super(key: key);

  final OrderItemModel loadOrder;

  @override
  State<OrderItemDetailWidget> createState() => _OrderItemDetailWidgetState();
}

class _OrderItemDetailWidgetState extends State<OrderItemDetailWidget> {
  bool isexpand = false;
  final f = NumberFormat("#,###");
  final inboxController = Get.put(MessageController());
  final printerConnectionCtx = Get.put(PrinterConnectionCheck());
  @override
  Widget build(BuildContext context) {
    final orderProvider = Get.put(OrderController());
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(8),
          elevation: 0,
          // color: Colors.purple,
          child: Column(
            children: [
              Row(
                children: [
                  const Text("ລາຄາເຕັມ: "),
                  Text(orderProvider
                      .orderTotalPriceByIdOringinal(widget.loadOrder.orderId)),
                ],
              ),
              Row(
                children: [
                  const Text("ກຳໄລ: "),
                  Text(orderProvider.orderProfit(widget.loadOrder.orderId)),
                ],
              ),
            ],
          ),
        ),
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ລະຫັດອໍເດີ: ${widget.loadOrder.orderId} ", //| ວັນທີ: ${widget.loadOrder.orderDate.substring(0, 10)} ${widget.loadOrder.orderDate.substring(11, 19)}",
                style: Theme.of(context).textTheme.caption,
              ),
              // Text(
              //   "ວັນທີ: ${widget.loadOrder.orderDate.substring(0, 10)} ${widget.loadOrder.orderDate.substring(11, 19)}",
              //   style: Theme.of(context).textTheme.bodyText2,
              // ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      late File file;

                      // List<InboxMessage> messageList = inboxController
                      //     .messageByOrderID(widget.loadOrder.orderId);
                      // for (var item in messageList) {
                      //   file = await PdfApi.generatePdf(item);
                      // }
                      // if (!printerConnectionCtx.isPrinterCheckEnable()) {
                      //   PdfApi.openFile(file);
                      // }
                    },
                    icon: const Icon(Icons.print),
                  ),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                isexpand = !isexpand;
              });
            },
            icon: Icon(
              isexpand
                  ? Icons.expand_less_outlined
                  : Icons.expand_more_outlined,
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: SizedBox(
            child: OrderItemDetail(
              orderId: widget.loadOrder.orderId,
              // address: widget.loadOrder.customerAddr,
            ),
            height: 160,
            width: double.infinity,
            // color: Colors.white,
          ), // When you don't want to show menu..
          secondChild: Container(),
          crossFadeState:
              isexpand ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        )
      ],
    );
  }
}
