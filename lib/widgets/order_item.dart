import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/getxcontroller/order_controller.dart';
import 'package:onestore/getxcontroller/printer_check_constroller.dart';
import 'package:onestore/getxcontroller/product_controller.dart';
import 'package:onestore/helper/order_helper.dart';
import 'package:onestore/models/order_item_model.dart';
import 'package:get/get.dart';
import 'package:onestore/models/product.dart';
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
    final orderController = Get.put(OrderController());
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
      product: [product],
      riderFee: widget.loadOrder.customerRiderFee,
      bookingDate: widget.loadOrder.customerBookingDate,
    );
    Future<void> printTicket() async {
      await CommonUtil.printTicket(context, true);
      // context.loaderOverlay.hide();
    }

    Future<void> previewTicket() async {
      dynCustomerController.addCustomerModel(dynCustomerModel);
      //*********** Set current OrderId FOR print ticket can print item base on current orderId *********** */
      orderController.setCurrentOrderItemId(widget.loadOrder.orderId);

      AlertSmart.ticketPreviewDialog(
          context, "Ticket preview", printTicket, true);
    }

    TextEditingController textEditingController = TextEditingController();
    Future<void> showCancelDialog() async {
      List<int> cancelType = [1, 2, 3];
      int selectedCancelType = 2;
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        dialogBackgroundColor: kPrimaryColor,
        borderSide: const BorderSide(
          color: Colors.green,
          width: 2,
        ),
        // width: 280,
        buttonsBorderRadius: const BorderRadius.all(
          Radius.circular(2),
        ),
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: false,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                "ເລືອກການຍົກເລີກ",
                style: TextStyle(
                  fontFamily: "noto san lao",
                  color: Colors.white,
                ),
              ),
              DropdownButtonFormField<int>(
                value: selectedCancelType,
                style: const TextStyle(
                  fontFamily: "noto san lao",
                  color: Colors.white,
                ),
                dropdownColor: kPrimaryColor,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0),
                    ),
                  ),
                ),
                items: cancelType
                    .map(
                      (item) => DropdownMenuItem<int>(
                        value: item,
                        child: Text(
                          '${item == 1 ? 'Effected' : item == 2 ? 'Cancel' : 'Return'} ',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  selectedCancelType = val!;
                  log("Value selected $val");
                },
                validator: (value) =>
                    value == null ? "ກລນ ເລືອກປະເພດການຍົກເລີກ" : null,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.4),
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: textEditingController,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    fontFamily: "noto san lao",
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      fontFamily: "noto san lao",
                      color: Colors.white,
                    ),
                    hintText: 'ເຫດຜົນ ການຍົກເລີກ',
                    focusedBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        headerAnimationLoop: false,
        animType: AnimType.BOTTOMSLIDE,
        title: 'INFO',
        desc: 'This Dialog can be dismissed touching outside',
        showCloseIcon: true,
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          String orderId = widget.loadOrder.orderId;
          String result = await OrderHelper.cancelOrder(orderId,
              selectedCancelType, widget.loadOrder.orderId); //10764 / 1130
          await AlertSmart.infoDialog(context, result);
        },
      ).show();
    }

    String formDateTime(String dateOrg) {
      String dateAndtime = dateOrg.split('.')[0];
      return dateAndtime.split(" ")[0];
    }

    return LoaderOverlay(
      child: Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.loadOrder.orderStatus.contains('effected')
                    ? FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                            "ເລກອໍເດີ:${widget.loadOrder.customerName} ${widget.loadOrder.orderId} ", //| ວັນທີ: ${widget.loadOrder.orderDate.substring(0, 10)} ${widget.loadOrder.orderDate.substring(11, 19)}",
                            style: Theme.of(context).textTheme.caption),
                      )
                    : FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "ເລກອໍເດີ:${widget.loadOrder.customerName} ${widget.loadOrder.orderId} ", //| ວັນທີ: ${widget.loadOrder.orderDate.substring(0, 10)} ${widget.loadOrder.orderDate.substring(11, 19)}",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: kPri),
                        ),
                      ),
                Text(
                  "ວັນທີ: ${formDateTime(widget.loadOrder.customerBookingDate.toString())}",
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
                      "ລວມ: ${orderController.orderTotalPriceById(widget.loadOrder.orderId)}",
                    ),
                    const Spacer(),
                    // if (widget.loadOrder.orderStatus.contains('effected'))
                    IconButton(
                        onPressed: showCancelDialog,
                        icon: const Icon(
                          Icons.cancel_presentation_outlined,
                          color: kPri,
                          size: 35,
                        ))
                  ],
                ),
                Text(
                  " ສົ່ງ: ${widget.loadOrder.customerAddr}",
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
      ),
    );
  }
}
