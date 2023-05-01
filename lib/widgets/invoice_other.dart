import 'package:flutter/material.dart';
import 'package:onestore/config/host_con.dart';
import 'package:onestore/models/inbox_message.dart';
import 'package:onestore/models/invoice_info.dart';
import 'package:onestore/widgets/widget_to_image.dart';

import 'invoice_garena_footer.dart';

class InvoiceOther extends StatefulWidget {
  const InvoiceOther({Key? key, required this.message}) : super(key: key);
  final InboxMessage message;
  @override
  _InvoiceOtherState createState() => _InvoiceOtherState();
}

class _InvoiceOtherState extends State<InvoiceOther> {
  late GlobalKey key1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WidgetToImage(builder: (key) {
              key1 = key;
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
                          Text("True Money ${widget.message.orderId}"),
                          Image.network(
                            InvoiceInfo.logoUnitel,
                            width: 20,
                            height: 20,
                          ),
                        ],
                      ),
                      Text('ລາຄາ: ${numFormater.format(widget.message.price)}'),
                      Text(widget.message.messageBody),
                      InvoiceFooterGarena(
                        qrCode: widget.message.qrCode,
                      )
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    ));
  }
}
