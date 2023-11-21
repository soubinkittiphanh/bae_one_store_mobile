import 'package:onestore/models/cart_item_model.dart';
import 'package:onestore/models/dyn_customer_model.dart';

class CartModel {
  final String id;
  final DynCustomerModel customer;
  final DateTime valueDate;
  final List<CartItemModel> products;
  CartModel({
    required this.id,
    required this.customer,
    required this.valueDate,
    required this.products,
  });
  Map toJson() {
    return {
      "id": id,
      "customer": customer,
      "valueDate": valueDate,
      "products": products,
    };
  }
}
