import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/getxcontroller/cart_controller.dart';
import 'package:onestore/getxcontroller/rider_controller.dart';
import 'package:onestore/models/geography_model.dart';
import 'package:onestore/models/rider_model.dart';
import 'package:onestore/screens/printer_screen.dart';
import 'package:onestore/service/common_service.dart';
import 'package:onestore/widgets/common/my_button.dart';

import '../api/alert_smart.dart';
import '../components/date_picker_button.dart';
import '../components/productDetail/product_qty_comp.dart';
import '../config/host_con.dart';
import '../getxcontroller/dyn_customer_controller.dart';
import '../getxcontroller/outlet_controller.dart';
import '../getxcontroller/payment_controller.dart';
import '../getxcontroller/printer_check_constroller.dart';
import '../getxcontroller/product_controller.dart';
import '../getxcontroller/shipping_controller.dart';
import '../getxcontroller/user_info_controller.dart';
import '../helper/order_helper.dart';
import '../models/dyn_customer_model.dart';
import '../models/payment_model.dart';
import '../models/product.dart';
import '../models/shipping_model.dart';
import '../service/user_info_service.dart';
import '../widgets/common/common.dart';
import 'product_detail_screen.dart';

class CartScreen extends StatefulWidget {
  final Function pageChange;
  const CartScreen({Key? key, required this.pageChange}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final proController = Get.put(ProductController());
  DateTime _selectedDate = DateTime.now();
  final dynCustomerController = Get.put(DynCustomerController());
  final paymentCtr = Get.put(PaymentController());
  final riderController = Get.put(RiderController());
  final geoController = Get.put(GeographyController());
  final shippingCtr = Get.put(ShippingController());
  final outletCtr = Get.put(OutletController());
  final userInfoController = Get.put(UserInfoController());
  final cartController = Get.put(CartController());
  final productContr = Get.put(ProductController());
  final _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('dd-MM-yyyy');
  final customerName = TextEditingController();
  final customerTel = TextEditingController();
  late String outletSelected = outletCtr.currentOutlet.code;
  final shopName = TextEditingController();
  final customerAddr = TextEditingController();
  final discount = TextEditingController();
  final riderFee = TextEditingController();
  late final List<PaymentModel> paymentList = paymentCtr.allPayment();
  late String paymentSelected = paymentList[1].code;
  late final List<GeographyModel> geographyList = geoController.geography;
  late int geographySelected = geographyList[0].id;
  late final List<RiderModel> riderList = riderController.allRider;
  late int riderSelected = 0; // riderList[1].id;
  ShippingFee? shippingFeePayAt = ShippingFee.destication;
  late final List<ShippingModel> shippingList = shippingCtr.allShipping();
  late String shippingSelected = shippingList[0].code;
  void addOneItem(Product product) {
    cartController.addCart(product, 1, 0);
    setState(() {});
  }

  void removeOneItem(Product product) {
    cartController.removeOneCart(
      product,
    );
    setState(() {});
  }

  void onSelectMorePress() {
    widget.pageChange(0);
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

  void disCountOnValChange(val) {
    setState(() {
      discount.text = val;
      discount.selection =
          TextSelection.collapsed(offset: discount.text.length);
    });
  }

  void riderFeeOnValChange(val) {
    setState(() {
      riderFee.text = val;
      riderFee.selection =
          TextSelection.collapsed(offset: riderFee.text.length);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // discount.text = '0';
    // riderFee.text = '0';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cartData = cartController.cartItem;
    double discountCal() {
      if (discount.text.isEmpty) {
        return 0;
      }

      return double.parse(discount.text);
    }

    double riderFeeCal() {
      if (riderFee.text.isEmpty) {
        return 0;
      }

      return double.parse(riderFee.text);
    }

    double grandTotal() {
      return (cartController.cartCost + riderFeeCal() - discountCal());
    }

    DynCustomerModel dynCustomerModel = DynCustomerModel(
      name: customerName.text,
      tel: customerTel.text,
      shipping: shippingSelected,
      payment: paymentSelected,
      outlet: outletSelected,
      customerAddr: customerAddr.text,
      shippingFee: shippingFeePayAt,
      discount: discountCal(),
      amount: cartController.cartCost,
      product: cartController.allProduct,
      riderFee: riderFeeCal(),
      bookingDate: _selectedDate,
      riderId: riderSelected,
      geoId: geographySelected,
    );
    String _customResMessage(String res) {
      List<String> subList;
      String reMessage;
      if (res.contains("ສິນຄ້າ")) {
        subList = res.split("|").toList();
        reMessage = proController.productId(int.parse(subList[1])).proName;
        return subList[0] + " " + reMessage + " " + subList[2];
      }

      return res;
    }

    Future<bool> userBalanceCheck() async {
      final balance =
          await UserInfService.userbalance(userInfoController.userId);
      double currentBalance = balance[2];
      double orderTotalPrice = cartData.fold(
          0, (previousValue, element) => element.priceTotal + previousValue);
      if (orderTotalPrice > currentBalance) {
        return false;
      } else {
        return true;
      }
    }

    Future<void> printTicket() async {
      log("Printer allert");
      await CommonUtil.printTicket(context, false);
      cartData.length = 0;
      cartController.clearCartItem();
    }

    Future<void> placeOrder() async {
      final printerConCheckController = Get.put(PrinterConnectionCheck());
      // bool isPrinterConnected = await CommonUtil.isPrintCon();
      bool isPrinterConnected = await CommonUtil.isPrintCon();
      if (!isPrinterConnected &&
          printerConCheckController.isPrinterCheckEnable()) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const PrinterSetting(),
          ),
        );
      } else if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        // **** assign dynamicustomer *****//
        // widget.dynCustomerModel.discount = widget.discount;
        //** check printer connection ** */

        dynCustomerController.addCustomerModel(dynCustomerModel);
        //IF ORDER LEN < 1 MEANING NO ORDER TAKEN
        if (cartData.isEmpty) {
          String res = "No order taken";

          AlertSmart.errorDialog(context, _customResMessage(res));
          return;
        }
        //***** assign discount for the cart *******/
        // cartItem[0].discountPercent = widget.discount;
        // chack user balance and order price

        // String serverResponse = '';
        // bool isBalanceSufficient = await userBalanceCheck();
        // if (!isBalanceSufficient) {
        //   context.loaderOverlay.hide();
        //   serverResponse = 'ຂໍອາໄພ ຍອດເງິນບໍ່ພຽງພໍ';
        //   log("Balance is not enought");
        // } else {
        String serverResponse = await OrderHelper.sendOrder(
            cartData, userInfoController.userId, userInfoController.userToken);
        await AlertSmart.printTicketAlert(
            context, _customResMessage(serverResponse), printTicket);
        // }
      }
    }

    Future<void> previewTicket() async {
      dynCustomerController.addCustomerModel(dynCustomerModel);
      return AlertSmart.ticketPreviewDialog(
          context, "Ticket preview", placeOrder, false);
    }

    Widget buildShippingFee() {
      return Row(children: <Widget>[
        Flexible(
          child: ListTile(
            title: const Text(
              'ຕົ້ນທາງ',
              style: TextStyle(fontFamily: 'noto san lao'),
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
              style: TextStyle(fontFamily: 'noto san lao'),
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

    return cartData.isEmpty
        ? Center(
            child: Image.asset(
              'asset/images/waiting.png',
              height: 200,
            ),
          )
        : Column(
            children: [
              Expanded(
                // height: size.height * 0.6,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ******** Card items list ******* //
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: cartData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              // padding: const EdgeInsetsDirectional.fromSTEB(
                              //     16, 8, 16, 0),
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                width: double.infinity,
                                // height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: productContr
                                              .productId(cartData[index].proId)
                                              .proImagePath,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.fitWidth,
                                          height: 40,
                                          width: 40,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12, 0, 0, 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 8),
                                              child: Text(
                                                productContr
                                                    .productId(
                                                        cartData[index].proId)
                                                    .proName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ),
                                            Text(
                                              '\$ ${numFormater.format(cartData[index].price)} x  ${cartData[index].qty}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          ProductQtyComp(
                                            product: productContr.productId(
                                                cartData[index].proId),
                                            addOneState: addOneItem,
                                            removeOneState: removeOneItem,
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white.withOpacity(
                                                0.4,
                                              ),
                                            ),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.delete_outline_rounded,
                                                color: Color(0xFFE86969),
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                cartController.removeCart(
                                                    cartData[index].proId);
                                                setState(() {});
                                                // Remove item
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),

                      //****Customer info****//
                      Card(
                        child: Form(
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
                                          color: kPri,
                                        ),
                                      ),
                                    ),
                                    DatePickerButton(
                                        text: 'ເລືອກວັນທີ',
                                        showDate: _presentDatePicker),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: ConstDesign.buildTextFormFiel(
                                        customerName,
                                        'ກລນ ໃສ່ຊື່ລູກຄ້າ',
                                        'ຊື່ລູກຄ້າ',
                                        TextInputType.text,
                                        refreshData,
                                        false),
                                  ),
                                  Flexible(
                                    child: ConstDesign.buildTextFormFiel(
                                        customerTel,
                                        'ກລນ ໃສ່ເບີໂທລູກຄ້າ',
                                        'ເບີໂທລູກຄ້າ',
                                        TextInputType.phone,
                                        refreshData,
                                        false),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: ConstDesign.buildTextFormFiel(
                                        customerAddr,
                                        'ກລນ ໃສ່ບ່ອນສົ່ງ',
                                        'ບ່ອນສົ່ງ',
                                        TextInputType.text,
                                        refreshData,
                                        false),
                                  ),
                                  Flexible(
                                    child: ConstDesign.buildTextFormFiel(
                                        discount,
                                        'ສ່ວນລົດ',
                                        'ສ່ວນລົດ',
                                        TextInputType.phone,
                                        disCountOnValChange,
                                        true),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.2,
                                      child: const Text(
                                        "ແຂວງ:",
                                        // style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: DropdownButtonFormField<int>(
                                        style: const TextStyle(
                                          fontFamily: "noto san lao",
                                          color: kPri,
                                        ),
                                        // dropdownColor: ,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                              width: 0.5,
                                              color: kPri,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                              width: 0.5,
                                              color: kPri,
                                            ),
                                          ),
                                        ),
                                        value: geographySelected,
                                        items: geographyList
                                            .map(
                                                (item) => DropdownMenuItem<int>(
                                                    value: item.id,
                                                    child: Text(
                                                      '${item.abbr} - ${item.description}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: kPri,
                                                      ),
                                                    )))
                                            .toList(),
                                        onChanged: (item) => setState(() {
                                          geographySelected = item!;
                                          if (customerAddr.text.contains("-")) {
                                            customerAddr.text = customerAddr
                                                .text
                                                .split("-")[0]
                                                .trim();
                                          }
                                          customerAddr.text += " - " +
                                              geographyList[item - 1]
                                                  .description;
                                        }),
                                        validator: (value) => value == null
                                            ? "ກລນ ເລືອກເຂດ"
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "ຄ່າຝາກ: ",
                                    // style: TextStyle(color: kPri),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.8,
                                    child: buildShippingFee(),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.2,
                                      child: const Text(
                                        "ຂົນສົ່ງ: ",
                                        // style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: DropdownButtonFormField<String>(
                                        style: const TextStyle(
                                          fontFamily: "noto san lao",
                                          color: kPri,
                                        ),
                                        // dropdownColor: Colors.white,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                              width: 0.5,
                                              color: kPri,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                              width: 0.5,
                                              color: kPri,
                                            ),
                                          ),
                                        ),
                                        value: shippingSelected,
                                        items: shippingList
                                            .map(
                                              (item) =>
                                                  DropdownMenuItem<String>(
                                                value: item.code,
                                                child: Text(
                                                  '${item.code} - ${item.name}',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: kPri),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (item) => setState(() {
                                          shippingSelected = item.toString();
                                          if (!item!.contains("RIDER")) {
                                            riderSelected = 0;
                                          } else {
                                            riderSelected = 1;
                                          }
                                        }),
                                        validator: (value) => value == null
                                            ? "ກລນ ບ່ອນຈັດສົ່ງ"
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.2,
                                      child: const Text(
                                        "ການຊຳລະ: ",
                                        // style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: DropdownButtonFormField<String>(
                                        style: const TextStyle(
                                          fontFamily: "noto san lao",
                                          color: kPri,
                                        ),
                                        // dropdownColor: ,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                              width: 0.5,
                                              color: kPri,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                              width: 0.5,
                                              color: kPri,
                                            ),
                                          ),
                                        ),
                                        value: paymentSelected,
                                        items: paymentList
                                            .map((item) =>
                                                DropdownMenuItem<String>(
                                                    value: item.code,
                                                    child: Text(
                                                      '${item.code} - ${item.name}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: kPri,
                                                      ),
                                                    )))
                                            .toList(),
                                        onChanged: (item) => setState(() {
                                          paymentSelected = item.toString();
                                        }),
                                        validator: (value) => value == null
                                            ? "ກລນ ເລືອກການຊຳລະ"
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (shippingSelected.contains("RIDER"))
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.2,
                                        child: const Text(
                                          "Rider: ",
                                          // style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Flexible(
                                        fit: FlexFit.tight,
                                        child: DropdownButtonFormField<int>(
                                          style: const TextStyle(
                                            fontFamily: "noto san lao",
                                            color: kPri,
                                          ),
                                          // dropdownColor: ,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                width: 0.5,
                                                color: kPri,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                width: 0.5,
                                                color: kPri,
                                              ),
                                            ),
                                          ),
                                          value: riderSelected,
                                          items: riderList
                                              .map((item) =>
                                                  DropdownMenuItem<int>(
                                                      value: item.id,
                                                      child: Text(
                                                        '${item.name} - ${item.tel}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: kPri,
                                                        ),
                                                      )))
                                              .toList(),
                                          onChanged: (item) => setState(() {
                                            riderSelected = item!;
                                          }),
                                          validator: (value) => value == null
                                              ? "ກລນ ເລືອກ Rider"
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (shippingSelected.contains("RIDER") ||
                                  shippingSelected.contains("HAL"))
                                ConstDesign.buildTextFormFiel(
                                    riderFee,
                                    "shipping fee should be: 0",
                                    "ຄ່າສົ່ງ",
                                    TextInputType.number,
                                    riderFeeOnValChange,
                                    true),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ***** Footer *****//
              Container(
                height: size.height * 0.15,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                    // border: Border.all(
                    //   width: 0.1,
                    // ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ຍອດທັງຫມົດ:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '₭${numFormater.format(grandTotal())}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyButton(
                            btnColor: kPri,
                            text: 'ເລືອກສິນຄ້າເພີ່ມ',
                            press: onSelectMorePress),
                        MyButton(
                          text: 'ສ້າງບິນຂາຍ',
                          press: previewTicket,
                          btnColor: kPri,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
  }

  refreshData(val) {
    setState(() {});
  }
}