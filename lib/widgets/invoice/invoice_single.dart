import 'package:flutter/material.dart';
import 'package:onestore/config/host_con.dart';
import 'package:onestore/models/inbox_message.dart';
import 'package:onestore/models/invoice_info.dart';

import '../invoice_garena_footer.dart';
import '../invoice_garena_header.dart.bkp';

class InvoiceSingle {
  Widget genGarena(InboxMessage message) {
    return Column(
      children: [
        const InvoiceHeaderGarena(),
        const Text("-----------------------------------"),
        InvoiceItem(
          message: message,
        ),
        InvoiceFooterGarena(qrCode: message.qrCode),
        const Text("--------------------------------")
      ],
    );
  }

  Widget genOther(InboxMessage message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              InvoiceInfo.header(message.category),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // message.category.contains("1002")
            //     ?
            Image.asset(
              message.category.contains("1002")
                  ? "asset/images/royal.jpeg"
                  : InvoiceInfo.logoStr(message.category),
              width: 60,
              height: 60,
            ),
          ],
        ),
        InvoiceItem(
          message: message,
        ),
        InvoiceFooterGarena(
          qrCode: message.qrCode,
        ),
        const Text("--------------------------------")
      ],
    );
  }
}

class InvoiceItem extends StatelessWidget {
  const InvoiceItem({
    Key? key,
    required this.message,
  }) : super(key: key);
  final InboxMessage message;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "ລາຄາ: ${numFormater.format(message.price)} ກີບ",
                  ),
                ],
              ),
              Text(
                "ລະຫັດ: ${message.messageBody}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
