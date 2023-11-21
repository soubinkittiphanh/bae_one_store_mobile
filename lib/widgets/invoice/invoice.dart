import 'package:flutter/material.dart';
import 'package:onestore/config/host_con.dart';
import 'package:onestore/models/inbox_message.dart';
import 'package:onestore/models/invoice_info.dart';

import '../invoice_garena_footer.dart';
import '../invoice_garena_header.dart.bkp';

class Invoice {
  Widget genGarena(List<InboxMessage> message) {
    return Column(
      children: [
        const InvoiceHeaderGarena(),
        const Text("-----------------------------------"),

        // InvoiceItem(),
        Column(
          children: message
              .map((e) => InvoiceItem(
                    message: e,
                  ))
              .toList(),
        ),
        InvoiceFooterGarena(qrCode: message[0].qrCode)
      ],
    );
  }

  Widget genOther(List<InboxMessage> message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(InvoiceInfo.header(message[0].category)),
            Image.network(
              InvoiceInfo.logoStr(message[0].category),
              width: 20,
              height: 20,
            ),
          ],
        ),
        Column(
          children: message
              .map((e) => InvoiceItem(
                    message: e,
                  ))
              .toList(),
        ),
        InvoiceFooterGarena(
          qrCode: message[0].qrCode,
        )
      ],
    );
  }
}

class InvoiceItem extends StatelessWidget {
  const InvoiceItem({
    Key? key,
    required this.message,
  }) : super(key: key);
  final dynamic message;
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
                    " ${numFormater.format(message.price)} ກີບ",
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







// import 'package:flutter/material.dart';
// import 'package:onestore/config/host_con.dart';
// import 'package:onestore/models/inbox_message.dart';
// import 'package:onestore/models/invoice_info.dart';

// import '../invoice_garena_footer.dart';
// import '../invoice_garena_header.dart';

// class Invoice {
//   Widget genGarena(List<InboxMessage> message) {
//     return Container(
//       width: 130,
//       decoration: BoxDecoration(
//         border: Border.all(
//           width: 0.5,
//           color: Colors.red,
//         ),
//         borderRadius: const BorderRadius.all(
//           Radius.circular(
//             10,
//           ),
//         ),
//       ),
//       child: FittedBox(
//         child: Column(
//           children: [
//             const InvoiceHeaderGarena(),
//             const Text("-----------------------------------"),

//             // InvoiceItem(),
//             Column(
//               children: message
//                   .map((e) => InvoiceItem(
//                         message: e,
//                       ))
//                   .toList(),
//             ),
//             InvoiceFooterGarena(qrCode: message[0].qrCode)
//           ],
//         ),
//       ),
//     );
//   }
// }

// class InvoiceItem extends StatelessWidget {
//   const InvoiceItem({
//     Key? key,
//     required this.message,
//   }) : super(key: key);
//   final message;
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     " ${numFormater.format(message.price)} ກີບ",
//                   ),
//                 ],
//               ),
//               Text(
//                 "ລະຫັດ: ${message.messageBody}",
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

// Widget genOther(List<InboxMessage> message) {
//   return Container(
//     width: 130,
//     decoration: BoxDecoration(
//       border: Border.all(
//         width: 0.5,
//         color: Colors.red,
//       ),
//       borderRadius: const BorderRadius.all(
//         Radius.circular(
//           10,
//         ),
//       ),
//     ),
//     child: FittedBox(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(InvoiceInfo.header(message[0].category)),
//               Image.network(
//                 InvoiceInfo.logoStr(message[0].category),
//                 width: 20,
//                 height: 20,
//               ),
//             ],
//           ),
//           Column(
//             children: message
//                 .map((e) => InvoiceItem(
//                       message: e,
//                     ))
//                 .toList(),
//           ),
//           InvoiceFooterGarena(
//             qrCode: message[0].qrCode,
//           )
//         ],
//       ),
//     ),
//   );
// }
