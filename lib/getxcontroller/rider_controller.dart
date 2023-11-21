import 'dart:developer';

import 'package:get/get.dart';
import 'package:onestore/models/rider_model.dart';

class RiderController extends GetxController {
  final List<RiderModel> allRider = [];
  addRider(RiderModel rider) {
    allRider.add(rider);
    log("Add to rider ${rider.name}");
    update();
  }

  List<RiderModel> get findAll {
    return allRider;
  }

  RiderModel findById(int id) {
    return allRider.firstWhere(
      (element) => element.id == id,
    );
  }
}
