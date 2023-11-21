class CartItemModel {
  int proId;
  int qty;
  double priceTotal;
  double priceRetail;
  double price;
  double discountPercent;
  CartItemModel({
    required this.proId,
    required this.qty,
    required this.price,
    required this.priceTotal,
    required this.priceRetail,
    required this.discountPercent,
  });
  Map toJson() {
    return {
      "product_id": proId,
      "product_amount": qty,
      "product_price": price,
      "order_price_total": priceTotal,
      "product_price_retail": priceRetail,
      "product_discount": discountPercent,
    };
  }
}
