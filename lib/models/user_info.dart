class UserInfo {
  final String userName;
  final String token;
  final double balance;
  final String userId;
  final String phone;
  final String email;
  final double debit;
  final double credit;
  final String profileImage;
  UserInfo({
    required this.userName,
    required this.token,
    this.balance = 0.0,
    required this.userId,
    required this.phone,
    required this.email,
    required this.debit,
    required this.credit,
    required this.profileImage,
  });
}
