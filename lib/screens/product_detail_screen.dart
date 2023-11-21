import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/config/host_con.dart';
import 'package:onestore/getxcontroller/cart_controller.dart';
import 'package:onestore/getxcontroller/outlet_controller.dart';
import 'package:onestore/getxcontroller/payment_controller.dart';
import 'package:onestore/getxcontroller/product_controller.dart';
import 'package:onestore/getxcontroller/shipping_controller.dart';
import 'package:onestore/models/dyn_customer_model.dart';
import 'package:onestore/models/payment_model.dart';
import 'package:onestore/models/product.dart';
import 'package:onestore/models/shipping_model.dart';
import 'package:onestore/screens/cart_screen.dart';
import '../components/color_dot.dart';
import '../components/date_picker_button.dart';
import '../config/constant.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen(
      {Key? key, required this.product, required this.pageChange})
      : super(key: key);
  final Product product;
  final Function pageChange;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

enum ShippingFee { source, destication }

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final cartController = Get.put(CartController());
  final productContr = Get.put(ProductController());
  final shippingCtr = Get.put(ShippingController());
  final paymentCtr = Get.put(PaymentController());
  final outletCtr = Get.put(OutletController());
  final orderQuantity = TextEditingController();
  final f = NumberFormat("#,###");
  final _formKey = GlobalKey<FormState>();
  ShippingFee? shippingFeePayAt = ShippingFee.destication;
  final dateFormat = DateFormat('dd-MM-yyyy');
  // int orderQuantity = 1;
  @override
  void initState() {
    super.initState();
    orderQuantity.text = "1";
    discount.text = "0";
    riderFee.text = '0';
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   cartController.addCartNoCardCar(
    //     widget.product,
    //     int.parse(orderQuantity.text),
    //     double.parse(discount.text),
    //   );
    // });
  }

  @override
  void dispose() {
    // cartController.clearCartItem();
    super.dispose();
  }

  void addToCart() {
    cartController.addCart(
      widget.product,
      1,
      0,
    );
    setState(() {});
    log("Cart count now: ${cartController.cartCount}");
  }

  void removeOneState() {
    if (int.parse(orderQuantity.text) == 0) return;
    if (int.parse(orderQuantity.text) == 1) {
      return;
    }
    cartController.removeOneCart(widget.product);
    setState(() {
      orderQuantity.text = (int.parse(orderQuantity.text) - 1).toString();
    });
  }

  final customerName = TextEditingController();
  final customerTel = TextEditingController();
  final shopName = TextEditingController();
  final customerAddr = TextEditingController();
  final discount = TextEditingController();
  final riderFee = TextEditingController();

  late final List<ShippingModel> shippingList = shippingCtr.allShipping();
  late final List<PaymentModel> paymentList = paymentCtr.allPayment();
  // late final List<OutletModel> outletList = outletCtr.allOutletModel();
  late String paymentSelected = paymentList[0].code;
  late String outletSelected = outletCtr.currentOutlet.code;
  late String shippingSelected = shippingList[0].code;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kLastColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: () {
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (ctx) => const CartScreen()));
            },
            child: Column(
              children: [
                CircleAvatar(
                  maxRadius: 10,
                  backgroundColor: kTextPrimaryColor,
                  child: Text(
                    cartController.cartCount.toString(),
                    style: const TextStyle(color: kTextSecondaryColor),
                  ),
                ),
                const Icon(
                  Icons.shopping_cart_outlined,
                  // size: 35,
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: widget.product.proImagePath.contains("No image")
                ? const Text('No image')
                : Hero(
                    tag: widget.product.proImagePath,
                    child: CachedNetworkImage(
                      imageUrl: widget.product.proImagePath,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: deviceSize.height * 0.4,
                    ),
                  ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(defaultPadding,
                  defaultPadding * 2, defaultPadding, defaultPadding),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(defaultBorderRadius * 3),
                  topRight: Radius.circular(defaultBorderRadius * 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.proName,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      const SizedBox(width: defaultPadding),
                      Text(
                        "₭" + numFormater.format(widget.product.proPrice),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Text(
                      widget.product.proDesc,
                    ),
                  ),
                  Text(
                    "Colors",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Row(
                    children: const [
                      ColorDot(
                        color: Color(0xFFBEE8EA),
                        isActive: false,
                      ),
                      ColorDot(
                        color: Color(0xFF141B4A),
                        isActive: true,
                      ),
                      ColorDot(
                        color: Color(0xFFF4E5C3),
                        isActive: false,
                      ),
                    ],
                  ),
                  const Spacer(),
                  // const SizedBox(height: defaultPadding * 2),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          addToCart();
                          final snackBar = SnackBar(
                            backgroundColor: kPrimaryColor,
                            duration: const Duration(milliseconds: 835),
                            content: const Text('Yay! A SnackBar!'),
                            action: SnackBarAction(
                              label: 'Close',
                              textColor: Colors.white,
                              onPressed: () {
                                ScaffoldMessenger.of(context).clearSnackBars();
                              },
                            ),
                          );

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: kPrimaryColor,
                            shape: const StadiumBorder()),
                        child: const Text("Add to Cart"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
