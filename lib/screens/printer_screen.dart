import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart' as flutterblue;
import 'package:get/get.dart';
import 'package:onestore/api/alert_smart.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/getxcontroller/printer_check_constroller.dart';
import 'package:onestore/helper/printer_helper.dart';
import 'package:onestore/widgets/common/my_button.dart';
import 'package:flutter/services.dart';

class PrinterSetting extends StatefulWidget {
  static const routeName = "/printer-setting";

  const PrinterSetting({Key? key}) : super(key: key);
  @override
  _PrinterSettingState createState() => _PrinterSettingState();
}

class _PrinterSettingState extends State<PrinterSetting> {
  @override
  void initState() {
    // _initPrinterState();
    super.initState();
    // initPlatformState();

    scanBluetoothDevice();
    log("Setting state=====>");
  }

  List localPrinter = [];
  final printerConCheckContrx = Get.put(PrinterConnectionCheck());
  bool isBluetoothOn = false;
  bool isDeviceConnected = false;
  String deviceMac = '';
  String deviceName = '';
  bool isLoading = false;
  Future<void> scanBluetoothDevice() async {
    //     try {
    //    await Permission.bluetoothConnect.request();
    //  } on PlatformException catch (e) {
    //    print("Error: $e");
    //  }

    // isLoading = true;
    await printerConCheckContrx.getBluetooth();
    List<dynamic>? scanBluePrinter =
        await BluetoothThermalPrinter.getBluetooths;
    setState(() {
      localPrinter = scanBluePrinter!;
    });
    // isLoading = false;
  }

  Future<void> appSettingPopup() async {
    AppSettings.openBluetoothSettings();
  }

  Future<void> printTest() async {
    await PrintHelper.printTest(context);
    // await BluetoothThermalPrinter.writeText("Hello test");
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    bool printerConnectionCheck = printerConCheckContrx.disablePrinterCheck;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPri,
        title: const Text('ຕັ້ງຄ່າການເຊື່ອມຕໍ່ເຄື່ອງພິມ'),
      ),
      body: Container(
        // height: double.infinity,
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<PrinterConnectionCheck>(builder: (ctx) {
                return Container(
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      border: Border.all(width: 0.3),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: SwitchListTile(
                    activeColor: kPri,
                    value: printerConnectionCheck,
                    onChanged: (val) {
                      setState(() {
                        printerConnectionCheck = !printerConnectionCheck;
                        ctx.setPrinterCheckStatus(printerConnectionCheck);
                      });
                      String message = printerConnectionCheck
                          ? "ກ່ອນການສັ່ງຊື້ ແລະ ພິມ ຈະຕ້ອງເຊື່ອມຕໍ່ເຄື່ອງພິມກ່ອນ"
                          : "ສາມາດສັ່ງຊື້ໄດ້ ໂດຍບໍ່ຈຳເປັນຕໍ່ເຄື່ອງພິມ";
                      AlertSmart.infoDialog(context, message);
                      // printerConCheckContrx.setPrinterCheckStatus(val);
                    },
                    title: const Text(
                      "ປິດ-ເປີດ ການກວດປິນເຕີ ກ່ອນພິມ ແລະ ສັ່ງ",
                      style: TextStyle(
                        fontFamily: 'noto san lao',
                        // color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              const Text(
                "ຄົ້ນຫາເຄື່ອງພິມທີ່ເຄີຍເຊື່ອມຕໍ່ແລ້ວ",
                style: TextStyle(
                  fontFamily: 'noto san lao',
                  // color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyButton(
                    press: scanBluetoothDevice,
                    text: "ຄົ້ນຫາ",
                    btnColor: kPri,
                  ),
                  MyButton(
                    press: appSettingPopup,
                    text: "Bluetooth setting",
                    btnColor: kPri,
                  )
                ],
              ),
              SizedBox(
                height: deviceSize.height * 0.3,
                child: ListView.builder(
                  itemCount: printerConCheckContrx.getAvailablePrinter().length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        // _selectDevice = printerConCheckContrx.availableBluetoothDevices[index];
                        String printer =
                            printerConCheckContrx.getAvailablePrinter()[index];
                        List printerObj = printer.split("#");
                        String name = printerObj[0];
                        String mac = printerObj[1];
                        _connect(mac, name);
                      },
                      title: Text(
                          '${printerConCheckContrx.getAvailablePrinter()[index].split("#")[0]}'),
                      subtitle: const Text("Click to connect"),
                      trailing: const IconButton(
                        icon: Icon(Icons.bluetooth_connected),
                        onPressed: null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MyButton(
                press: printTest,
                text: "ທົດລອງພິມ",
                btnColor: kPri,
              ),
              MyButton(
                press: () async {
                  // await _initPrinterState();
                },
                text: "ເຊັກສະຖານະການເຊື່ອມຕໍ່",
                btnColor: kPri,
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ສະຖານະ: ${isDeviceConnected ? 'ເຊື່ອມຕໍ່ແລ້ວ' : 'ບໍ່ມີການເຊື່ອມຕໍ່'} ${localPrinter.length} | ${printerConCheckContrx.getAvailablePrinter().length}',
                      style: TextStyle(
                          fontSize: 20,
                          color: isDeviceConnected ? kPri : Colors.red),
                    ),
                    Text(
                      'ເຄື່ອງທີ່ກຳລັງເຊື່ອມຕໍ່: ${isDeviceConnected ? deviceName + ':' : ''}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'noto san lao',
                        // color: Colors.white,
                      ),
                    ),
                    Text("lOGS: ${printerConCheckContrx.getLogs()}")
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _connect(String mac, String name) async {
    await printerConCheckContrx.setConnect(mac);

    if (printerConCheckContrx.isConnect()) {
      setState(() {
        // connected = true;
        deviceName = name;
        deviceMac = mac;
        isDeviceConnected = true;
        printerConCheckContrx.setSelectDevice(mac);
      });
      // _initPrinterState();
    }
  }
}
