import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onestore/api/pdf_api.dart';
import 'package:onestore/getxcontroller/dyn_customer_controller.dart';
import 'package:onestore/getxcontroller/outlet_controller.dart';
import 'package:onestore/models/dyn_customer_model.dart';
import 'package:onestore/models/outlet_model.dart';
import 'package:onestore/screens/compo_product_detail.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfTicket {
  final pdf = Document();

  Future<File> generateTicket() async {
    final fontLao =
        await rootBundle.load("asset/font/SaysethaLao/Saysettha-Bold.ttf");
    final laoTtf = Font.ttf(fontLao);
    pdf.addPage(Page(
      build: (ctx) => buildTicketContent(laoTtf),
      pageFormat: PdfPageFormat.undefined,
    ));
    return PdfApi.saveDocument("bae_ticket.pdf", pdf);
  }

  Widget buildTicketContent(Font font) {
    final dynCustCtr = Get.put(DynCustomerController());
    final outLetCtr = Get.put(OutletController());
    final f = NumberFormat("#,###");
    DynCustomerModel dynCustomerModel = dynCustCtr.currentCustomerModel();
    OutletModel outletModel = outLetCtr.findById(dynCustomerModel.outlet);
    double totalAmount = dynCustomerModel.amount - dynCustomerModel.discount;
    bool shippingAtSender = dynCustomerModel.shippingFee == ShippingFee.source;
    return Column(
      children: [
        laoText(lable: "ຮ້ານ: ${outletModel.name}", font: font),
        laoText(lable: "Tel: ${outletModel.tel}", font: font),
        laoText(
            lable: "ສິນຄ້າ: ${dynCustomerModel.product.proName}", font: font),
        laoText(lable: "ຜູ້ຮັບ: ${dynCustomerModel.name}", font: font),
        laoText(lable: "ໂທ: ${dynCustomerModel.tel}", font: font),
        laoText(lable: "ຂົນສົ່ງ: ${dynCustomerModel.shipping}", font: font),
        laoText(
            lable: "ບ່ອນສົ່ງ: ${dynCustomerModel.customerAddr}", font: font),
        // laoText(lable: "ການຊຳລະ: ${dynCustomerModel.payment} ", font: font),
        if (dynCustomerModel.payment == "COD")
          laoText(
            lable: "COD: ${f.format(totalAmount)} ",
            font: font,
          ),

        laoText(
            lable: "ຄ່າຝາກ: ${shippingAtSender ? "ຕົ້ນທາງ" : "ປາຍທາງ"}",
            font: font),

        if (dynCustomerModel.payment.contains("_COD"))
          ...[
            laoText(lable: "ຄ່າເຄື່ອງ: ${f.format(totalAmount)}", font: font),
            laoText(
                lable: "ຄ່າສົ່ງ: ${f.format(dynCustomerModel.riderFee)}",
                font: font),
            laoText(
              lable:
                  "ຍອດລວມ: ${f.format(totalAmount + dynCustomerModel.riderFee)} ",
              font: font,
            ),
          ].toList(),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Text laoText(
      {required String lable,
      required Font font,
      bool isBold = false,
      double size = 12.0}) {
    return Text(
      lable,
      style: TextStyle(
          font: font,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: size),
    );
  }

  // Future<List<Text>> riderFeeTicketFooter(
  //     String riderFee, double productPrice, Font fontLao) async {
  //   final f = NumberFormat("#,###");

  //   Text riderFee = laoText(lable: "ຄ່າສົ່ງ: ${riderFee}", font: fontLao);
  // }
}
