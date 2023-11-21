import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onestore/api/pdf_api.dart';
import 'package:onestore/getxcontroller/cart_controller.dart';
import 'package:onestore/getxcontroller/dyn_customer_controller.dart';
import 'package:onestore/getxcontroller/outlet_controller.dart';
import 'package:onestore/getxcontroller/product_controller.dart';
import 'package:onestore/models/cart_item_model.dart';
import 'package:onestore/models/dyn_customer_model.dart';
import 'package:onestore/models/order_item_model.dart';
import 'package:onestore/models/outlet_model.dart';
import 'package:onestore/screens/product_detail_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../getxcontroller/order_controller.dart';
import '../service/ticket_service.dart';

class PdfTicket {
  final pdf = Document();

  Future<File> generateTicket(bool isReprint) async {
    final fontLao =
        await rootBundle.load("asset/font/SaysethaLao/Saysettha-Bold.ttf");
    final laoTtf = Font.ttf(fontLao);
    // get the size of your content
// final contentWidth = 400; // in points
// final contentHeight = 600; // in points

// // calculate the best-fit page format for your content size
// final pageFormat = PdfPageFormat.getBestFit(
//   contentWidth: contentWidth,
//   contentHeight: contentHeight,
//   orientation: PdfPageOrientation.portrait,
// );
// final contentWidth = 400; // in points
// final contentHeight = 600; // in points

// // calculate the best-fit page format for your content size
// final pageWidth = contentWidth + 72 * 2; // add 1 inch margins on both sides
// final pageHeight = contentHeight + 72 * 2; // add 1 inch margins on top and bottom
// final pageFormat = PdfPageFormat(pageWidth, pageHeight);
// TODO: LET IT GO
    pdf.addPage(
      Page(
          build: (ctx) => isReprint
              ? buildTicketContentForReprint(laoTtf)
              : buildTicketContent(laoTtf),
          pageFormat:
              // PdfPageFormat.roll57.copyWith(marginLeft: 4, marginRight: 12)
              PdfPageFormat.roll80.copyWith(marginLeft: 4, marginRight: 12)
          // const PdfPageFormat(
          //     5.7 * PdfPageFormat.cm, 20 * PdfPageFormat.cm,
          //     marginAll: 0.3 * PdfPageFormat.cm),
          ),
    );
    return PdfApi.saveDocument("bae_ticket.pdf", pdf);
  }

