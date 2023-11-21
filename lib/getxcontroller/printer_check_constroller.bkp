import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PrinterConnectionCheck extends GetxController {
  bool disablePrinterCheck = true;
  late BluetoothDevice selectedDevice;
  void setPrinterCheckStatus(bool status) {
    disablePrinterCheck = status;
    update();
  }

  bool isPrinterCheckEnable() {
    return disablePrinterCheck;
  }

  setSelectedDevice(BluetoothDevice selDevice) {
    selectedDevice = selDevice;
  }
}
