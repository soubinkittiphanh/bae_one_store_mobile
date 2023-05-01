import 'dart:developer';

import 'package:get/get.dart';
import 'package:onestore/models/shipping_model.dart';

class ShippingController extends GetxController {
  final List<ShippingModel> shippingList = [];
  void pushShipping(ShippingModel shippingModel) {
    log("pushing shipping");
    shippingList.add(shippingModel);
    update();
    log("Total shipping: " + shippingList.length.toString());
  }

  List<ShippingModel> allShipping() {
    return shippingList;
  }
}
