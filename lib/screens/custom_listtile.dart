import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Card(
        shape: const RoundedRectangleBorder(),
        child: ListTile(
          leading: FittedBox(
            child: Column(
              children: const [
                Text("Head"),
                CircleAvatar(
                  child: Text("A"),
                )
              ],
            ),
          ),
          title: Container(
            height: 60,
            // color: Colors.amber,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
                color: Colors.amber),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [Text("NUPPPO"), Text("aaa")],
                  ),
                  const Text("data")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
