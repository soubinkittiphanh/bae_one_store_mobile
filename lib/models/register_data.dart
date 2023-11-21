class RegisterData {
  final String custName;
  final String custTel;
  final String custEmail;
  final String custPassword;
  final String custGameId;
  final String custVillage;
  final String custDistrict;
  final String custProvince;
  RegisterData({
    required this.custName,
    this.custEmail = '',
    this.custGameId = '',
    required this.custPassword,
    this.custTel = '',
    this.custVillage = '',
    this.custDistrict = '',
    this.custProvince = '',
  });
}
