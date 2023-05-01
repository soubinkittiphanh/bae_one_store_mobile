import 'package:flutter/material.dart';

class CompAdjustQty extends StatefulWidget {
  const CompAdjustQty(
      {Key? key,
      required this.orderQty,
      required this.addOne,
      required this.removeOne})
      : super(key: key);
  final int orderQty;
  final Function addOne;
  final Function removeOne;

  @override
  _CompAdjustQtyState createState() => _CompAdjustQtyState();
}

class _CompAdjustQtyState extends State<CompAdjustQty> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            widget.addOne();
          },
          icon: const Icon(Icons.add),
        ),
        Text(widget.orderQty.toString()),
        IconButton(
          onPressed: () {
            widget.removeOne();
          },
          icon: const Icon(Icons.remove),
        ),
      ],
    );
  }
}
