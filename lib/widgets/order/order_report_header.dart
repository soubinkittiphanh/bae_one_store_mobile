import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/config/host_con.dart';
import 'package:onestore/getxcontroller/order_controller.dart';
import 'package:onestore/widgets/adaptive_button.dart';
import 'package:onestore/widgets/common/my_button.dart';

class OrderReportHead extends StatefulWidget {
  final Function presentDatePicker;
  final Function orderFetch;
  final DateTime selectedDateFrom;
  final DateTime selectedDateTo;
  const OrderReportHead(
      {Key? key,
      required this.presentDatePicker,
      required this.orderFetch,
      required this.selectedDateFrom,
      required this.selectedDateTo})
      : super(key: key);

  @override
  _OrderReportHeadState createState() => _OrderReportHeadState();
}

class _OrderReportHeadState extends State<OrderReportHead> {
  final orderController = Get.put(OrderController());
  Future<void> fetchData() async {
    await widget.orderFetch(widget.selectedDateFrom, widget.selectedDateTo);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'ຈາກວັນທີ: ${DateFormat('dd-MM-yyyy').format(widget.selectedDateFrom)}'),
                    AdaptiveButton(
                      text: 'ເລືອກວັນທີ',
                      showDate: widget.presentDatePicker,
                      dateFromOrTo: "f",
                    ),
                    Text(
                        'ຫາວັນທີ: ${DateFormat('dd-MM-yyyy').format(widget.selectedDateTo)}'),
                    AdaptiveButton(
                      text: 'ເລືອກວັນທີ',
                      showDate: widget.presentDatePicker,
                      dateFromOrTo: "t",
                    ),
                  ],
                ),
                fit: BoxFit.fitWidth,
              ),
              MyButton(
                press: fetchData,
                text: "ດຶງລາຍງານ",
                btnColor: kPri,
              ),
              Text(
                  "ຈຳນວນ ອໍເດີ: ${numFormater.format(orderController.orderItemNotDuplicate.length)}"),
              Text(
                "ລາຄາຂາຍທັງໝົດ: ${numFormater.format(orderController.grandProfitItem()[1])}  ",
              ),
              const Divider(
                thickness: 0.1,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
