import 'dart:developer';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:onestore/models/inbox_message.dart';
import 'package:onestore/service/user_inbox_service.dart';

class MessageController extends GetxController {
  List<InboxMessage> _loadMessage = [];

  Future<void> setloadMessage(List<InboxMessage> messageData) async {
    _loadMessage = [...messageData];
    update();
    log("update completed after update");
  }

  List<InboxMessage> get loadMessage {
    log("Loading message");
    return _loadMessage;
  }

  void setMessageAsRead(id) {
    UserInboxService.markReaded(_loadMessage[id].messageBody);
    _loadMessage.elementAt(id).isRead = true;
    update();
  }

  int get unreadMessage {
    final unlreadInbox =
        _loadMessage.where((element) => element.isRead == false);
    return unlreadInbox.length;
  }

  List<InboxMessage> messageByOrderID(String orderId) {
    final outwardMessage =
        _loadMessage.where((element) => element.orderId == orderId);

    return [...outwardMessage];
  }
}
