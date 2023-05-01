class InquiryModel {
  final String bankCode;
  final String bankName;
  final String bankAcID;
  final String bankAcName;
  final int amount;
  final String reference;
  InquiryModel({
    required this.bankCode,
    this.bankName = '',
    required this.bankAcID,
    required this.bankAcName,
    this.amount = 0,
    this.reference = '',
  });
}
