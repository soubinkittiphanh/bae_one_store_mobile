import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/getxcontroller/outlet_controller.dart';
import 'package:onestore/models/outlet_model.dart';
import '../widgets/cancel_dialog_content.dart';
import '../widgets/ticket/ticket_preview_comp.dart';

class AlertSmart {
  static errorDialog(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.SCALE,
      headerAnimationLoop: true,
      // title: 'Error',
      desc: message,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: kTextPrimaryColor,
    ).show();
  }

  /// Displays a dialog for cancelling an order.
  ///
  /// The [context] parameter is required and specifies the build context.
  ///
  /// The [message] parameter is required and specifies the message to display in the dialog.
  ///
  /// The [orderId] parameter is required and specifies the ID of the order to cancel.
  static cancelOrder(
      BuildContext context, String message, Function cancelProcess) {
    final List<int> cancelType = [1, 2, 3];
    int selectedCancelType = 1;
    final TextEditingController textEditingController =
        TextEditingController(text: 'ບິນຊ້ຳ');

    AwesomeDialog(
      context: context,
      dialogBackgroundColor: kPrimaryColor,
      dialogType: DialogType.WARNING,
      animType: AnimType.SCALE,
      headerAnimationLoop: true,
      dismissOnTouchOutside: true,
      desc: message,
      btnOkOnPress: () async {
        cancelProcess(selectedCancelType, textEditingController.text);
      },
      btnOkIcon: Icons.cancel,
      btnOkColor: kTextPrimaryColor,
      body: CancelOrderDialogContent(
        cancelType: cancelType,
        selectedCancelType: selectedCancelType,
        textEditingController: textEditingController,
        onSelectedCancelTypeChanged: (item) => selectedCancelType = item,
        onTextChanged: (val) => textEditingController.text = val,
      ),
    ).show();
  }

  // static cancelOrder(BuildContext context, String message, String orderId) {
  //   List<int> cancelType = [1, 2, 3];
  //   int selectedCacelType = 1;
  //   TextEditingController textEditingController = TextEditingController();
  //   textEditingController.text = 'ບິນຊ້ຳ';
  //   AwesomeDialog(
  //       context: context,
  //       dialogBackgroundColor: kPrimaryColor,
  //       dialogType: DialogType.WARNING,
  //       animType: AnimType.SCALE,
  //       headerAnimationLoop: true,
  //       // title: 'ກະລຸນາໃສ່ເຫດຜົນ ການຍົກເລີກ',
  //       dismissOnTouchOutside: true,
  //       desc: message,
  //       btnOkOnPress: () async {
  //         log("ON DIALOG CANCEL....");
  //         // await onPressed.call(selectedCacelType, textEditingController.text);
  //         log("TXN DESC " + textEditingController.text);
  //         String result = await OrderHelper.cancelOrder(
  //             orderId, selectedCacelType, textEditingController.text);

  //         Navigator.of(context).pop();
  //         infoDialog(context, result);
  //       },
  //       btnOkIcon: Icons.cancel,
  //       btnOkColor: kTextPrimaryColor,
  //       body: StatefulBuilder(
  //         builder: (context, setState) => Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             children: [
  //               const Text(
  //                 "ເລືອກການຍົກເລີກ",
  //                 style: TextStyle(
  //                   fontFamily: "noto san lao",
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               SizedBox(
  //                 // width: deviceSize.width * 0.8,

  //                 child: DropdownButtonFormField<int>(
  //                   value: selectedCacelType,
  //                   style: const TextStyle(
  //                     fontFamily: "noto san lao",
  //                     color: Colors.white,
  //                   ),
  //                   dropdownColor: kPrimaryColor,
  //                   decoration: InputDecoration(
  //                     // fillColor: Colors.red,
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(20),
  //                       borderSide: BorderSide(
  //                         // width: 0.5,
  //                         color: Colors.white.withOpacity(0),
  //                       ),
  //                     ),
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(20),
  //                       borderSide: BorderSide(
  //                         // width: 0.5,
  //                         color: Colors.white.withOpacity(0),
  //                       ),
  //                     ),
  //                   ),
  //                   items: cancelType
  //                       .map(
  //                         (item) => DropdownMenuItem<int>(
  //                           value: item,
  //                           child: Text(
  //                             '${item == 1 ? 'Effected' : item == 2 ? 'Cancel' : 'Return'} ',
  //                             style: const TextStyle(fontSize: 12),
  //                           ),
  //                         ),
  //                       )
  //                       .toList(),
  //                   onChanged: (item) => setState(() {
  //                     selectedCacelType = item!;
  //                   }),
  //                   validator: (value) =>
  //                       value == null ? "ກລນ ເລືອກປະເພດການຍົກເລີກ" : null,
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 20),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(20),
  //                   color: Colors.white.withOpacity(0.4),
  //                 ),
  //                 child: TextField(
  //                   // keyboardType: TextInputType.text,
  //                   keyboardType: TextInputType.multiline,
  //                   maxLines: 4,
  //                   enableSuggestions: false,
  //                   autocorrect: false,
  //                   controller: textEditingController,
  //                   cursorColor: Colors.white,
  //                   style: const TextStyle(
  //                     fontFamily: "noto san lao",
  //                     color: Colors.white,
  //                   ),

  //                   onChanged: (val) => setState(() {
  //                     textEditingController.text = val;
  //                     textEditingController.selection = TextSelection.collapsed(
  //                         offset: textEditingController.text.length);
  //                   }),
  //                   // onTapOutside: pressOutsideEvent(),

  //                   decoration: const InputDecoration(
  //                     hintStyle: TextStyle(
  //                         fontFamily: "noto san lao", color: Colors.white),
  //                     hintText: 'ເຫດຜົນ ການຍົກເລີກ',
  //                     // fillColor: Colors.white,
  //                     focusedBorder: InputBorder.none,
  //                     focusedErrorBorder: InputBorder.none,
  //                     enabledBorder: InputBorder.none,
  //                     errorBorder: InputBorder.none,
  //                   ),
  //                 ),
  //               ),
  //               // MyButton(
  //               //     text: "Ok",
  //               //     press: () async {
  //               //       log("ON DIALOG CANCEL....");
  //               //       // await onPressed.call(selectedCacelType, textEditingController.text);
  //               //       log("TXN DESC " + textEditingController.text);
  //               //       String result = await OrderHelper.cancelOrder(orderId,
  //               //           selectedCacelType, textEditingController.text);

  //               //       Navigator.of(context).pop();
  //               //       infoDialog(context, result);
  //               //     })
  //               // MyTextField(
  //               //   textEditingController: textEditingController,
  //               //   hintText: 'ເຫດຜົນການຍົກເລີກ',
  //               //   onChangeFuction: (val) => setState(
  //               //     () {
  //               //       textEditingController.text = val;
  //               //     },
  //               //   ),
  //               // )
  //             ],
  //           ),
  //         ),
  //       )).show();
  // }

  static printTicketAlert(
      BuildContext context, String message, Function printTicket) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      headerAnimationLoop: true,
      // title: 'Info',
      buttonsTextStyle: const TextStyle(
        fontFamily: "noto san lao",
        color: Colors.white,
      ),
      desc: message,
      btnOkOnPress: () async {
        await printTicket();
      },
      btnCancelText: 'ປິດ',
      btnOkText: 'ພິມບິນ',
      btnCancelOnPress: () {},

      btnOkColor: kPrimaryColor,
    ).show();
  }

  static Future<void> infoDialog(BuildContext context, String message) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      headerAnimationLoop: true,
      // title: 'Info',
      desc: message,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: kPrimaryColor,
    ).show();
  }

  static showExitPopup(
    BuildContext context,
    Function ok,
  ) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            title: 'Info',
            desc: "Do you want to exit app ?",
            btnOkOnPress: () {
              ok();
            },
            btnCancelOnPress: () {},
            btnOkIcon: Icons.cancel,
            btnOkColor: kPrimaryColor,
            btnCancelColor: kSecodaryColor)
        .show();
  }

  static ticketPreviewDialog(
      BuildContext context, String message, Function okPress, bool isReprint) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.SCALE,
        headerAnimationLoop: true,
        title: message,
        btnOkColor: kPrimaryColor,
        btnOkOnPress: () async {
          // context.loaderOverlay.show();
          await okPress();
          // context.loaderOverlay.show();
        },
        btnOkText: isReprint ? "ພິມບິນ" : "Post",
        buttonsTextStyle: const TextStyle(fontFamily: "noto san lao"),
        btnCancelColor: kSecodaryColor,
        btnCancelOnPress: () {},
        dismissOnTouchOutside: false,
        body: TicketPreviewComp(
          isReprint: isReprint,
        )).show();
  }

  static customDialog(
      BuildContext context, String message, Function reloadProduct) {
    final outletCtr = Get.put(OutletController());
    List<OutletModel> allOutlet = outletCtr.allOutletModel();
    AwesomeDialog(
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.SCALE,
      headerAnimationLoop: true,
      title: message,
      body: Column(
        children: allOutlet
            .map(
              (e) => GestureDetector(
                onTap: () {
                  outletCtr.chooseOutlet(e);
                  Navigator.of(context).pop();
                  reloadProduct();
                },
                child: ListTile(
                  leading: Icon(
                    outletCtr.currentOutlet.code == e.code
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank_sharp,
                  ),
                  title: Text(
                    e.code + " - " + e.name,
                    style: TextStyle(
                      color: outletCtr.currentOutlet.code == e.code
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
      context: context,
    ).show();
  }
}

enum Outlet { source, destication }
