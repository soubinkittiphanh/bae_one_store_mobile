import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onestore/getxcontroller/wallet_txn_controller.dart';
import 'package:onestore/widgets/wallet/topup_comp.dart';
import 'package:onestore/widgets/wallet/withdraw_comp.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final f = NumberFormat("#,###.##");
  final walletTxnController = Get.put(WalletTxnController());
  int _selectedPage = 0;
  String maskNumber(double price) {
    String maskNum = "";
    for (var i = 0; i < price.toString().length; i++) {
      maskNum += "";
    }
    return maskNum;
  }

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController(
      initialPage: _selectedPage,
    );
    void _pageChange(int v) {
      log("INPUT " + v.toString());
      setState(() {
        _selectedPage = v;
      });
    }

    void _bottomBarChange(idx) {
      setState(() {
        _pageController.animateToPage(idx,
            duration: const Duration(milliseconds: 200), curve: Curves.ease);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
      ),
      body: Center(
        // padding: EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              child: Column(
                children: [
                  const Icon(Icons.account_balance_wallet_rounded),
                  const Text("ຍອດເຫລືອ"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Balance: "),
                      Text(
                          f.format(walletTxnController.totalCR -
                              walletTxnController.totalDR),
                          style: const TextStyle(color: Colors.green))
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            GestureDetector(
              onTap: () {
                _bottomBarChange(0);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.arrow_forward, color: Colors.green),
                          Icon(Icons.account_balance_wallet_outlined),
                        ],
                      ),
                      const Text("ເຕີມ"),
                      const Text(
                        "****.00",
                        style: TextStyle(color: Colors.green),
                      ),
                      // Text(
                      //   f.format(
                      //     walletTxnController.totalCR,
                      //   ),
                      //   style: const TextStyle(color: Colors.green),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    // width: 2,
                    height: 40,
                    child: VerticalDivider(
                      thickness: 1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _bottomBarChange(1);
                    },
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.arrow_back, color: Colors.red),
                            Icon(Icons.account_balance_wallet_outlined),
                          ],
                        ),
                        const Text("ຖອນ / ຊື້"),
                        const Text(
                          "****.00",
                          style: TextStyle(color: Colors.red),
                        ),
                        // Text(
                        //   f.format(walletTxnController.totalDR),
                        //   style: const TextStyle(color: Colors.red),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _pageChange,
                children: const [
                  TopupComp(),
                  WithdrawComp(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
