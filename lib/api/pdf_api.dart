import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onestore/getxcontroller/ticket_header_controller.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static final ticketController = Get.put(TicketHeaderContr());
  static DateFormat formater = DateFormat('dd-MM-yyyy hh:mm');
  static final f = NumberFormat("#,###");

  static Future<File> saveDocument(String fileName, Document doc) async {
    final bytes = await doc.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$fileName");
    await file.writeAsBytes(bytes);
    log("Fie is writed");
    //*****Print ticket*****/
    // await ThermalApi.printTicketFromBlueThermal();
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }

  static Text laoText(
      {required String lable,
      required Font font,
      bool isBold = false,
      double size = 12.0}) {
    return Text(
      lable,
      style: TextStyle(
          font: font,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: size),
    );
  }
}
