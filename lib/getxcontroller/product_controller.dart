import 'dart:developer';

import 'package:get/get.dart';
import 'package:onestore/getxcontroller/outlet_controller.dart';
import 'package:onestore/models/product.dart';
import 'package:onestore/models/product_category.dart';

class ProductController extends GetxController {
  final outletCtr = Get.put(OutletController());
  List<Product> _product = [];
  List<ProductCatetory> _productCategory = [];
  // var counterNum = 0.obs;
  void addProduct(List<Product> loadData) {
    _product = [...loadData];
    update();
  }

  void addProductCategory(List<ProductCatetory> loadData) {
    _productCategory = [...loadData];
    update();
  }

  List<Product> get product {
    log("Selected outlet " + outletCtr.currentOutlet.code);
    List<Product> productByOutlet = _product
        .where(
          (element) => element.outlet == outletCtr.currentOutlet.code,
        )
        .toList();
    if (productByOutlet.isEmpty) {
      return _product;
    }
    return productByOutlet;
  }

  List<ProductCatetory> get productCategory {
    return [..._productCategory];
  }

  Product productId(int id) {
    Product product = _product.firstWhere(
      (el) => el.proId == id,
      orElse: () {
        throw StateError("Product not found");
      },
    );
    return product;
  }
}
