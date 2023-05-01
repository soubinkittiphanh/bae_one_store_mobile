import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestore/getxcontroller/message_controller.dart';
import 'package:onestore/models/inbox_message.dart';

import 'message_item_detail.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({Key? key, required this.messageData, required this.idx})
      : super(key: key);
  final InboxMessage messageData;
  final int idx;
  @override
  Widget build(BuildContext context) {
    final messageController = Get.put(MessageController());
    return Card(
      elevation: 0.1,
      child: Container(
        //color: Colors.grey,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(width: 0.1, color: Colors.red),
          // color: Colors.blue,
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            messageController.setMessageAsRead(idx);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => MessageItemDetail(inboxmessage: messageData),
              ),
            );
          },
          child: ListTile(
            title: Text(
              'ວັນທີ: ' +
                  messageData.date.toString().substring(0, 10) +
                  ' ເວລາ: ' +
                  messageData.date.toString().substring(11, 19),
              style: const TextStyle(fontFamily: "noto san lao"),
            ),
            subtitle: Text(
              "ລະຫັດອໍເດີ: " + messageData.orderId,
              style: const TextStyle(
                fontFamily: "noto san lao",
                color: Colors.black,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                messageData.isRead
                    ? Icons.mark_email_read_outlined
                    : Icons.mark_email_unread_outlined,
                color: Colors.red,
              ),
              onPressed: () {
                messageController.setMessageAsRead(idx);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) =>
                        MessageItemDetail(inboxmessage: messageData),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
