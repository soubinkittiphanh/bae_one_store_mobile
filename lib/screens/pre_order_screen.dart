import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onestore/screens/product_detail_screen.dart';
import 'package:onestore/widgets/cart_comp/cart_oview_comp.dart';
import 'package:onestore/widgets/common/my_button.dart';

import '../components/date_picker_button.dart';
import '../config/const_design.dart';
import '../config/host_con.dart';
import '../getxcontroller/cart_controller.dart';
import '../getxcontroller/outlet_controller.dart';
import '../getxcontroller/payment_controller.dart';
import '../getxcontroller/product_controller.dart';
import '../getxcontroller/shipping_controller.dart';
import '../models/dyn_customer_model.dart';
import '../models/payment_model.dart';
import '../models/shipping_model.dart';

class PreOrderScreen extends StatefulWidget {
  final double cartTotalPrice;
  const PreOrderScreen({Key? key, required this.cartTotalPrice})
      : super(key: key);

  @override
  State<PreOrderScreen> createState() => _PreOrderScreenState();
}

class _PreOrderScreenState extends State<PreOrderScreen> {
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
  final customerName = TextEditingController();
  final customerTel = TextEditingController();
  final shopName = TextEditingController();
  final customerAddr = TextEditingController();
  final discount = TextEditingController();
  final riderFee = TextEditingController();

  late final List<ShippingModel> shippingList = shippingCtr.allShipping();
  late final List<PaymentModel> paymentList = paymentCtr.allPayment();
  late String paymentSelected = paymentList[0].code;
  late String outletSelected = outletCtr.currentOutlet.code;
  late String shippingSelected = shippingList[0].code;
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    discount.text = '0';
    riderFee.text = '0';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double grandTotal() {
      double fee = double.parse(riderFee.text);
      double dis = double.parse(discount.text);
      return (widget.cartTotalPrice + fee) - dis;
      // return 0;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('ຂໍ້ມູນລູກຄ້າ'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
            child: Text("ລາຄາລວມ: ${numFormater.format(grandTotal())}"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: buildDynamicCustomerForm(deviceSize),
        ),
      ),
    );
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

  Widget buildDynamicCustomerForm(
    dynamic deviceSize,
  ) {
    DynCustomerModel dynCustomerModel = DynCustomerModel(
      name: customerName.text,
      tel: customerTel.text,
      shipping: shippingSelected,
      payment: paymentSelected,
      outlet: outletSelected,
      customerAddr: customerAddr.text,
      shippingFee: shippingFeePayAt,
      discount: double.parse(discount.text),
      amount: widget.cartTotalPrice,
      product: cartController.allProduct,
      riderFee: double.parse(riderFee.text),
      bookingDate: _selectedDate,
    );

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
              "ຊື່ລູກຄ້າ", TextInputType.text, refreshData, false),
          const SizedBox(
            height: 4,
          ),
          ConstDesign.buildTextFormFiel(customerTel, "ກະລຸນາໃສ່ເບີໂທລູກຄ້າ",
              "ເບີໂທລູກຄ້າ", TextInputType.number, refreshData, false),
          const SizedBox(
            height: 4,
          ),
          ConstDesign.buildTextFormFiel(customerAddr, "ກລນ ໃສ່ບ່ອນຈັດສົ່ງ",
              "ບ່ອນຈັດສົ່ງ", TextInputType.text, refreshData, false),
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
              value: shippingSelected,
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
              value: paymentSelected,
              items: paymentList
                  .map((item) => DropdownMenuItem<String>(
                      value: item.code,
                      child: Text(
                        '${item.code} - ${item.name}',
                        style: const TextStyle(fontSize: 12),
                      )))
                  .toList(),
              onChanged: (item) => setState(() {
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
              "ສ່ວນລົດ", TextInputType.number, disCountOnValChange, true),
          const SizedBox(
            height: 10,
          ),
          if (paymentSelected.contains('RIDER_COD'))
            const Text(
              "ຄ່າສົ່ງ: ",
              style: TextStyle(color: Colors.white),
            ),
          if (paymentSelected.contains('RIDER_COD'))
            ConstDesign.buildTextFormFiel(riderFee, "shipping fee should be: 0",
                "ຄ່າສົ່ງ", TextInputType.number, riderFeeOnValChange, true),
          OrderNowButton(
            formKey: _formKey,
            dynCustomerModel: dynCustomerModel,
          )
        ],
      ),
    );
  }

  refreshData(val) {
    setState(() {});
  }

  void riderFeeOnValChange(val) {
    log("Value = > " + val);
    if (val.isEmpty) {
      log("rider => " + val);
      setState(() {
        riderFee.text = '0';
        riderFee.selection =
            TextSelection.collapsed(offset: riderFee.text.length - 1);
      });

      return;
    }
    setState(() {
      riderFee.text = val;
      riderFee.selection =
          TextSelection.collapsed(offset: riderFee.text.length);
    });
  }

  void disCountOnValChange(val) {
    if (val.isEmpty) {
      setState(() {
        discount.text = '0';
        discount.selection =
            TextSelection.collapsed(offset: discount.text.length - 1);
      });

      return;
    }
    setState(() {
      discount.text = val;
      discount.selection =
          TextSelection.collapsed(offset: discount.text.length);
    });
  }
}
