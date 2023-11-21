import 'dart:developer';

import 'package:get/get.dart';

import '../models/outlet_model.dart';

class OutletController extends GetxController {
  final List<OutletModel> outletModelList = [];

  OutletModel? selectedOutletModel;
  void pushOutlet(OutletModel outletModel) {
    outletModelList.add(outletModel);
    update();
    log("Outlet added" + outletModelList.length.toString());
  }

  List<OutletModel> allOutletModel() {
    return outletModelList;
  }

  OutletModel findById(String id) {
    return outletModelList.firstWhere((element) => element.code == id);
  }

  void chooseOutlet(OutletModel outletModel) {
    selectedOutletModel = outletModel;
    update();
  }

  OutletModel get currentOutlet {
    return selectedOutletModel ?? outletModelList[0];
  }

  OutletModel findOutletByCode(String code) {
    return outletModelList.firstWhere((element) => element.code == code);
  }
}
