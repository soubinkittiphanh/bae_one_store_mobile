import 'dart:typed_data';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:onestore/api/alert_smart.dart';

import '../getxcontroller/printer_check_constroller.dart';

class PrintHelper {
  static late Uint8List imageBytes;
  static final printerController = Get.put(PrinterConnectionCheck());
  static Future<bool> checkPrinter() async {
    if (!printerController.isConnect()) return false;
    return true;
  }

  static Future<List<int>> getTicket(List<int> barcode) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];
    final image = decodeImage(imageBytes);
    bytes += generator.setGlobalCodeTable('CP1250');
    bytes += generator.image(image!);
    bytes += generator.barcode(Barcode.upcA(barcode));
    bytes += generator.feed(2);
    return bytes;
  }

  static Future<void> printTest(BuildContext context) async {
    List<int> ticket = await generateTestTicket();
    bool isCon = printerController.isConnect();
    if (!isCon) {
      printerController
          .genlogs("Print test logs: Printer connection status = false");
      AlertSmart.inofDialog(context, "Pinter connection is not establish");
      return;
    }
    if (isCon) {
      printerController
          .genlogs("Print test logs: Printer connection status = true");
      BluetoothThermalPrinter.writeBytes(ticket);
    } else {
      printerController.genlogs("Print test logs: Printer is not connect");
      AlertSmart.errorDialog(context, "Printer is not connected");
    }
  }

  //ESC POS UTILL 1.0.O
  static Future<List<int>> generateTestTicket() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];
    bytes += generator.setGlobalCodeTable('CP1250');
    bytes += generator.text('Print Test.');
    return bytes;
  }
}
