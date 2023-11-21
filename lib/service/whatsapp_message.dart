import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../getxcontroller/cart_controller.dart';
import '../getxcontroller/dyn_customer_controller.dart';
import '../getxcontroller/outlet_controller.dart';
import '../getxcontroller/product_controller.dart';
import '../models/cart_item_model.dart';
import '../models/dyn_customer_model.dart';
import '../models/outlet_model.dart';
import '../screens/product_detail_screen.dart';

class WhatsappMessage {
  final outLetCtr = Get.put(OutletController());
  final cartController = Get.put(CartController());
  final productController = Get.put(ProductController());
  final dynCustCtr = Get.put(DynCustomerController());
  final f = NumberFormat("#,###");
  String formMessage() {
    List<CartItemModel> cartItem = cartController.cartItem;
    DynCustomerModel dynCustomerModel = dynCustCtr.currentCustomerModel();
    OutletModel outletModel = outLetCtr.findById(dynCustomerModel.outlet);
    double totalAmount = (dynCustomerModel.amount - dynCustomerModel.discount) +
        dynCustomerModel.riderFee;
    bool shippingAtSender = dynCustomerModel.shippingFee == ShippingFee.source;
    return '';
  }
}
