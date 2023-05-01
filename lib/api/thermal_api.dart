import 'dart:developer';
import 'dart:typed_data';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as native_pdf;

import '../getxcontroller/printer_check_constroller.dart';

class ThermalApi {
  static late Uint8List imageBytes;
  bool connected = false;
  List<dynamic> availableBluetoothDevices = []; // = new List();
  late Uint8List bytes;
  static final printerController = Get.put(PrinterConnectionCheck());

  static Future<void> printTicketFromBlueThermal() async {
    if (!printerController.isConnect()) return;
    List<int> ticket = await generateTicket();
    final printResponse = await BluetoothThermalPrinter.writeBytes(ticket);
    log("Print response: " + printResponse!);
  }

  static Future<List<int>> generateTicket() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];
    await _genImage();
    final image = decodeImage(imageBytes);
    bytes += generator.setGlobalCodeTable('CP1250');
    bytes += generator.image(image!);
    bytes += generator.feed(1);
    return bytes;
  }

  static Future<void> _genImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final document =
        await native_pdf.PdfDocument.openFile('${dir.path}/bae_ticket.pdf');
    final page = await document.getPage(1);
    final pageImage = await page.render(
      width: (page.width * 2) + 90,
      height: (page.height * 2) + 90,
      format: native_pdf.PdfPageImageFormat.png,
      // cropRect: const Rect.fromLTRB(0, 0, 0, 0),
    );
    final bytes = pageImage!.bytes;
    imageBytes = bytes;
    await page.close();
  }
}
