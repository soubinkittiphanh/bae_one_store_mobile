import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/getxcontroller/printer_check_constroller.dart';
import 'package:onestore/helper/printer_helper.dart';
import 'package:onestore/screens/printer_screen.dart';
import 'package:onestore/widgets/common/my_button.dart';

class CartOverviewAction extends StatelessWidget {
  const CartOverviewAction({
    Key? key,
    required this.placeOrder,
  }) : super(key: key);

  final Function placeOrder;

  @override
  Widget build(BuildContext context) {
    Future<bool> _isPrintCon() async {
      final isconnect = await PrintHelper.checkPrinter();
      return isconnect;
    }

    final printerConnectionCheckController = Get.put(PrinterConnectionCheck());
    Future<void> buttonClick() async {
      if (!await _isPrintCon() &&
          printerConnectionCheckController.isPrinterCheckEnable()) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const PrinterSetting(),
          ),
        );
        return;
      }
      await placeOrder();
    }

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: MyButton(
          text: "ສັ່ງຊື້ເລີຍ",
          press: buttonClick,
          btnColor: kTextPrimaryColor,
        )
        // OutlinedButton(
        //   onPressed: () async {
        //     if (!await _isPrintCon() &&
        //         printerConnectionCheckController.isPrinterCheckEnable()) {
        //       Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (ctx) => const PrinterSetting(),
        //         ),
        //       );
        //       return;
        //     }
        //     await placeOrder();
        //   },
        //   child:
        //   Ink(
        //     decoration: BoxDecoration(
        //       gradient: const LinearGradient(
        //         colors: [kPrimaryColor, kPrimaryColor],
        //         begin: Alignment.centerLeft,
        //         end: Alignment.centerRight,
        //       ),
        //       borderRadius: BorderRadius.circular(30.0),
        //     ),
        //     child: Container(
        //       constraints:
        //           const BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
        //       alignment: Alignment.center,
        //       child: const Text(
        //         "ສັ່ງຊື້ເລີຍ",
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 15,
        //           fontFamily: "noto san lao",
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        );
  }
}
