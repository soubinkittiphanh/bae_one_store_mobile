import 'package:flutter/material.dart';

import '../config/app.dart';

class MenuItem extends StatelessWidget {
  final String menuName;
  final IconData icon;
  final Function function;
  const MenuItem({
    Key? key,
    required this.menuName,
    required this.icon,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: kPrimaryColor,
                  width: 0.7,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30,
                child: Icon(
                  icon,
                  color: kLastColor,
                ),
              ),
            ),
          ),
          Text(
            menuName,
            style: TextStyle(fontFamily: 'noto san lao'),
          ),
        ],
      ),
    );
  }
}
