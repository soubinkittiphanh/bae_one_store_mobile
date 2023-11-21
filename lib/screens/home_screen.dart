import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/app.dart';
import '../widgets/menu_header.dart';
import '../widgets/menu_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  final List<String> menuList = ['A', 'B', 'C'];
  String myBarcode = '';
  Future<void> scanBarcode() async {
    // Check if camera permission is granted
    if (await Permission.camera.request().isGranted) {
      // Get the barcode result as a string
      String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', // The color of the scan button
        'Cancel', // The text of the cancel button
        true, // Whether to show the flash icon
        ScanMode.BARCODE, // The type of barcode to scan
      );

      // Do something with the barcode result
      print('Barcode result: $barcodeResult');
      setState(() {
        myBarcode = barcodeResult;
      });
    } else {
      // If camera permission is not granted, request permission
      PermissionStatus status = await Permission.camera.request();
      if (status.isGranted) {
        // If camera permission is granted after request, scan the barcode
        String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
          '#FF0000', // The color of the scan button
          'Cancel', // The text of the cancel button
          true, // Whether to show the flash icon
          ScanMode.BARCODE, // The type of barcode to scan
        );
        // Do something with the barcode result
        print('Barcode result: $barcodeResult');
      } else {
        // If camera permission is denied after request, show an error message
        print('Camera permission not granted');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ເຄື່ອງມືອຳນວຍຄວາມສະດວກ'),
        backgroundColor: kPri,
        // foregroundColor: ,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Visibility(
              visible: isLoading,
              child: SpinKitFadingCircle(
                color: kPrimaryColor,
                size: 50.0,
              ),
            )
          : Container(
              // height: double.infinity,
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MenuHeader(
                    title: "Operation",
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: menuList
                          .map((e) => MenuItem(
                                menuName: e,
                                icon: Icons.timelapse,
                                function: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (ctx) => ScheduleScreen(
                                  //       category: e,
                                  //     ),
                                  //   ),
                                  // );
                                },
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  MenuHeader(
                    title: "ເມນູ",
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        MenuItem(
                          menuName: 'ຮັບເຄື່ອງເຂົ້າສາງ',
                          icon: Icons.barcode_reader,
                          function: scanBarcode,
                        ),
                        MenuItem(
                          menuName: 'ຍອດຂາຍ',
                          icon: Icons.moving,
                          function: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (ctx) => SaleScheduleScreen(),
                            //   ),
                            // );
                          },
                        ),
                        // MenuItem(
                        //   menuName: 'ຖືກລາງວັນ',
                        //   icon: Icons.check_box_outlined,
                        //   function: () {},
                        // ),
                        // MenuItem(
                        //   menuName: 'ຕັ້ງຄ່າເຄື່ອງພິມ',
                        //   icon: Icons.bluetooth_audio_outlined,
                        //   function: () {},
                        // ),
                      ],
                    ),
                  ),
                  Text("Barcode is: ${myBarcode}"),
                ],
              ),
            ),
    );
  }
}
