import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestore/getxcontroller/cart_controller.dart';
import 'package:onestore/models/product.dart';
import 'package:onestore/widgets/category.dart';
import 'package:onestore/widgets/compo_product_item.dart';
import 'package:onestore/screens/product_detail_screen.dart';

class ProductOverviewScreen extends StatefulWidget {
  final List<Product> demoProducts;
  const ProductOverviewScreen(
      {Key? key,
      required this.demoProducts,
      required this.pageChange,
      required this.catChange})
      : super(key: key);
  final Function pageChange;
  final Function catChange;
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverviewScreen> {
  final cartController = Get.put(CartController());
  @override
  void initState() {
    super.initState();
    // Timer.run(() {
    //   log("ad: " + Ad.isActive.toString());
    //   if (Ad.isactive == 1) {
    //     Ad.disableAd();
    //     showDialog(
    //       context: context,
    //       builder: (_) => Ad.showInfoDialogIos(
    //         context,
    //       ),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Category(catChange: widget.catChange),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                childAspectRatio: 3 / 5,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: widget.demoProducts.length,
              itemBuilder: (context, idx) => GestureDetector(
                onTap: () {
                  cartController.addCart(widget.demoProducts[idx], 1, 0);
                  widget.pageChange(2);
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (ctx) =>
                  //      ProductDetailScreen(
                  //         product: widget.demoProducts[idx],
                  //         pageChange: widget.pageChange),
                  //   ),
                  // );
                },
                child: CompProductItem(
                  proName: widget.demoProducts[idx].proName,
                  pro: widget.demoProducts[idx],
                  // discount: ,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}