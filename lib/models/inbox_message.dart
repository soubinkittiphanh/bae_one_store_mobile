class InboxMessage {
  final String orderId;
  final String messageBody;
  final String date;
  final double price;
  final String qrCode;
  final String category;
  final String sellerName;
  bool isRead;
  InboxMessage({
    required this.orderId,
    required this.messageBody,
    required this.date,
    this.price = 0.0,
    this.isRead = true,
    required this.qrCode,
    required this.category,
    required this.sellerName,
    //= "00000",
  });
}
