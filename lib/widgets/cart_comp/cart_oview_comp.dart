import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onestore/api/alert_smart.dart';
import 'package:onestore/getxcontroller/cart_controller.dart';
import 'package:onestore/getxcontroller/dyn_customer_controller.dart';
import 'package:onestore/getxcontroller/product_controller.dart';
import 'package:onestore/getxcontroller/user_info_controller.dart';
import 'package:onestore/helper/order_helper.dart';
import 'package:onestore/models/dyn_customer_model.dart';
import 'package:onestore/screens/login_screen.dart';
import 'package:onestore/service/user_info_service.dart';
import 'package:onestore/widgets/cart_overview/cart_overview_action.dart';
import 'package:onestore/widgets/common/common.dart';

class OrderNowButton extends StatefulWidget {
  const OrderNowButton({
    Key? key,
    required this.pageChange,
    required this.formKey,
    required this.dynCustomerModel,
    required this.discount,
    required this.totalPrice,
  }) : super(key: key);
  final Function pageChange;
  final GlobalKey<FormState> formKey;
  final DynCustomerModel dynCustomerModel;
  final double discount;
  final double totalPrice;
  @override
  State<OrderNowButton> createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  final f = NumberFormat("#,###");
  final proController = Get.put(ProductController());
  final cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    final dynCustomerController = Get.put(DynCustomerController());
    // final printerConnectionCheckController = Get.put(PrinterConnectionCheck());

    final userInfoController = Get.put(UserInfoController());
    // late File file;

    // Future<bool> _isPrintCon() async {
    //   final isconnect = await PrintHelper.checkPrinter();
    //   return isconnect;
    // }

