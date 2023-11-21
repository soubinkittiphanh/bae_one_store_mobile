import 'package:flutter/material.dart';
import 'package:onestore/config/const_design.dart';
import '../../models/product.dart';

class ProductQtyComp extends StatelessWidget {
  const ProductQtyComp({
    Key? key,
    required this.addOneState,
    required this.removeOneState,
    // required this.discount,
    // required this.orderQuantity,
    required this.product,
  }) : super(key: key);
  // final TextEditingController orderQuantity;
  // final TextEditingController discount;
  final Product product;
  final Function addOneState;
  final Function removeOneState;
  @override
  Widget build(BuildContext context) {
    // final cartController = Get.put(CartController());
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(
              0.4,
            ),
          ),
          child: IconButton(
            color: kPri,
            onPressed: () {
              addOneState(product);
            },
            icon: const Icon(Icons.add),
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        // SizedBox(
        //   width: 60,
        //   child: TextField(
        //     controller: orderQuantity,
        //     keyboardType: TextInputType.number,
        //     textAlign: TextAlign.center,
        //     style: const TextStyle(
        //       fontFamily: "noto san lao",
        //       color: Colors.white,
        //     ),
        //     onChanged: (val) {
        //       if (val.isEmpty) {
        //         return;
        //       } else if (int.parse(val) == 0) {
        //         return;
        //       } else if (int.parse(val) > 10) {
        //         orderQuantity.text = "9";
        //         return;
        //       }
        //       cartController.addCartNoCardCar(
        //           product, int.parse(orderQuantity.text), 0);
        //     },
        //     decoration: InputDecoration(
        //         focusedBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(12),
        //           borderSide: const BorderSide(
        //             width: 0.5,
        //             color: kTextPrimaryColor,
        //           ),
        //         ),
        //         enabledBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(12),
        //           borderSide: const BorderSide(
        //             width: 0.5,
        //             color: Colors.white,
        //           ),
        //         ),
        //         labelText: 'ຈນ',
        //         labelStyle: const TextStyle(color: Colors.white)),
        //   ),
        // ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(
              0.4,
            ),
          ),
          child: IconButton(
            color: kPri,
            onPressed: () {
              removeOneState(product);
            },
            icon: const Icon(Icons.remove),
          ),
        ),
      ],
    );
  }
}
