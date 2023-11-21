import 'dart:developer';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';

class PrinterConnectionCheck extends GetxController {
  bool disablePrinterCheck = true;
  bool connected = false;
  List availableBluetoothDevices = [];
  String selectedDeviceMac = '';
  String printLogs = '';
  void setPrinterCheckStatus(bool status) {
    disablePrinterCheck = status;
    update();
  }

  bool isPrinterCheckEnable() {
    return disablePrinterCheck;
  }

  void setSelectDevice(String mac) {
    selectedDeviceMac = mac;
    update();
  }

  Future<void> getBluetooth() async {
    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    log("Print $bluetooths");

    availableBluetoothDevices = bluetooths!;
    update();
  }

  List getAvailablePrinter() {
    return availableBluetoothDevices;
  }

  Future<void> setConnect(String mac) async {
    final String? result = await BluetoothThermalPrinter.connect(mac);
    log("state conneected $result");
    if (result == "true") {
      connected = true;
      genlogs("Connect printer = true");
      update();
    } else {
      genlogs("Connect printer = false");
      update();
    }
  }

  bool isConnect() {
    return connected;
  }

  void genlogs(String newLogs) {
    printLogs += newLogs + "|";
    update();
  }

  String getLogs() {
    return printLogs;
  }
}
