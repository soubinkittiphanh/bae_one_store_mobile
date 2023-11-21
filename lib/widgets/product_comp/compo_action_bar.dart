import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestore/getxcontroller/cart_controller.dart';
import 'package:onestore/models/product.dart';

class CompoActionBar extends StatefulWidget {
  final Product product;
  final double discount;
  const CompoActionBar({
    Key? key,
    required this.product,
    required this.discount,
  }) : super(key: key);

  @override
  State<CompoActionBar> createState() => _CompoActionBarState();
}

class _CompoActionBarState extends State<CompoActionBar> {
  final cartProvider = Get.put(CartController());
  bool _isfavourite = false;
  void _addToCard() {
    ScaffoldMessenger.of(context).clearSnackBars();
    cartProvider.addCart(widget.product, 1, widget.discount);
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 30,
          color: Colors.red.withOpacity(0.5),
          child: FittedBox(
            fit: BoxFit.fill,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _addToCard,
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isfavourite = !_isfavourite;
                    });
                  },
                  icon: Icon(
                    _isfavourite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          // child: Text('hi'),
        ),
      ),
    );
  }
}
