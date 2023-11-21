class WalletTxnModel {
  final int code;
  final String sign;
  final String txn;
  final double amount;
  final String date;
  WalletTxnModel({
    required this.code,
    required this.sign,
    required this.txn,
    required this.amount,
    required this.date,
  });
}
