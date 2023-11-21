import 'package:flutter/material.dart';

import '../../config/const_design.dart';

class ProductTag extends StatelessWidget {
  const ProductTag(
      {Key? key, required this.productName, required this.stockCount})
      : super(key: key);
  final String productName;
  final int stockCount;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.only(
        right: 10,
        top: 1,
      ),
      decoration: const BoxDecoration(
          color: kTextPrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        padding: const EdgeInsets.only(right: 5, top: 5),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productName,
              style: const TextStyle(
                fontFamily: 'noto san lao',
                fontStyle: FontStyle.normal,
                color: kTextPrimaryColor,
                fontSize: 22,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                    15,
                  ),
                  bottomLeft: Radius.circular(
                    10,
                  ),
                ),
                color: kSecodaryColor,
              ),
              child: Text(
                "ຈຳນວນ ສຕັອກ: $stockCount",
                style: const TextStyle(
                  fontFamily: 'noto san lao',
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  // fontSize: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
