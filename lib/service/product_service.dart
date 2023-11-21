import 'dart:developer';

import 'package:onestore/config/host_con.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:onestore/getxcontroller/product_controller.dart';
import 'package:onestore/models/product.dart';
import 'package:get/get.dart';
import 'package:onestore/models/product_category.dart';

class ProductService {
  final productContr = Get.put(ProductController());
  List<Product> _loadProduct = [];
  List<ProductCatetory> _loadCategory = [];
  Future<void> loadProduct() async {
    var url = Uri.parse(hostname + 'product_mobile_f');

    // Await the http get response, then decode the json-formatted response.
    log("======> Loading product... " + DateTime.now().toString());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as List;
      log("======> Loading product... completed " + DateTime.now().toString());
      _loadProduct = jsonResponse.map((el) {
        //Check if image is null then so app not crash
        String imageName = el["img_name"].toString();
        var imagePath = hostname + 'uploads/${el["img_name"]}';
        if (imageName.contains('No image')) {
          imagePath = 'No image';
        }
        return Product(
          proId: el['pro_id'],
          proCatID: el['pro_category'].toString(),
          categName: el["categ_name"],
          proName: el["pro_name"],
          proPrice: (el["pro_price"]).toDouble(),
          proDesc: el["pro_desc"],
          proStatus: el["pro_status"],
          proImagePath: imagePath,
          proCategory: el["categ_name"],
          stock: el["card_count"],
          saleCount: el["sale_count"],
          retailPrice: el["retail_cost_percent"].toDouble(),
          outlet: el["outlet"].toString(),
        );
      }).toList();
      productContr.addProduct(_loadProduct);
    } else {
      log('Request failed with status: ${response.statusCode}.');
    }
    // return _loadProduct;
  }

  // List<Product> _loadProductCategory = [];
  Future<void> loadProductCategory() async {
    var url = Uri.parse(hostname + 'category_f');

    // Await the http get response, then decode the json-formatted response.
    log("Loading...");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as List;

      _loadCategory = jsonResponse.map((el) {
        return ProductCatetory(
          catCode: el['categ_id'].toString(),
          catName: el["categ_name"],
          catDesc: el["categ_desc"],
        );
      }).toList();

      _loadCategory.insert(
          0,
          ProductCatetory(
            catCode: 'all',
            catName: "ທັງຫມົດ",
            catDesc: "ທັງຫົມດ",
          ));
      log(jsonResponse.toString());
      productContr.addProductCategory(_loadCategory);
    } else {
      log('Request failed with status: ${response.statusCode}.');
    }
    // return _loadProduct;
  }
}
