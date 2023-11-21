import 'dart:developer';

import 'package:get/get.dart';

import '../models/payment_model.dart';

class PaymentController extends GetxController {
  final List<PaymentModel> paymentList = [];

  void pushPayment(PaymentModel paymentModel) {
    log("Pushing payment");
    paymentList.add(paymentModel);
    update();
    log("Total payment " + paymentList.length.toString());
  }

  List<PaymentModel> allPayment() {
    return paymentList;
  }
}
