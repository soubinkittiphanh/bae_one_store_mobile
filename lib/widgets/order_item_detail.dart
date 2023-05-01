import 'package:flutter/material.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/config/host_con.dart';
import 'package:onestore/getxcontroller/order_controller.dart';
import 'package:get/get.dart';

class OrderItemDetail extends StatelessWidget {
  const OrderItemDetail({
    Key? key,
    required this.orderId,
  }) : super(key: key);
  final String orderId;
  @override
  Widget build(BuildContext context) {
    final oderController = Get.put(OrderController());
    final orderDetail = oderController.orderItemId(orderId);
    return Column(
      children: [
        const Divider(
          height: 1,
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx, id) => ListTile(
              title: Text(
                "${orderDetail[id].prodId} | ${orderDetail[id].proName} | status: ${orderDetail[id].orderStatus} | reason: ${orderDetail[id].orderCancelReason}",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              subtitle: Text(numFormater.format(orderDetail[id].price)),
              leading: CircleAvatar(
                radius: 23.5,
                backgroundColor: kPrimaryColor,
                child: Text("x ${orderDetail[id].customerProductQty}"),
              ),
            ),
            itemCount: orderDetail.length,
          ),
        ),
      ],
    );
  }
}
