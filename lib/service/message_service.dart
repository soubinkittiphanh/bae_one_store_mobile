import 'package:get/get.dart';
import 'package:onestore/getxcontroller/message_controller.dart';
import 'package:onestore/service/user_inbox_service.dart';

class MessageService {
  static final messageController = Get.put(MessageController());
  static loadMessage(userId, String userName) async {
    messageController
        .setloadMessage(await UserInboxService.getInbox(userId, userName));
  }
}
