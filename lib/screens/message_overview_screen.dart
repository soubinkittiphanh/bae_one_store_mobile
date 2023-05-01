import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:get/get.dart';
import 'package:onestore/getxcontroller/message_controller.dart';
import 'package:onestore/getxcontroller/user_info_controller.dart';
import 'package:onestore/service/user_inbox_service.dart';
import 'package:onestore/widgets/message_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InboxOverivewScreen extends StatefulWidget {
  const InboxOverivewScreen({Key? key}) : super(key: key);

  @override
  State<InboxOverivewScreen> createState() => _InboxOverivewScreenState();
}

class _InboxOverivewScreenState extends State<InboxOverivewScreen> {
  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    final messageController = Get.put(MessageController());
    // final userCredentialProvider = Provider.of<UserCredentialProvider>(context);
    final userInfoController = Get.put(UserInfoController());
    Future<void> messageFetch() async {
      // context.loaderOverlay.show();
      messageController.setloadMessage(await UserInboxService.getInbox(
          userInfoController.userId, userInfoController.userName));
      // context.loaderOverlay.hide();
    }

    void _onRefresh() async {
      // monitor network fetch

      await messageFetch();

      log("on refresh");
      setState(() {});
      _refreshController.refreshCompleted();
    }

    void _onLoading() async {
      // monitor network fetch
      log("on loading");
      // await Future.delayed(Duration(milliseconds: 1000));

      setState(() {});
      _refreshController.loadComplete();
    }

    return LoaderOverlay(
      child: Container(
        color: Colors.white70,
        child: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: messageController.loadMessage.isEmpty
                ? Center(
                    child: Image.asset(
                      'asset/images/waiting.png',
                      // fit: BoxFit.cover,
                      height: 200,
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (ctx, i) => MessageCard(
                      messageData: messageController.loadMessage[i],
                      idx: i,
                    ),
                    itemCount: messageController.loadMessage.length,
                  )),
      ),
    );
  }
}
