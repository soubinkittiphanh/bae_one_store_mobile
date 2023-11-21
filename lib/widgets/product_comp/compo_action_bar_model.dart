import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestore/getxcontroller/cart_controller.dart';
import 'package:onestore/models/product.dart';

class CompoActionBarModel extends StatefulWidget {
  final Product product;
  final int qty;
  final Function addNgo;
  final double discount;
  const CompoActionBarModel({
    Key? key,
    required this.product,
    this.qty = 1,
    required this.addNgo,
    required this.discount,
  }) : super(key: key);

  @override
  State<CompoActionBarModel> createState() => _CompoActionBarModelState();
}

class _CompoActionBarModelState extends State<CompoActionBarModel> {
  final cartProvider = Get.put(CartController());
  void _addToCard() {
    ScaffoldMessenger.of(context).clearSnackBars();
    cartProvider.addCart(
      widget.product,
      widget.qty,
      widget.discount,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.down,
        backgroundColor: Colors.red,
        content: const Text(
          "ເພີ່ມໄປຍັງລາຍການແລ້ວ",
          style: TextStyle(
            fontFamily: 'noto san lao',
          ),
        ),
        action: SnackBarAction(
          label: "Cancel",
          onPressed: () {
            cartProvider.removeCart(widget.product.proId);
          },
          textColor: Colors.white,
        ),
        duration: const Duration(
          seconds: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: _addToCard,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shopping_cart),
                  Text(
                    'ເພີ່ມໄປຍັງກະຕ່າສິນຄ້າ',
                    style: TextStyle(
                      fontFamily: 'noto san lao',
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                widget.addNgo();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // Icon(Icons.shopping_cart),
                  Text(
                    'ຊື້ສິນຄ້າ',
                    style: TextStyle(
                      fontFamily: 'noto san lao',
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
