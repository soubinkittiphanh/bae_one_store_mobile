import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onestore/getxcontroller/cart_controller.dart';
import 'package:onestore/getxcontroller/product_controller.dart';
import 'package:onestore/models/cart_item_model.dart';
import '../../getxcontroller/dyn_customer_controller.dart';
import '../../getxcontroller/order_controller.dart';
import '../../getxcontroller/outlet_controller.dart';
import '../../models/dyn_customer_model.dart';
import '../../models/outlet_model.dart';
import '../../screens/product_detail_screen.dart';
import '../../service/ticket_service.dart';

class TicketPreviewComp extends StatelessWidget {
  const TicketPreviewComp({Key? key, required this.isReprint})
      : super(key: key);
  final bool isReprint;
  @override
  Widget build(BuildContext context) {
    return isReprint ? buildTicketContentReprint() : buildTicketContent();
  }

  Widget buildTicketContent() {
    final dynCustCtr = Get.put(DynCustomerController());
    final outLetCtr = Get.put(OutletController());
    final cartController = Get.put(CartController());
    final productController = Get.put(ProductController());
    final f = NumberFormat("#,###");
    List<CartItemModel> cartItem = cartController.cartItem;
    DynCustomerModel dynCustomerModel = dynCustCtr.currentCustomerModel();
    OutletModel outletModel = outLetCtr.findById(dynCustomerModel.outlet);
    double totalAmount = (dynCustomerModel.amount - dynCustomerModel.discount) +
        dynCustomerModel.riderFee;
    bool shippingAtSender = dynCustomerModel.shippingFee == ShippingFee.source;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("ວັນທີ: ${dynCustomerModel.bookingDate}"),
        Text("ຮ້ານ: ${outletModel.name}"),
        Text("Tel: ${outletModel.tel}"),
        Divider(),
        Text("ຜູ້ຮັບ: ${dynCustomerModel.name}"),
        Text("ໂທ: ${dynCustomerModel.tel}"),
        Text("ຂົນສົ່ງ: ${dynCustomerModel.shipping}"),
        Text("ບ່ອນສົ່ງ: ${dynCustomerModel.customerAddr}"),
        if (!dynCustomerModel.payment.contains("_COD"))
          Text(
            "ຄ່າຝາກ: ${shippingAtSender ? "ຕົ້ນທາງ" : "ປາຍທາງ"}",
          ),
        // if (dynCustomerModel.payment.contains("_COD"))
        //   ...[
        //     Text("ຄ່າເຄື່ອງ: ${f.format(totalAmount)}"),
        //     Text(
        //       "ຄ່າສົ່ງ: ${f.format(dynCustomerModel.riderFee)}",
        //     ),
        //     Text(
        //       "ຍອດລວມ: ${f.format(totalAmount)} ",
        //     ),
        //   ].toList(),
        const Divider(),
        ...cartItem
            .map((e) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(productController.productId(e.proId).proName),
                    Text('${f.format(e.price)} x ${e.qty}'),
                  ],
                ))
            .toList(),
        if (dynCustomerModel.discount > 0 &&
            dynCustomerModel.payment.contains("COD"))
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "ສ່ວນຫລຸດ",
              ),
              Text(" ${f.format(dynCustomerModel.discount)}")
            ],
          ),
        if (dynCustomerModel.payment.contains("_COD"))
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "ຄ່າສົ່ງ",
              ),
              Text(" ${f.format(dynCustomerModel.riderFee)}")
            ],
          ),
        const Divider(),
        if (dynCustomerModel.payment.contains("COD"))
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                  TicketService.totalLabelCondition(dynCustomerModel.shipping) +
                      f.format(totalAmount)),
            ],
          ),
      ],
    );
  }

  Widget buildTicketContentReprint() {
    final dynCustCtr = Get.put(DynCustomerController());
    final outLetCtr = Get.put(OutletController());
    final productController = Get.put(ProductController());
    final f = NumberFormat("#,###");

    DynCustomerModel dynCustomerModel = dynCustCtr.currentCustomerModel();
    OutletModel outletModel = outLetCtr.findById(dynCustomerModel.outlet);

    bool shippingAtSender = dynCustomerModel.shippingFee == ShippingFee.source;

    final orderController = Get.put(OrderController());
    final orderDetail =
        orderController.orderItemId(orderController.currentOrderItemId);
    double cartTotal() {
      double total = 0;
      for (var element in orderDetail) {
        total += element.total;
      }
      return total;
    }

    double totalAmount =
        (cartTotal() - dynCustomerModel.discount) + dynCustomerModel.riderFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("ວັນທີ: ${dynCustomerModel.bookingDate.toString().split(" ")[0]}"),
        Text("ຮ້ານ: ${outletModel.name}"),
        Text("Tel: ${outletModel.tel}"),
        // Text("Disco: ${dynCustomerModel.discount}"),
        const Divider(),
        Text("ຜູ້ຮັບ: ${dynCustomerModel.name}"),
        Text("ໂທ: ${dynCustomerModel.tel}"),
        Text("ຂົນສົ່ງ: ${dynCustomerModel.shipping}"),
        Text("ບ່ອນສົ່ງ: ${dynCustomerModel.customerAddr}"),
        if (!dynCustomerModel.payment.contains("_COD") ||
            !dynCustomerModel.shipping.contains('WKI'))
          Text(
            "ຄ່າຝາກ: ${shippingAtSender ? "ຕົ້ນທາງ" : "ປາຍທາງ"}",
          ),
        // if (dynCustomerModel.payment.contains("_COD"))
        //   ...[
        //     Text("ຄ່າເຄື່ອງ: ${f.format(totalAmount)}"),
        //     Text(
        //       "ຄ່າສົ່ງ: ${f.format(dynCustomerModel.riderFee)}",
        //     ),
        //     Text(
        //       "ຍອດລວມ: ${f.format(totalAmount)} ",
        //     ),
        //   ].toList(),
        const Divider(),
        ...orderDetail
            .map((e) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(productController.productId(e.prodId).proName),
                    Text(
                        '${f.format(e.price - dynCustomerModel.discount)} x ${(e.total / e.price)}'),
                  ],
                ))
            .toList(),
        if (dynCustomerModel.discount > 0 &&
            dynCustomerModel.payment.contains("COD"))
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "ສ່ວນຫລຸດ",
              ),
              Text(" ${f.format(dynCustomerModel.discount)}")
            ],
          ),
        if (dynCustomerModel.payment.contains("_COD"))
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "ຄ່າສົ່ງ",
              ),
              Text(" ${f.format(dynCustomerModel.riderFee)}")
            ],
          ),

        const Divider(),
        if (dynCustomerModel.payment.contains("COD"))
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                  TicketService.totalLabelCondition(dynCustomerModel.shipping) +
                      f.format(totalAmount)),
            ],
          ),
      ],
    );
  }
}