    Future<void> _showInfoDialogIos(String info) async {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoaderOverlay(
            child: CupertinoAlertDialog(
              title: const Text(
                "ລາຍງານ",
                style: TextStyle(fontFamily: 'noto san lao'),
              ),
              content: FittedBox(
                child: Column(
                  children: [
                    Text(
                      info,
                      style: const TextStyle(fontFamily: 'noto san lao'),
                    ),
                    info.contains("complete")
                        ? const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 50,
                          )
                        : const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 50,
                          )
                  ],
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                if (info.contains("complete"))
                  CupertinoDialogAction(
                    child: const Text(
                      "Ok",
                      style: TextStyle(
                        fontFamily: "noto san lao",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      // context.loaderOverlay.show();
                      // if (!await _isPrintCon() &&
                      //     printerConnectionCheckController
                      //         .isPrinterCheckEnable()) {
                      //   context.loaderOverlay.hide();
                      //   Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //       builder: (ctx) => const PrinterSetting(),
                      //     ),
                      //   );
                      //   return;
                      // }

                      // context.loaderOverlay.hide();
                      // if (!printerConnectionCheckController
                      //     .isPrinterCheckEnable()) {
                      //   PdfApi.openFile(file);
                      // } else {
                      //   await ThermalApi.printTicketFromBlueThermal();
                      // }
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          );
        },
      );
    }

    Future<void> _showInfoDialogAndroid(String info) async {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return LoaderOverlay(
              child: AlertDialog(
                title: const Text(
                  "ລາຍງານ",
                  style: TextStyle(fontFamily: 'noto san lao'),
                ),
                content: FittedBox(
                  child: Column(
                    children: [
                      Text(
                        info,
                        style: const TextStyle(fontFamily: 'noto san lao'),
                      ),
                      info.contains("complete")
                          ? const Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 50,
                            )
                          : const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 50,
                            )
                    ],
                  ),
                ),
                actions: [
                  if (info.contains("complete"))
                    TextButton(
                      onPressed: () async {
                        // context.loaderOverlay.show();
                        // if (!await _isPrintCon() &&
                        //     printerConnectionCheckController
                        //         .isPrinterCheckEnable()) {
                        //   context.loaderOverlay.hide();
                        //   Navigator.of(context).push(MaterialPageRoute(
                        //       builder: (ctx) => const PrinterSetting()));
                        //   return;
                        // }

                        // context.loaderOverlay.hide();
                        // // ຖ້າບໍ່ໄດ້ເປີດ ຟັງຊັ້ນ ພິມບິນ ໂດຍບໍ່ເປີດເຄື່ອງ ພິມ ແມ່ນ ໃຫ້ເປີດຟາຍເພື່ອເບິ່ງໃບບິນ/
                        // if (!printerConnectionCheckController
                        //     .isPrinterCheckEnable()) {
                        //   PdfApi.openFile(file);
                        // } else {
                        //   await ThermalApi.printTicketFromBlueThermal();
                        // }
                        Navigator.pop(context);
                        //****************************************************/
                      },
                      child: const Text(
                        "ok",
                        style: TextStyle(
                          fontFamily: "noto san lao",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            );
          });
    }

    String _customResMessage(String res) {
      List<String> subList;
      String reMessage;
      if (res.contains("ສິນຄ້າ")) {
        subList = res.split("|").toList();
        reMessage = proController.productId(int.parse(subList[1])).proName;
        return subList[0] + " " + reMessage + " " + subList[2];
      }
      if (res.contains("TokenExpired")) {
        res = 'Token ຫມົດອາຍຸ ກະລຸນາ ເຂົ້າສູ່ລະບົບໃຫມ່';
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const LoginScreen(),
          ),
        );
      }
      return res;
    }

    void placeOrder() async {
      if (widget.formKey.currentState!.validate()) {
        widget.formKey.currentState!.save();
        // **** assign dynamicustomer *****//
        // widget.dynCustomerModel.discount = widget.discount;
        dynCustomerController.addCustomerModel(widget.dynCustomerModel);
        context.loaderOverlay.show();
        final cartItem = cartController.cartItem;

        //IF ORDER LEN < 1 MEANING NO ORDER TAKEN
        if (cartItem.isEmpty) {
          String res = "No order taken";
          context.loaderOverlay.hide();
          return Platform.isIOS
              ? await _showInfoDialogIos(_customResMessage(res))
              : await _showInfoDialogAndroid(_customResMessage(res));
        }
        //***** assign discount for the cart *******/
        cartItem[0].discountPercent = widget.discount;
        // chack user balance and order price
        final balance =
            await UserInfService.userbalance(userInfoController.userId);
        double currentBalance = balance[2];
        double orderTotalPrice = cartItem.fold(
            0, (previousValue, element) => element.priceTotal + previousValue);
        log("Bal: " + currentBalance.toString());
        log("Sum: " + orderTotalPrice.toString());
        String res = '';
        if (orderTotalPrice > currentBalance) {
          res = 'ຂໍອາໄພ ຍອດເງິນບໍ່ພຽງພໍ';
        } else {
          log("======> Sending order" + DateTime.now().toString());
          res = await OrderHelper.sendOrder(cartItem, userInfoController.userId,
              userInfoController.userToken);
          log("RESPONSE: " + res);
          if (res.endsWith("completed")) {
            log("======> Sending inbox req completed " +
                DateTime.now().toString());
            //*****Generate ticket**** */
            // PdfTicket pdfTicket = PdfTicket();
            // file = await pdfTicket.generateTicket();
            //******* print ticket *******/
            CommonUtil.printTicket(context);
            //*******Clear cart  *******/
            cartItem.length = 0;
            cartController.clearCartItem();
          }
        }

        Platform.isIOS
            ? await _showInfoDialogIos(_customResMessage(res))
            : await _showInfoDialogAndroid(_customResMessage(res));
        context.loaderOverlay.hide();
      }
    }

    Future<void> previewTicket() async {
      dynCustomerController.addCustomerModel(widget.dynCustomerModel);
      return AlertSmart.ticketPreviewDialog(
          context, "Ticket preview", placeOrder);
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "ລາຄາລວມທັງໝົດ: ",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.4)),
              child: Text(
                "${f.format(widget.totalPrice)} ກີບ",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
            )
          ],
        ),
        const Divider(
          color: Colors.white,
        ),
        CartOverviewAction(
          pageChange: widget.pageChange,
          placeOrder: previewTicket,
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
