import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class InvoiceFooterGarena extends StatelessWidget {
  const InvoiceFooterGarena({Key? key, required this.qrCode}) : super(key: key);
  static DateFormat formater = DateFormat('dd-MM-yyyy hh:mm');
  static final today = DateTime.now();
  final String qrCode;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: SfBarcodeGenerator(
              value: qrCode,
              showValue: true,
              symbology: QRCode(),
              textSpacing: 10,
              textStyle: const TextStyle(fontSize: 7),
            ),
          ),

          const Text('ADMIN: 020 9748 9646'),
          Text('ເວລາພິມ: ${formater.format(today)}'),
          const SizedBox(
            height: 30,
          ),

          // Text('ຊຶ້ອອນລາຍ: 020 9998 7077'),
        ],
      ),
    );
  }
}