  Widget buildTicketContent(Font font) {
    final dynCustCtr = Get.put(DynCustomerController());
    final outLetCtr = Get.put(OutletController());
    final productController = Get.put(ProductController());
    final f = NumberFormat("#,###");
    DynCustomerModel dynCustomerModel = dynCustCtr.currentCustomerModel();
    OutletModel outletModel = outLetCtr.findById(dynCustomerModel.outlet);
    double totalAmount = (dynCustomerModel.amount - dynCustomerModel.discount) +
        dynCustomerModel.riderFee;
    bool shippingAtSender = dynCustomerModel.shippingFee == ShippingFee.source;
    final cartController = Get.put(CartController());
    List<CartItemModel> cartItem = cartController.cartItem;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        laoText(
            lable:
                "ວັນທີ: ${dynCustomerModel.bookingDate.toString().split(" ")[0]}",
            font: font),
        laoText(lable: "ຮ້ານ: ${outletModel.name}", font: font),
        laoText(lable: "Tel: ${outletModel.tel}", font: font),
        Divider(),
        laoText(lable: "ຜູ້ຮັບ: ${dynCustomerModel.name}", font: font),
        laoText(
          lable: "ໂທ: ${dynCustomerModel.tel}",
          font: font,
          isBold: true,
        ),
        laoText(lable: "ຂົນສົ່ງ: ${dynCustomerModel.shipping}", font: font),
        laoText(
            lable: "ບ່ອນສົ່ງ: ${dynCustomerModel.customerAddr}", font: font),
        if (!dynCustomerModel.payment.contains("_COD"))
          laoText(
              lable: "ຄ່າຝາກ: ${shippingAtSender ? "ຕົ້ນທາງ" : "ປາຍທາງ"}",
              font: font),
        // if (dynCustomerModel.payment.contains("_COD"))
        //   ...[
        //     laoText(lable: "ຄ່າເຄື່ອງ: ${f.format(totalAmount)}", font: font),
        //     laoText(
        //         lable: "ຄ່າສົ່ງ: ${f.format(dynCustomerModel.riderFee)}",
        //         font: font),
        //     laoText(
        //       lable: "ຍອດລວມ: ${f.format(totalAmount)} ",
        //       font: font,
        //     ),
        //   ].toList(),
        Divider(),
        ...cartItem
            .map(
              (e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  laoText(
                      lable: productController.productId(e.proId).proName,
                      font: font,
                      size: 8),
                  laoText(
                      // lable: '${f.format(e.price)} x ${e.qty}',
                      lable: conditionTxn2(dynCustomerModel, e),
                      font: font,
                      size: 8),
                ],
              ),
            )
            .toList(),
        if (dynCustomerModel.discount > 0 &&
            dynCustomerModel.payment.contains("COD"))
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              laoText(lable: "ສ່ວນຫລຸດ", font: font, size: 8),
              laoText(
                  lable: f.format(dynCustomerModel.discount),
                  font: font,
                  size: 8),
            ],
          ),
        if (dynCustomerModel.payment.contains("_COD"))
          Row(
            children: [
              laoText(lable: "ຄ່າສົ່ງ", font: font, size: 8),
              Spacer(),
              laoText(
                  lable: " ${f.format(dynCustomerModel.riderFee)}",
                  font: font,
                  size: 8),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        Divider(),
        if (dynCustomerModel.payment.contains("COD"))
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              laoText(
                  lable: TicketService.totalLabelCondition(
                          dynCustomerModel.shipping) +
                      f.format(totalAmount),
                  font: font),
            ],
          ),
      ],
    );
  }

  Widget buildTicketContentForReprint(Font font) {
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
        laoText(
            lable:
                "ວັນທີ: ${dynCustomerModel.bookingDate.toString().split(" ")[0]}",
            font: font),
        laoText(lable: "ຮ້ານ: ${outletModel.name}", font: font),
        laoText(lable: "Tel: ${outletModel.tel}", font: font),
        Divider(),
        laoText(lable: "ຜູ້ຮັບ: ${dynCustomerModel.name}", font: font),
        // laoText(lable: "ໂທ: ${dynCustomerModel.tel}", font: font),
        laoText(lable: "ໂທ: ${dynCustomerModel.tel}", font: font, isBold: true),
        laoText(lable: "ຂົນສົ່ງ: ${dynCustomerModel.shipping}", font: font),
        laoText(
            lable: "ບ່ອນສົ່ງ: ${dynCustomerModel.customerAddr}", font: font),
        if (!dynCustomerModel.payment.contains("_COD"))
          laoText(
              lable: "ຄ່າຝາກ: ${shippingAtSender ? "ຕົ້ນທາງ" : "ປາຍທາງ"}",
              font: font),
        // if (dynCustomerModel.payment.contains("_COD"))
        //   ...[
        //     laoText(lable: "ຄ່າເຄື່ອງ: ${f.format(totalAmount)}", font: font),
        //     laoText(
        //         lable: "ຄ່າສົ່ງ: ${f.format(dynCustomerModel.riderFee)}",
        //         font: font),
        //     laoText(
        //       lable: "ຍອດລວມ: ${f.format(totalAmount)} ",
        //       font: font,
        //     ),
        //   ].toList(),
        Divider(),
        ...orderDetail
            .map(
              (e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  laoText(
                      lable: productController.productId(e.prodId).proName,
                      font: font,
                      size: 8),
                  laoText(
                      // lable: '${f.format(e.price)} x ${e.total ~/ e.price}',
                      lable: conditionTxn1(dynCustomerModel, e),
                      font: font,
                      size: 8),
                ],
              ),
            )
            .toList(),
        if (dynCustomerModel.discount > 0 &&
            dynCustomerModel.payment.contains("COD"))
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              laoText(lable: "ສ່ວນຫລຸດ", font: font, size: 8),
              laoText(
                  lable: f.format(dynCustomerModel.discount),
                  font: font,
                  size: 8),
            ],
          ),
        if (dynCustomerModel.payment.contains("_COD"))
          Row(
            children: [
              laoText(lable: "ຄ່າສົ່ງ", font: font, size: 8),
              Spacer(),
              laoText(
                  lable: " ${f.format(dynCustomerModel.riderFee)}",
                  font: font,
                  size: 8),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),

        Divider(),
        if (dynCustomerModel.payment.contains("COD"))
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              laoText(
                  lable: TicketService.totalLabelCondition(
                          dynCustomerModel.shipping) +
                      f.format(totalAmount),
                  font: font),
            ],
          ),
      ],
    );
  }

  String conditionTxn1(DynCustomerModel cus, OrderItemModel e) {
    final f = NumberFormat("#,###");
    if (cus.payment.contains("COD")) {
      return '${f.format(e.price)} x ${e.total ~/ e.price}';
    }
    return 'x ${e.total ~/ e.price}';
  }

  String conditionTxn2(DynCustomerModel cus, CartItemModel e) {
    final f = NumberFormat("#,###");
    if (cus.payment.contains("COD")) {
      return '${f.format(e.price)} x ${e.qty}';
    }
    return 'x ${e.qty}';
  }

  Text laoText(
      {required String lable,
      required Font font,
      bool isBold = false,
      double size = 12}) {
    return Text(
      lable,
      style: TextStyle(
        font: font,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: size,
      ),
    );
  }
}
