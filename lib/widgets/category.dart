import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/getxcontroller/product_controller.dart';

class Category extends StatefulWidget {
  final Function catChange;
  const Category({Key? key, required this.catChange}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final proCategory = Get.put(ProductController());
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          // color: Colors.white,
          ),
      height: 60,
      child: GetBuilder<ProductController>(builder: (ctr) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount:
              proCategory.productCategory.length, //    categoryItem.length,
          itemBuilder: (context, idx) => buildCategoryItem(idx),
        );
      }),
    );
  }

  Widget buildCategoryItem(int idx) {
    return GestureDetector(
      onTap: () {
        widget.catChange(proCategory.productCategory[idx].catCode);
        setState(() {
          _selectedIndex = idx;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 15),
                    blurRadius: 27,
                    color: Colors.black12)
              ],
              color: _selectedIndex == idx
                  ? kTextPrimaryColor
                  : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          // color: kLastColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                proCategory.productCategory[idx].catName,
                style: const TextStyle(color: Colors.white),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                margin: const EdgeInsets.only(top: 10 / 4),
                height: 1,
                width: 30,
                color:
                    _selectedIndex == idx ? Colors.white : Colors.transparent,
              )
            ],
          ),
        ),
      ),
    );
  }
}
