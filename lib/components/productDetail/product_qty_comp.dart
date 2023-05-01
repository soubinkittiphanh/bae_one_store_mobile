import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/const_design.dart';
import '../../getxcontroller/cart_controller.dart';
import '../../models/product.dart';

class ProductQtyComp extends StatelessWidget {
  const ProductQtyComp({
    Key? key,
    required this.addOneState,
    required this.removeOneState,
    required this.discount,
    required this.orderQuantity,
    required this.product,
  }) : super(key: key);
  final TextEditingController orderQuantity;
  final TextEditingController discount;
  final Product product;
  final Function addOneState;
  final Function removeOneState;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final cartController = Get.put(CartController());
    return Container(
      width: deviceSize.width * 0.7,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: kPrimaryColor,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(
                0.4,
              ),
            ),
            child: IconButton(
              color: Colors.white,
              onPressed: () {
                addOneState();
              },
              icon: const Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 60,
            child: TextField(
              controller: orderQuantity,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "noto san lao",
                color: Colors.white,
              ),
              onChanged: (val) {
                if (val.isEmpty) {
                  return;
                } else if (int.parse(val) == 0) {
                  return;
                } else if (int.parse(val) > 10) {
                  orderQuantity.text = "9";
                  return;
                }
                cartController.addCartNoCardCar(product,
                    int.parse(orderQuantity.text), double.parse(discount.text));
              },
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      width: 0.5,
                      color: kTextPrimaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      width: 0.5,
                      color: Colors.white,
                    ),
                  ),
                  labelText: 'ຈນ',
                  labelStyle: const TextStyle(color: Colors.white)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(
                0.4,
              ),
            ),
            child: IconButton(
              color: Colors.white,
              onPressed: () {
                removeOneState();
              },
              icon: const Icon(Icons.remove),
            ),
          ),
        ],
      ),
    );
  }
}
