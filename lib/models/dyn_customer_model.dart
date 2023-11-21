import 'package:intl/intl.dart';
import 'package:onestore/models/product.dart';

import '../screens/product_detail_screen.dart';

class DynCustomerModel {
  final String name;
  final String tel;
  final String shipping;
  final String payment;
  final String outlet;
  final String customerAddr;
  final double amount;
  final double discount;
  final ShippingFee? shippingFee;
  final List<Product> product;
  final double riderFee;
  final DateTime bookingDate;
  final int riderId;
  final int geoId;
  DynCustomerModel({
    required this.name,
    required this.tel,
    required this.shipping,
    required this.payment,
    required this.outlet,
    required this.customerAddr,
    required this.amount,
    required this.shippingFee,
    required this.discount,
    required this.product,
    this.riderFee = 0,
    required this.bookingDate,
    this.riderId = 0,
    this.geoId = 1,
  });
  Map toJson() {
    return {
      "name": name,
      "tel": tel,
      "shipping": shipping,
      "payment": payment,
      "outlet": outlet,
      "address": customerAddr,
      "shippingFee":
          shippingFee == ShippingFee.destication ? "destination" : "source",
      "workingDay": DateFormat('yyyy-MM-dd hh:mm:ss').format(bookingDate),
      "discount": discount,
      "riderFee": riderFee,
      "riderId": riderId,
      "geoId": geoId
    };
  }
}
