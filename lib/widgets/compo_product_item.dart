import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/models/product.dart';

class CompProductItem extends StatelessWidget {
  final String proName;
  final Product pro;
  // final double discount;
  const CompProductItem({
    Key? key,
    required this.proName,
    required this.pro,
    // required this.discount,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final f = NumberFormat("#,###");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(children: [
            Container(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: pro.proImagePath.contains("No image")
                        ? const Text("No image")
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: CachedNetworkImage(
                              fit: BoxFit.scaleDown,
                              height: 180,
                              width: 200,
                              imageUrl: pro.proImagePath,
                              placeholder: (context, url) =>
                                  const SpinKitFadingCircle(
                                color: kPrimaryColor,
                                size: 50.0,
                              ),
                              errorWidget: (context, url, error) {
                                log("IMAGE ER: " + error.toString());
                                return const Icon(Icons.error);
                              },
                            ),
                          ),
                  ),
                  const Spacer(),
                  Text(
                    " ${pro.proName} ",
                    // style: const TextStyle(col),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          " ${pro.stock}",
                          style: const TextStyle(
                              color: kPri, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${f.format(pro.proPrice - (pro.proPrice * pro.retailPrice / 100))} ₭',
                          style: const TextStyle(
                              color: kPri, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  // border: Border.all(
                  //   width: 1,
                  //   // color: ,
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.1,
                      blurRadius: 0.5,
                      offset: Offset(0, 3), // changes
                    )
                  ]),
            ),
          ]),
        ),
      ],
    );
  }
}
