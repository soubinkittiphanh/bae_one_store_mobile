import '../screens/product_detail_screen.dart';
import '../widgets/common/common.dart';

class OrderItemModel {
  final String orderId;
  final int userId;
  final int prodId;
  final double price;
  final double total;
  final String proName;
  final String customerName;
  final String customerTel;
  final String customerShipping;
  final String customerPayment;
  final String customerOutlet;
  final String customerAddr;
  final ShippingFee customerShippingFee;
  final double customerDiscount;
  final double customerProductQty;
  final double customerRiderFee;
  final DateTime customerBookingDate;
  final String orderStatus;
  final String orderCancelReason;
  OrderItemModel(
    this.orderId,
    this.userId,
    this.prodId,
    this.price,
    this.total,
    this.proName,
    this.customerName,
    this.customerAddr,
    this.customerBookingDate,
    this.customerDiscount,
    this.customerOutlet,
    this.customerPayment,
    this.customerProductQty,
    this.customerRiderFee,
    this.customerShipping,
    this.customerShippingFee,
    this.customerTel,
    this.orderStatus,
    this.orderCancelReason,
  );
  OrderItemModel.fromJson(Map<String, dynamic> json)
      : orderId = "${json['order_id']}",
        userId = json['user_id'],
        prodId = json['product_id'],
        price = double.parse(json['product_price'].toString()),
        total = double.parse(json['order_price_total'].toString()),
        proName = json['pro_name'],
        customerDiscount = double.parse(json['discount'].toString()),
        customerName = json['name'] ?? '',
        customerAddr = json['dest_delivery_branch'],
        customerBookingDate = CommonUtil.formatDate(json['txn_date']),
        customerOutlet = "${json['outlet']}",
        customerPayment = json['payment_code'],
        customerProductQty = double.parse(json['product_amount'].toString()),
        customerRiderFee = double.parse(json['rider_fee'].toString()),
        customerShipping = json['source_delivery_branch'],
        customerShippingFee =
            json['shipping_fee_by'].toString().contains("dest")
                ? ShippingFee.destication
                : ShippingFee.source,
        customerTel = json['tel'],
        orderStatus = json['record_status'].toString(),
        orderCancelReason = json['cancel_reason'] ?? '';
}
