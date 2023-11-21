import 'package:flutter/material.dart';
import 'package:onestore/models/inbox_message.dart';
import 'package:onestore/models/invoice_info.dart';

import '../invoice_garena_footer.dart';
import 'invoice.dart';

class InvoiceOtherWidget extends StatefulWidget {
  const InvoiceOtherWidget({Key? key, required this.message}) : super(key: key);
  final List<InboxMessage> message;

  @override
  State<InvoiceOtherWidget> createState() => _InvoiceOtherWidgetState();
}

class _InvoiceOtherWidgetState extends State<InvoiceOtherWidget> {
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(InvoiceInfo.header(widget.message[0].category)),
                Image.network(
                  InvoiceInfo.logoStr(widget.message[0].category),
                  width: 20,
                  height: 20,
                ),
              ],
            ),
            Column(
              children: widget.message
                  .map((e) => InvoiceItem(
                        message: e,
                      ))
                  .toList(),
            ),
            InvoiceFooterGarena(
              qrCode: widget.message[0].qrCode,
            )
          ],
        ),
      ),
    );
  }
}
