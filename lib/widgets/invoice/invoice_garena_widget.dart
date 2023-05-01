import 'package:flutter/material.dart';
import 'package:onestore/models/inbox_message.dart';

import '../invoice_garena_footer.dart';
import '../invoice_garena_header.dart.bkp';
import 'invoice.dart';

class InvoiceGarenaWidget extends StatefulWidget {
  const InvoiceGarenaWidget({Key? key, required this.message})
      : super(key: key);
  final List<InboxMessage> message;

  @override
  State<InvoiceGarenaWidget> createState() => _InvoiceGarenaWidgetState();
}

class _InvoiceGarenaWidgetState extends State<InvoiceGarenaWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: Colors.red,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
      ),
      child: FittedBox(
        child: Column(
          children: [
            const InvoiceHeaderGarena(),
            const Text("-----------------------------------"),

            // InvoiceItem(),
            Column(
              children: widget.message
                  .map(
                    (e) => InvoiceItem(
                      message: e,
                    ),
                  )
                  .toList(),
            ),
            InvoiceFooterGarena(qrCode: widget.message[0].qrCode)
          ],
        ),
      ),
    );
  }
}
