import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/getxcontroller/outlet_controller.dart';
import 'package:onestore/models/outlet_model.dart';
import 'package:onestore/widgets/common/my_textField.dart';

import '../widgets/ticket/ticket_preview_comp.dart';

class AlertSmart {
  static errorDialog(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.SCALE,
      headerAnimationLoop: true,
      title: 'Error',
      desc: message,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
    ).show();
  }

  static cancelOrder(BuildContext context, String message, Function function) {
    List<int> cancelType = [2, 3];
    int selectedCacelType = 2;
    TextEditingController textEditingController = TextEditingController();
    AwesomeDialog(
        context: context,
        dialogBackgroundColor: kPrimaryColor,
        dialogType: DialogType.WARNING,
        animType: AnimType.SCALE,
        headerAnimationLoop: true,
        // title: 'ກະລຸນາໃສ່ເຫດຜົນ ການຍົກເລີກ',
        desc: message,
        btnOkOnPress: () {
          function(selectedCacelType, textEditingController.text);
        },
        btnOkIcon: Icons.cancel,
        btnOkColor: kTextPrimaryColor,
        body: StatefulBuilder(
          builder: (context, setState) => Padding(
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
                SizedBox(
                  // width: deviceSize.width * 0.8,

                  child: DropdownButtonFormField<int>(
                    value: selectedCacelType,
                    style: const TextStyle(
                      fontFamily: "noto san lao",
                      color: Colors.white,
                    ),
                    dropdownColor: kPrimaryColor,
                    decoration: InputDecoration(
                      // fillColor: Colors.red,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          // width: 0.5,
                          color: Colors.white.withOpacity(0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          // width: 0.5,
                          color: Colors.white.withOpacity(0),
                        ),
                      ),
                    ),
                    items: cancelType
                        .map(
                          (item) => DropdownMenuItem<int>(
                            value: item,
                            child: Text(
                              '${item == 2 ? 'Cancel' : 'Return'} ',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (item) {
                      setState(() {
                        selectedCacelType = item!;
                      });
                    },
                    validator: (value) =>
                        value == null ? "ກລນ ບ່ອນຈັດສົ່ງ" : null,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  textEditingController: textEditingController,
                  hintText: 'ເຫດຜົນການຍົກເລີກ',
                )
              ],
            ),
          ),
        )).show();
  }

  static inofDialog(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      headerAnimationLoop: true,
      title: 'Info',
      desc: message,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
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
      BuildContext context, String message, Function okPress) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.NO_HEADER,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            title: message,
            btnOkColor: kPrimaryColor,
            btnOkOnPress: () async {
              await okPress();
            },
            btnOkText: "ພິມບິນ",
            buttonsTextStyle: const TextStyle(fontFamily: "noto san lao"),
            btnCancelColor: kSecodaryColor,
            btnCancelOnPress: () {
              // Navigator.of(context).pop();
            },
            body: const TicketPreviewComp())
        .show();
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
