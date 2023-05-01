import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:onestore/models/register_message.dart';

class FirebaseService {
  final firebaseAuth = FirebaseAuth.instance;
  Future registerWithEmailAndPassword(email, password, statusCode) async {
    try {
      if (statusCode == 404 || statusCode == 0) {
        // That mean resgister not succeed or not register yet so let register user
        log("Register =>");

        await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          log("Sent verification code");
          await user.sendEmailVerification();
        }
        final result = RegisterMessage(
            statusCode: 503,
            message:
                "Email is not verified: ກະລຸນາກົດ ລິ້ງຢືນຢັນຕົວຕົນ ໃນອີເມວຂອງທ່ານ ແລ້ວ ກົດດຳເນີນການຕໍ່");
        return result;
      } else if (statusCode == 503) {
        // User? currentUser = FirebaseAuth.instance.currentUser;
        log("=> Verify email");
        //  currentUser = firebaseAuth.currentUser;
        // Email not verify so check if email is verify ?
        final userCredentail = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        log("User Credentail: " +
            userCredentail.user!.emailVerified.toString());
        log("Email: " + userCredentail.user!.email.toString());
        // final isvalidEmail = currentUser.emailVerified;
        // log("Isvalid: " + isvalidEmail.toString());
        if (userCredentail.user!.emailVerified) {
          log("Verified email " + userCredentail.user!.email.toString());
          final result =
              RegisterMessage(statusCode: 200, message: "Eamil is verified");
          return result;
        } else {
          log("Un verified email");
          final result = RegisterMessage(
              statusCode: 503, message: "Eamil is not verified");
          // print(result.)

          return result;
        }
      }
    } catch (e) {
      final result = RegisterMessage(
        statusCode: 404,
        message: e.toString().contains("already in use")
            ? "Email ນີ້ ມີໃນລະບົບແລ້ວ ກະລຸນາໃຊ້ອີເມວອື່ນ"
            : e.toString(),
      );
      return result;
    }
  }

  // Future loginWithEmail(email, password) async {
  //   try {
  //     final userCredential = await firebaseAuth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     // ignore: unnecessary_null_comparison
  //     // firebaseAuth.verifyPasswordResetCode('code');
  //     if (userCredential.user!.uid != null) {
  //       log("Loin succeed with email: " +
  //           userCredential.user!.email.toString());
  //     } else {
  //       log("Fail loin");
  //     }
  //   } catch (e) {
  //     log("==> Login fail" + e.toString());
  //   }
  // }
}
