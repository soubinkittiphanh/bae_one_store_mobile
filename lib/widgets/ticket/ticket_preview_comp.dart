import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../getxcontroller/dyn_customer_controller.dart';
import '../../getxcontroller/outlet_controller.dart';
import '../../models/dyn_customer_model.dart';
import '../../models/outlet_model.dart';
import '../../screens/compo_product_detail.dart';

class TicketPreviewComp extends StatelessWidget {
  const TicketPreviewComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildTicketContent();
  }

  Widget buildTicketContent() {
    final dynCustCtr = Get.put(DynCustomerController());
    final outLetCtr = Get.put(OutletController());
    final f = NumberFormat("#,###");
    DynCustomerModel dynCustomerModel = dynCustCtr.currentCustomerModel();
    OutletModel outletModel = outLetCtr.findById(dynCustomerModel.outlet);
    double totalAmount = dynCustomerModel.amount - dynCustomerModel.discount;
    bool shippingAtSender = dynCustomerModel.shippingFee == ShippingFee.source;
    return Column(
      children: [
        Text("ຮ້ານ: ${outletModel.name}"),
        Text("Tel: ${outletModel.tel}"),
        Text("ສິນຄ້າ: ${dynCustomerModel.product.proName}"),
        Text("ຜູ້ຮັບ: ${dynCustomerModel.name}"),
        Text("ໂທ: ${dynCustomerModel.tel}"),
        Text("ຂົນສົ່ງ: ${dynCustomerModel.shipping}"),
        Text("ບ່ອນສົ່ງ: ${dynCustomerModel.customerAddr}"),
        // Text( "ການຊຳລະ: ${dynCustomerModel.payment} "),
        if (dynCustomerModel.payment == "COD")
          Text(
            "COD: ${f.format(totalAmount)} ",
          ),

        Text(
          "ຄ່າຝາກ: ${shippingAtSender ? "ຕົ້ນທາງ" : "ປາຍທາງ"}",
        ),

        if (dynCustomerModel.payment.contains("_COD"))
          ...[
            Text("ຄ່າເຄື່ອງ: ${f.format(totalAmount)}"),
            Text(
              "ຄ່າສົ່ງ: ${f.format(dynCustomerModel.riderFee)}",
            ),
            Text(
              "ຍອດລວມ: ${f.format(totalAmount + dynCustomerModel.riderFee)} ",
            ),
          ].toList(),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
