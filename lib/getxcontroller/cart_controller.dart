import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart';
import 'package:onestore/getxcontroller/product_controller.dart';
import 'package:onestore/models/cart_item_model.dart';
import 'package:onestore/models/product.dart';

class CartController extends GetxController {
  final List<CartItemModel> _cartItem = [];
  final productController = Get.put(ProductController());
  void addCartNoCardCar(Product pro, int qty, double discount) {
    _cartItem.length = 0;
    if (_cartItem.isEmpty) {
      _cartItem.add(CartItemModel(
        proId: pro.proId,
        qty: qty,
        price: pro.proPrice,
        priceTotal: pro.proPrice * qty,
        priceRetail: pro.proPrice,
        discountPercent: discount,
      ));
      update();
      log("Empty");
    } else {
      log("product id: " + pro.proId.toString());
      CartItemModel existProduct = _cartItem.firstWhere(
        (element) => element.proId == pro.proId,
        orElse: () => CartItemModel(
          proId: 0,
          qty: 0,
          price: 0.00,
          priceTotal: 0.00,
          priceRetail: 0.00,
          discountPercent: 0.00,
        ),
      );
      log("exist product id: " + existProduct.proId.toString());
      if (existProduct.proId <= 0) {
        //there is not exist product in the cart
        _cartItem.add(
          CartItemModel(
            proId: pro.proId,
            qty: qty,
            price: pro.proPrice,
            priceTotal: pro.proPrice * qty,
            priceRetail: pro.proPrice,
            discountPercent: pro.retailPrice,
          ),
        );
        update();
        log("Not empty and not exist");
      } else {
        CartItemModel updateProduct = CartItemModel(
          proId: pro.proId,
          qty: existProduct.qty + qty,
          price: existProduct.price,
          priceTotal: existProduct.price * (existProduct.qty + qty),
          priceRetail: existProduct.priceRetail,
          discountPercent: existProduct.discountPercent,
        );
        // _cartItem
        // .removeWhere((element) => element.proId == updateProduct.proId);
        final exist = _cartItem
            .indexWhere((element) => element.proId == updateProduct.proId);
        _cartItem[exist].qty = updateProduct.qty;
        _cartItem[exist].price = updateProduct.price;
        _cartItem[exist].priceTotal = updateProduct.priceTotal;
        _cartItem[exist].priceRetail = updateProduct.priceRetail;
        _cartItem[exist].discountPercent = updateProduct.discountPercent;
        // _cartItem.add(updateProduct);

        update();
        log("Not empty and exist");
      }
    }
    log("Add...");
  }

  void addCart(Product pro, int qty, double discount) {
    if (_cartItem.isEmpty) {
      _cartItem.add(CartItemModel(
        proId: pro.proId,
        qty: qty,
        price: pro.proPrice,
        priceTotal: pro.proPrice * qty,
        priceRetail: pro.proPrice,
        discountPercent: discount,
      ));
      update();
    } else {
      CartItemModel existProduct = _cartItem.firstWhere(
        (element) => element.proId == pro.proId,
        orElse: () => CartItemModel(
          proId: 0,
          qty: 0,
          price: 0.00,
          priceTotal: 0.00,
          priceRetail: 0.00,
          discountPercent: 0.00,
        ),
      );
      if (existProduct.proId <= 0) {
        //there is not exist product in the cart
        _cartItem.add(
          CartItemModel(
            proId: pro.proId,
            qty: qty,
            price: pro.proPrice,
            priceTotal: pro.proPrice * qty,
            priceRetail: pro.proPrice,
            discountPercent: discount,
          ),
        );
        update();
        log("Not empty and not exist");
      } else {
        CartItemModel updateProduct = CartItemModel(
          proId: pro.proId,
          qty: existProduct.qty + qty,
          price: existProduct.price,
          priceTotal: existProduct.price * (existProduct.qty + qty),
          priceRetail: existProduct.priceRetail,
          discountPercent: existProduct.discountPercent,
        );
        // _cartItem
        // .removeWhere((element) => element.proId == updateProduct.proId);
        final exist = _cartItem
            .indexWhere((element) => element.proId == updateProduct.proId);
        _cartItem[exist].qty = updateProduct.qty;
        _cartItem[exist].price = updateProduct.price;
        _cartItem[exist].priceTotal = updateProduct.priceTotal;
        _cartItem[exist].priceRetail = updateProduct.priceRetail;
        _cartItem[exist].discountPercent = updateProduct.discountPercent;
        // _cartItem.add(updateProduct);

        update();
        log("Not empty and exist");
      }
    }
    update();
    log("Cart count: " + cartItem.length.toString());
  }

  void removeOneCart(Product pro) {
    CartItemModel existProduct = _cartItem.firstWhere(
      (element) => element.proId == pro.proId,
      orElse: () => CartItemModel(
        proId: 0,
        qty: 0,
        price: 0.00,
        priceTotal: 0.00,
        priceRetail: 0.00,
        discountPercent: 0.00,
      ),
    );

    if (existProduct.qty == 1) {
      return;
      // removeCart(pro.proId);
    }

    CartItemModel updateProduct = CartItemModel(
      proId: pro.proId,
      qty: existProduct.qty - 1,
      price: existProduct.price,
      priceTotal: existProduct.price * (existProduct.qty - 1),
      priceRetail: existProduct.priceRetail,
      discountPercent: existProduct.discountPercent,
    );
    int itemIndex = _cartItem.indexOf(existProduct);
    _cartItem.removeWhere((element) => element.proId == updateProduct.proId);
    // _cartItem.add(updateProduct);
    _cartItem.insert(itemIndex, updateProduct);
    update();
    log("Not empty and exist");
  }

  void removeCart(int id) {
    _cartItem.removeWhere((element) => element.proId == id);
    log("remove... ");
    update();
  }

  void clearCartItem() {
    _cartItem.length = 0;
    _cartItem.clear();
    update();
  }

  List<CartItemModel> get cartItem {
    return [..._cartItem];
  }

  CartItemModel cartItemId(id) {
    return _cartItem.firstWhere((element) => element.proId == id);
  }

  int get cartCount {
    return _cartItem.length;
  }

  double get cartCost {
    double total = 0;
    double totalDiscount = 0;
    for (var element in _cartItem) {
      total += element.priceTotal;
      totalDiscount += element.discountPercent;
    }
    return total - totalDiscount;
  }

  List<Product> get allProduct {
    List<Product> temp = [];
    for (var element in _cartItem) {
      Product product = productController.productId(element.proId);
      temp.add(product);
    }
    return temp;
  }
}
