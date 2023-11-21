import 'dart:developer';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:onestore/models/chat_type_model.dart';

class ChatTypeController extends GetxController {
  List<ChatTypeModel> chatTypeItem = [];
  void addChatTypeItem(List<ChatTypeModel> item) {
    chatTypeItem = item;
    log("TYPE COUNT: " + chatTypeItem.length.toString());
    update();
  }

  List<ChatTypeModel> get loadChatTypeItem {
    return [...chatTypeItem];
  }
}
