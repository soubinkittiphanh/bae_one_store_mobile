import 'package:get/get.dart';
import 'package:onestore/getxcontroller/order_controller.dart';
import 'package:onestore/helper/order_helper.dart';

class OrderService {
  static final orderController = Get.put(OrderController());

  static loadOrder(userId) async {
    // OrderHelper.fetchOrder(userId);
    DateTime _selectedDateFrom = DateTime.now();
    DateTime _selectedDateTo = DateTime.now();
    orderController.setOrderItem(
      await OrderHelper.fetchOrder(
        _selectedDateFrom,
        _selectedDateTo,
      ),
    );
  }
}
