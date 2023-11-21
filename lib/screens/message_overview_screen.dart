import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:get/get.dart';
import 'package:onestore/getxcontroller/message_controller.dart';
import 'package:onestore/getxcontroller/rider_controller.dart';
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
    final riderController = Get.put(RiderController());
    void _onRefresh() async {
      // monitor network fetch
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
            child: riderController.allRider.isEmpty
                ? Center(
                    child: Image.asset(
                      'asset/images/waiting.png',
                      // fit: BoxFit.cover,
                      height: 200,
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (ctx, i) => MessageCard(
                      riderModel: riderController.allRider[i],
                      idx: i,
                    ),
                    itemCount: riderController.allRider.length,
                  )),
      ),
    );
  }
}
