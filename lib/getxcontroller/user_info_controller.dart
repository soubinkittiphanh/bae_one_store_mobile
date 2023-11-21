import 'dart:developer';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:onestore/models/user_info.dart';

class UserInfoController extends GetxController {
  var userCredentail = UserInfo(
    userName: "",
    token: "",
    userId: "",
    phone: "",
    email: "",
    debit: 0.00,
    credit: 0.00,
    profileImage: '',
  );
  void setUserInfo(String user, String token, String id, String phone,
      String email, double debit, double credit, String profileImage) {
    userCredentail = UserInfo(
      userName: user,
      token: token,
      userId: id,
      phone: phone,
      email: email,
      debit: debit,
      credit: credit,
      profileImage: profileImage,
    );
    log("Done user info");
    update();
  }

  String get userName {
    return userCredentail.userName;
  }

  String get userId {
    return userCredentail.userId;
  }

  String get userToken {
    return userCredentail.token;
  }

  String get userPhone {
    return userCredentail.phone;
  }

  String get userEmail {
    return userCredentail.email;
  }

  double get userCredit {
    return userCredentail.credit;
  }

  double get userDebit {
    return userCredentail.debit;
  }

  String get userImage {
    return userCredentail.profileImage;
  }

  void setUserBalance(dynamic bal) {
    log("updateing");
    log("bal credit" + bal[0].toString());
    log("bal debit" + bal[1].toString());
    userCredentail = UserInfo(
      userName: userCredentail.userName,
      token: userCredentail.token,
      userId: userCredentail.userId,
      phone: userCredentail.phone,
      email: userCredentail.email,
      credit: double.parse(bal[0].toString()),
      debit: double.parse(bal[1].toString()),
      profileImage: userCredentail.profileImage,
    );
    log("update completed");
    update();
  }
}
