import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/config/host_con.dart';
import 'package:onestore/getxcontroller/product_controller.dart';
import 'package:onestore/getxcontroller/user_info_controller.dart';
import 'package:onestore/screens/about.dart';
import 'package:onestore/screens/printer_screen.dart';
import 'package:onestore/screens/wallet_screen.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer(
      {Key? key, required this.fuctionOntap, required this.catChange})
      : super(key: key);
  final List<Function> fuctionOntap;
  final Function catChange;

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final productContr = Get.put(ProductController());
  bool productExpand = false;
  @override
  Widget build(BuildContext context) {
    final userInfoController = Get.put(UserInfoController());
    return Drawer(
      child: ListView(
        children: [
          AppBar(
            backgroundColor: kPrimaryColor,
            title: Text(userInfoController.userName),
            leading: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: hostname + userInfoController.userImage,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.asset(
                        'asset/images/profile-icon.png',
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                      ),
                      height: 160,
                      width: 160,
                      fit: BoxFit.cover,
                    ),
                    // child: Image.network(
                    //   hostname + userInfoController.userImage,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: kTextPrimaryColor,
            ),
            title: const Text(
              "ສິນຄ້າ",
              style: TextStyle(fontFamily: 'noto san lao'),
            ),
            trailing: IconButton(
                icon: Icon(
                    !productExpand ? Icons.expand_more : Icons.expand_less),
                onPressed: () {
                  setState(() {
                    productExpand = !productExpand;
                  });
                }),
            onTap: () {
              widget.fuctionOntap[0](0);
            },
          ),
          if (productExpand)
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemBuilder: (ctx, id) {
                  return GestureDetector(
                    onTap: () {
                      widget
                          .catChange(productContr.productCategory[id].catCode);
                    },
                    child: ListTile(
                      title: Text(
                        "          " + productContr.productCategory[id].catName,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
                itemCount: productContr.productCategory.length,
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 0.1,
            child: Container(
              color: kPrimaryColor,
            ),
          ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.shopping_bag_sharp,
          //     color: kPrimaryColor,
          //   ),
          //   onTap: () {
          //     widget.fuctionOntap[1](1);
          //   },
          //   title: const Text("ກະຕ່າສິນຄ້າ",
          //       style: TextStyle(fontFamily: 'noto san lao')),
          // ),
          SizedBox(
            width: double.infinity,
            height: 0.1,
            child: Container(
              color: kPrimaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.calendar_today,
              color: kTextPrimaryColor,
            ),
            onTap: () {
              widget.fuctionOntap[1](1);
            },
            title: const Text("ລາຍການສັ່ງຊື້",
                style: TextStyle(fontFamily: 'noto san lao')),
          ),
          SizedBox(
            width: double.infinity,
            height: 0.1,
            child: Container(
              color: kPrimaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.monetization_on_outlined,
              color: kTextPrimaryColor,
            ),
            onTap: () {
              widget.fuctionOntap[2](2);
            },
            title: const Text("ແຈ້ງເຕີມ-ຖອນ",
                style: TextStyle(fontFamily: 'noto san lao')),
          ),
          SizedBox(
            width: double.infinity,
            height: 0.1,
            child: Container(
              color: kPrimaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.mail,
              color: kTextPrimaryColor,
            ),
            onTap: () {
              widget.fuctionOntap[2](3);
            },
            title: const Text("ກ່ອງຂໍ້ຄວາມ",
                style: TextStyle(fontFamily: 'noto san lao')),
          ),
          SizedBox(
            width: double.infinity,
            height: 0.1,
            child: Container(
              color: kPrimaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: kTextPrimaryColor,
            ),
            onTap: () {
              log("RUNNING");
              widget.fuctionOntap[3](4);
            },
            title: const Text("ຂໍ້ມູນສ່ວນຕົວ",
                style: TextStyle(fontFamily: 'noto san lao')),
          ),
          ListTile(
            leading: const Icon(
              Icons.account_balance_wallet,
              color: kTextPrimaryColor,
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const WalletScreen()));
            },
            title: const Text("Wallet",
                style: TextStyle(fontFamily: 'noto san lao')),
          ),
          ListTile(
            leading: const Icon(
              Icons.print,
              color: kTextPrimaryColor,
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const PrinterSetting()));
            },
            title: const Text("Printer",
                style: TextStyle(fontFamily: 'noto san lao')),
          ),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: kTextPrimaryColor,
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const AboutScreen()));
            },
            title: const Text("ກ່ຽວກັບເຮົາ",
                style: TextStyle(fontFamily: 'noto san lao')),
          ),
        ],
      ),
    );
  }
}
