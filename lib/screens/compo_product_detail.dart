import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onestore/components/productDetail/product_image_comp.dart';
import 'package:onestore/components/productDetail/product_qty_comp.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/getxcontroller/cart_controller.dart';
import 'package:onestore/getxcontroller/outlet_controller.dart';
import 'package:onestore/getxcontroller/payment_controller.dart';
import 'package:onestore/getxcontroller/product_controller.dart';
import 'package:onestore/getxcontroller/shipping_controller.dart';
import 'package:onestore/models/dyn_customer_model.dart';
import 'package:onestore/models/payment_model.dart';
import 'package:onestore/models/product.dart';
import 'package:onestore/models/shipping_model.dart';
import 'package:onestore/widgets/cart_comp/cart_oview_comp.dart';
import '../components/date_picker_button.dart';
import '../components/productDetail/product_tag_comp.dart';

class ProductDetailComp extends StatefulWidget {
  const ProductDetailComp(
      {Key? key, required this.product, required this.pageChange})
      : super(key: key);
  final Product product;
  final Function pageChange;

  @override
  State<ProductDetailComp> createState() => _ProductDetailCompState();
}

enum ShippingFee { source, destication }

class _ProductDetailCompState extends State<ProductDetailComp> {
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cartController.addCartNoCardCar(
        widget.product,
        int.parse(orderQuantity.text),
        double.parse(discount.text),
      );
    });
  }

  @override
  void dispose() {
    cartController.clearCartItem();
    super.dispose();
  }

  void addOneState() {
    if (orderQuantity.text == "10") {
      return;
    }
    setState(() {
      orderQuantity.text =
          (1 + int.parse(orderQuantity.text.toString())).toString();
    });
    cartController.addCartNoCardCar(
      widget.product,
      int.parse(orderQuantity.text),
      double.parse(discount.text),
    );
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
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    DynCustomerModel dynCustomerModel = DynCustomerModel(
      name: customerName.text,
      tel: customerTel.text,
      shipping: shippingSelected,
      payment: paymentSelected,
      outlet: outletSelected,
      customerAddr: customerAddr.text,
      shippingFee: shippingFeePayAt,
      discount: double.parse(discount.text),
      amount: widget.product.proPrice * int.parse(orderQuantity.text),
      product: widget.product,
      riderFee: double.parse(riderFee.text),
      bookingDate: _selectedDate,
    );
    return Scaffold(
      // backgroundColor: kPrimaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: LoaderOverlay(
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: deviceSize.height * 0.3,
                      ),
                      padding: EdgeInsets.only(
                        top: deviceSize.height * 0.12,
                        left: 30,
                        right: 30,
                      ),
                      decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: deviceSize.height * 0.11,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Text("ຈຳນວນຂາຍແລ້ວ: ${widget.product.saleCount}"),
                              Card(
                                shadowColor: kTextSecondaryColor,
                                elevation: 7,
                                color: kTextPrimaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "ຈຳນວນຂາຍແລ້ວ: ${widget.product.saleCount}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ProductQtyComp(
                              product: widget.product,
                              discount: discount,
                              orderQuantity: orderQuantity,
                              addOneState: addOneState,
                              removeOneState: removeOneState,
                            ),
                          ),
                          buildDynamicCustomerForm(
                            deviceSize,
                          ),
                          SizedBox(
                            width: deviceSize.width * 0.9,
                            child: const Divider(
                              color: kLastColor,
                            ),
                          ),
                          OrderNowButton(
                            pageChange: () => {},
                            formKey: _formKey,
                            dynCustomerModel: dynCustomerModel,
                            discount: double.parse(discount.text),
                            totalPrice: widget.product.proPrice -
                                double.parse(discount.text),
                          ),
                          const Text(
                            "ລາຍລະອຽດສິນຄ້າ: ",
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                          Text(widget.product.proDesc),
                          const SizedBox(
                            width: 200,
                            child: Divider(
                              color: kLastColor,
                            ),
                          ),
                          if (widget.product.retailPrice > 0)
                            Text(
                              f.format(widget.product.proPrice),
                              style: const TextStyle(
                                  color: kLastColor,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          Text(
                            "ລາຄາສິນຄ້າ: ${f.format(widget.product.proPrice)}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductTag(
                            productName: widget.product.proName,
                            stockCount: widget.product.stock,
                          ),
                          ProductImage(imagePath: widget.product.proImagePath),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDynamicCustomerForm(
    dynamic deviceSize,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'ວັນທີ: ${dateFormat.format(_selectedDate)}',
                    style: const TextStyle(
                      fontFamily: "noto san lao",
                      color: Colors.white,
                    ),
                  ),
                ),
                DatePickerButton(
                    text: 'ເລືອກວັນທີ', showDate: _presentDatePicker),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          ConstDesign.buildTextFormFiel(customerName, "ກະລຸນາໃສ່ຊື່ລູກຄ້າ",
              "ຊື່ລູກຄ້າ", TextInputType.text, refreshData),
          const SizedBox(
            height: 4,
          ),
          ConstDesign.buildTextFormFiel(customerTel, "ກະລຸນາໃສ່ເບີໂທລູກຄ້າ",
              "ເບີໂທລູກຄ້າ", TextInputType.number, refreshData),
          const SizedBox(
            height: 4,
          ),
          ConstDesign.buildTextFormFiel(customerAddr, "ກລນ ໃສ່ບ່ອນຈັດສົ່ງ",
              "ບ່ອນຈັດສົ່ງ", TextInputType.text, refreshData),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "ຂົນສົ່ງ",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: deviceSize.width * 0.8,
            child: DropdownButtonFormField<String>(
              style: const TextStyle(
                fontFamily: "noto san lao",
                color: Colors.white,
              ),
              dropdownColor: kPrimaryColor,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 0.5,
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
              items: shippingList
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item.code,
                      child: Text(
                        '${item.code} - ${item.name}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (item) => setState(() {
                shippingSelected = item.toString();
              }),
              validator: (value) => value == null ? "ກລນ ບ່ອນຈັດສົ່ງ" : null,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "ການຊຳລະ",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: deviceSize.width * 0.8,
            child: DropdownButtonFormField<String>(
              style: const TextStyle(
                fontFamily: "noto san lao",
                color: Colors.white,
              ),
              dropdownColor: kPrimaryColor,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 0.5,
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
              items: paymentList
                  .map((item) => DropdownMenuItem<String>(
                      value: item.code,
                      child: Text(
                        '${item.code} - ${item.name}',
                        style: const TextStyle(fontSize: 12),
                      )))
                  .toList(),
              onChanged: (item) => setState(() {
                log("Payment select: " + item.toString());
                paymentSelected = item.toString();
              }),
              validator: (value) => value == null ? "ກລນ ເລືອກການຊຳລະ" : null,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "ຄ່າຝາກ: ",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: deviceSize.width * 0.8,
            child: buildShippingFee(),
          ),
          const Text(
            "ສ່ວນລົດ: ",
            style: TextStyle(color: Colors.white),
          ),
          ConstDesign.buildTextFormFiel(discount, "discount should be: 0",
              "ສ່ວນລົດ", TextInputType.number, discountRefresh),
          const SizedBox(
            height: 10,
          ),
          if (paymentSelected.contains('RIDER_COD'))
            const Text(
              "ຄ່າສົ່ງ: ",
              style: TextStyle(color: Colors.white),
            ),
          if (paymentSelected.contains('RIDER_COD'))
            ConstDesign.buildTextFormFiel(
              riderFee,
              "shipping fee should be: 0",
              "ຄ່າສົ່ງ",
              TextInputType.number,
              riderFeeRefresh,
            ),
        ],
      ),
    );
  }

  void discountRefresh(val) {
    if (val.isEmpty) {
      log("Str " + val);
      return;
    }
    log("discount " + val);
    setState(() {
      discount.text = val;
      discount.selection =
          TextSelection.collapsed(offset: discount.text.length);
    });
  }

  DateTime nextWorkingDay(int numDay) {
    DateTime today = DateTime.now();
    return today.add(Duration(days: numDay));
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: nextWorkingDay(30),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kTextPrimaryColor, // <-- SEE HERE
              // onPrimary: Colors.redAccent, // <-- SEE HERE
              // onSurface: Colors.blueAccent, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: kTextPrimaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void riderFeeRefresh(val) {
    log("rider " + val);
    if (val.isEmpty) {
      log("Str " + val);
      return;
    }
    setState(() {
      riderFee.text = val;
      riderFee.selection =
          TextSelection.collapsed(offset: riderFee.text.length);
    });
  }

  Widget buildShippingFee() {
    return Row(children: <Widget>[
      Flexible(
        child: ListTile(
          title: const Text(
            'ຕົ້ນທາງ',
            style: TextStyle(color: Colors.white),
          ),
          leading: Radio<ShippingFee>(
            activeColor: kTextPrimaryColor,
            value: ShippingFee.source,
            groupValue: shippingFeePayAt,
            onChanged: (ShippingFee? value) {
              setState(() {
                shippingFeePayAt = value;
              });
            },
          ),
        ),
      ),
      Flexible(
        child: ListTile(
          title: const Text(
            'ປາຍທາງ',
            style: TextStyle(color: Colors.white),
          ),
          leading: Radio<ShippingFee>(
            activeColor: kTextPrimaryColor,
            value: ShippingFee.destication,
            groupValue: shippingFeePayAt,
            onChanged: (ShippingFee? value) {
              setState(() {
                shippingFeePayAt = value;
              });
            },
          ),
        ),
      ),
    ]);
  }

  refreshData(val) {
    log("val " + val);
  }
}
