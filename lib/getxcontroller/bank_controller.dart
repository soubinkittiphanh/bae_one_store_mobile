import 'dart:developer';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:onestore/models/bank_model.dart';

class BankController extends GetxController {
  List<BankComp> bank = [];
  void setBank(dynamic listOfbank) {
    bank = listOfbank;
    update();
  }

  List<BankComp> get getBank {
    return [...bank];
  }
}
