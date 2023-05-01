import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onestore/getxcontroller/cart_controller.dart';
import 'package:onestore/models/product.dart';

class CartItemComp extends StatelessWidget {
  final Product product;
  const CartItemComp({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cartProvider = Get.put(CartController());
    final f = NumberFormat("#,###");
    final cartItem = cartProvider.cartItemId(product.proId);

    return Card(
      key: key,
      child: Dismissible(
        key: Key(product.proId.toString()),
        background: Container(
          height: 20,
          color: Colors.red,
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {},
        child: ListTile(
          leading: CircleAvatar(
            radius: 24,
            child: CircleAvatar(
              radius: 23.5,
              child: Stack(children: [
                FittedBox(
                  child: Text(
                    "x ${cartItem.qty}",
                  ),
                ),
              ]),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.red,
          ),
          title: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ຊື່ສິນຄ້າ: ${product.proName}",
                    style: Theme.of(context).textTheme.headline6),
                Text(" ${f.format(cartItem.price)}",
                    style: Theme.of(context).textTheme.headline6),
              ],
            ),
          ),
          // subtitle: Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          // Text(
          //   "${f.format(cartItem.priceTotal)} ກີບ",
          //   style: const TextStyle(
          //     decoration: TextDecoration.underline,
          //     color: Colors.black,
          //   ),
          // ),
          // IconButton(
          //   onPressed: _addOne,
          //   icon: const Icon(Icons.add),
          // ),
          // const Text(" | "),
          // IconButton(
          //   onPressed: _removeOne,
          //   icon: const Icon(Icons.remove),
          // )
          //   ],
          // ),
          // isThreeLine: true,
          // trailing: IconButton(
          //   // color: Colors.white,
          //   icon: const Icon(
          //     Icons.delete_forever,
          //     color: Colors.red,
          //   ),
          //   onPressed: () {
          //     cartProvider.removeCart(cartItem.proId);
          //   },
          // ),
        ),
      ),
    );
  }
}
