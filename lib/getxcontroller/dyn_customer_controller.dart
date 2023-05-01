import 'dart:developer';

import 'package:get/get.dart';

import '../models/dyn_customer_model.dart';

class DynCustomerController extends GetxController {
  final List<DynCustomerModel> dynCustomerModelList = [];

  void addCustomerModel(DynCustomerModel dynCustomerModel) {
    dynCustomerModelList.add(dynCustomerModel);
    update();
  }

  DynCustomerModel currentCustomerModel() {
    log("Customer len: " + dynCustomerModelList.length.toString());
    //**** dyn customer will be continue added so, always take the last one */
    // return dynCustomerModelList[dynCustomerModelList.length - 1];
    return dynCustomerModelList.last;
  }

  // void updateDiscountAmountForCurrentCustomerModel(double discount) {
  //   log("Customer len: " + dynCustomerModelList.length.toString());
  //   //**** dyn customer will be continue added so, always take the last one */
  //   // return dynCustomerModelList[dynCustomerModelList.length - 1];
  //   dynCustomerModelList.last.discount = discount;
  // }
}
