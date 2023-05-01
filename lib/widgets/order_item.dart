import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onestore/api/pdf_api.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/getxcontroller/message_controller.dart';
import 'package:onestore/getxcontroller/order_controller.dart';
import 'package:onestore/getxcontroller/printer_check_constroller.dart';
import 'package:onestore/getxcontroller/product_controller.dart';
import 'package:onestore/helper/order_helper.dart';
import 'package:onestore/helper/printer_helper.dart';
import 'package:onestore/models/inbox_message.dart';
import 'package:onestore/models/order_item_model.dart';
import 'package:get/get.dart';
import 'package:onestore/models/product.dart';
import 'package:onestore/screens/printer_screen.dart';
import 'package:onestore/widgets/common/common.dart';

import '../api/alert_smart.dart';
import '../getxcontroller/dyn_customer_controller.dart';
import '../models/dyn_customer_model.dart';
import 'order_item_detail.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    Key? key,
    required this.loadOrder,
  }) : super(key: key);

  final OrderItemModel loadOrder;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  final printerConnectionCtx = Get.put(PrinterConnectionCheck());
  bool isexpand = false;
  final f = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    final orderProvider = Get.put(OrderController());
    final dynCustomerController = Get.put(DynCustomerController());
    final productController = Get.put(ProductController());
    final Product product =
        productController.productId(widget.loadOrder.prodId);

    DynCustomerModel dynCustomerModel = DynCustomerModel(
      name: widget.loadOrder.customerName,
      tel: widget.loadOrder.customerTel,
      shipping: widget.loadOrder.customerShipping,
      payment: widget.loadOrder.customerPayment,
      outlet: widget.loadOrder.customerOutlet,
      customerAddr: widget.loadOrder.customerAddr,
      shippingFee: widget.loadOrder.customerShippingFee,
      discount: widget.loadOrder.customerDiscount,
      amount: widget.loadOrder.total,
      product: product,
      riderFee: widget.loadOrder.customerRiderFee,
      bookingDate: widget.loadOrder.customerBookingDate,
    );
    Future<void> printTicket() async {
      await CommonUtil.printTicket(context);
    }

    Future<void> previewTicket() async {
      dynCustomerController.addCustomerModel(dynCustomerModel);
      return AlertSmart.ticketPreviewDialog(
          context, "Ticket preview", printTicket);
    }

    Future<void> cacnelTicektAcitvity(int status, String reason) async {
      context.loaderOverlay.show();
      String result = await OrderHelper.cancelOrder(
          widget.loadOrder.orderId, status, reason);
      context.loaderOverlay.hide();
      AlertSmart.inofDialog(context, result);
    }

    Future<void> cancelTicket() async {
      return AlertSmart.cancelOrder(
          context, 'Cancel order', cacnelTicektAcitvity);
    }

    return LoaderOverlay(
      child: Column(
        children: [
          // Card(
          //   margin: const EdgeInsets.all(8),
          //   elevation: 0,
          //   color: Colors.white.withOpacity(0.4),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(
          //       horizontal: 20,
          //       vertical: 10,
          //     ),
          //     child: Column(
          //       children: [
          //         // Row(
          //         //   children: [
          //         //     const Text("ລາຄາເຕັມ: "),
          //         //     Text(orderProvider.orderTotalPriceByIdOringinal(
          //         //         widget.loadOrder.orderId)),
          //         //   ],
          //         // ),
          //         // Row(
          //         //   children: [
          //         //     const Text("ກຳໄລ: "),
          //         //     Text(orderProvider.orderProfit(widget.loadOrder.orderId)),
          //         //   ],
          //         // ),
          //       ],
          //     ),
          //   ),
          // ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.loadOrder.orderStatus.contains('effected')
                    ? Text(
                        "ລະຫັດອໍເດີ: ${widget.loadOrder.orderId} ", //| ວັນທີ: ${widget.loadOrder.orderDate.substring(0, 10)} ${widget.loadOrder.orderDate.substring(11, 19)}",
                        style: Theme.of(context).textTheme.caption)
                    : Text(
                        "ລະຫັດອໍເດີ: ${widget.loadOrder.orderId} ", //| ວັນທີ: ${widget.loadOrder.orderDate.substring(0, 10)} ${widget.loadOrder.orderDate.substring(11, 19)}",
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: kTextSecondaryColor),
                      ),
                Text(
                  "ວັນທີ: ${widget.loadOrder.customerBookingDate}",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: previewTicket,
                      icon: const Icon(
                        Icons.print,
                      ),
                    ),
                    Text(
                      "ລາຄາລວມ: ${orderProvider.orderTotalPriceById(widget.loadOrder.orderId)}",
                    ),
                    Spacer(),
                    if (widget.loadOrder.orderStatus.contains('effected'))
                      IconButton(
                          onPressed: () async {
                            await cancelTicket();
                            // OrderHelper.cancelOrder(widget.loadOrder.orderId, status, reason)
                          },
                          icon: const Icon(
                            Icons.cancel_presentation_outlined,
                            color: kTextPrimaryColor,
                            size: 35,
                          ))
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
              child: OrderItemDetail(orderId: widget.loadOrder.orderId),
              height: 160,
              width: double.infinity,
              // color: Colors.white,
            ), // When you don't want to show menu..
            secondChild: Container(),
            crossFadeState:
                isexpand ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          )
        ],
      ),
    );
  }
}
