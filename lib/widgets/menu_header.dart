import 'package:flutter/material.dart';

import '../config/app.dart';

class MenuHeader extends StatelessWidget {
  final String title;
  const MenuHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 2,
              height: 40,
              color: kLastColor,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              // style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Divider(
          color: kLastColor,
        ),
      ],
    );
  }
}
