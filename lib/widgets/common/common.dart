import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../api/pdf_api.dart';
import '../../api/pdf_ticket.dart';
import '../../api/thermal_api.dart';
import '../../getxcontroller/printer_check_constroller.dart';
import '../../helper/printer_helper.dart';
import '../../screens/printer_screen.dart';

class CommonUtil {
  static DateTime formatDate(String dbDate) {
    log("DB DATE ORIGIN: " + dbDate);
    String date = dbDate.split("T")[0];
    String time = dbDate.split("T")[1].split(".")[0];
    String mysqlDatetimeString = date + ' ' + time;
    log("DB DATE CONVERT: " + mysqlDatetimeString);
    DateTime now = DateTime.now();
    log("Date flutter " + now.toString());
    return DateTime.parse(mysqlDatetimeString);
  }

  static Future<bool> isPrintCon() async {
    final isconnect = await PrintHelper.checkPrinter();
    return isconnect;
  }

  static Future<void> printTicket(BuildContext context, bool isReprint) async {
    final printerConnectionCheckController = Get.put(PrinterConnectionCheck());
    if (!await isPrintCon() &&
        printerConnectionCheckController.isPrinterCheckEnable()) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const PrinterSetting(),
        ),
      );
      return;
    }
    PdfTicket pdfTicket = PdfTicket();
    File file = await pdfTicket.generateTicket(isReprint);
    if (!printerConnectionCheckController.isPrinterCheckEnable()) {
      PdfApi.openFile(file);
    } else {
      await ThermalApi.printTicketFromBlueThermal();
    }
    // Navigator.of(context).pop();
  }
}
