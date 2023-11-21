import 'dart:developer';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:onestore/models/order_item_model.dart';

class OrderController extends GetxController {
  final f = NumberFormat("#,###");
  List<OrderItemModel> _orderItem = [];
  String currentOrderItemId = '';
  List<OrderItemModel> get orderItem {
    return [..._orderItem];
  }

  List<OrderItemModel> orderItemId(id) {
    var groupOfOrder = _orderItem.where((element) => element.orderId == id);
    return [...groupOfOrder];
  }

  void setCurrentOrderItemId(String orderItemId) {
    currentOrderItemId = orderItemId;
    update();
  }

  String orderTotalPriceById(id) {
    double total = 0;
    double discount = 0;
    for (var el in orderItemId(id)) {
      total += el.total;
      if (el.customerDiscount > 0) {
        discount = el.customerDiscount;
      }
    }
    // return total.toString();
    return f.format(total - discount);
  }

  String orderTotalPriceByIdOringinal(id) {
    double total = 0;
    for (var el in orderItemId(id)) {
      total += ((100 * el.total) / (100 - el.customerDiscount));
    }
    // return total.toString();
    return f.format(total);
  }

  String orderProfit(id) {
    double totalDiscPrice = 0;
    for (var el in orderItemId(id)) {
      totalDiscPrice += el.total;
    }
    double totalOriginalPrice = 0;
    for (var el in orderItemId(id)) {
      totalOriginalPrice += ((100 * el.total) / (100 - el.customerDiscount));
    }
    return f.format(totalOriginalPrice - totalDiscPrice);
  }

  double get orderTotalPrice {
    double total = 0;
    for (var el in _orderItem) {
      total += el.total;
    }
    return total;
  }

  List<OrderItemModel> get orderItemNotDuplicate {
    List<OrderItemModel> _orderItemNotDuplicate = [];
    for (var element in _orderItem) {
      if (_orderItemNotDuplicate
              .indexWhere((el) => el.orderId == element.orderId) >=
          0) {
        // log("remove");
        log(_orderItemNotDuplicate
            .indexWhere((el) => el.orderId == element.orderId)
            .toString());
      } else {
        // log("add");
        _orderItemNotDuplicate.add(element);
      }
    }
    // log("not duplicate: " + _orderItemNotDuplicate.length.toString());
    return [..._orderItemNotDuplicate];
  }

  List<double> grandProfitItem() {
    // List<Order> allOrder = _orderItem;
    double grandDiscountPrice = 0;
    double grandOriginalPrice = 0;
    double profit = 0;
    for (var element in _orderItem) {
      grandDiscountPrice += element.total;
      grandOriginalPrice +=
          (element.total / (100 - element.customerDiscount)) * 100;
      // orderCount++;
    }
    profit = grandOriginalPrice - grandDiscountPrice;
    List<double> allFinancialReport = [
      grandOriginalPrice,
      grandDiscountPrice,
      profit,
    ];
    return allFinancialReport;
  }

  void setOrderItem(List<OrderItemModel> order) {
    _orderItem = [...order];
    update();
  }
}
