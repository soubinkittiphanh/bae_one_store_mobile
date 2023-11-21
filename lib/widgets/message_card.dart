import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/getxcontroller/message_controller.dart';
import 'package:onestore/models/inbox_message.dart';
import 'package:onestore/models/rider_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'message_item_detail.dart';

enum RatingLevel {
  Gold,
  Silver,
  Platinum,
  Diamon,
  Master,
}

class MessageCard extends StatelessWidget {
  const MessageCard({Key? key, required this.riderModel, required this.idx})
      : super(key: key);
  final RiderModel riderModel;
  final int idx;

  @override
  Widget build(BuildContext context) {
    double rating = 0;
    Color color;
    void openWhatsApp({@required number, @required message}) async {
      String url = "whatsapp://send?phone=$number&text=$message";

      await canLaunch(url) ? launch(url) : print('Could not launch $url');
    }

    switch (riderModel.rating) {
      case "Gold":
        color = Colors.amber;
        rating = 1;
        break;
      case "Silver":
        color = Colors.grey;
        rating = 2;
        break;
      case "Platinum":
        color = Colors.blue;
        rating = 3;
        break;
      case "Diamon":
        color = Colors.deepPurple;
        rating = 4;
        break;
      case "Master":
        color = Colors.deepPurple;
        rating = 5;
        break;
      default:
        color = Colors.amber;
        break;
    }
    return Card(
      // elevation: 0.1,
      child: GestureDetector(
        onTap: () {
          // messageController.setMessageAsRead(idx);
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (ctx) => MessageItemDetail(inboxmessage: messageData),
          //   ),
          // );
          openWhatsApp(
              number: '+856${riderModel.tel}', message: 'Hello, how are you?');
        },
        child: Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  Text(
                    'ຊື່: ${riderModel.name}',
                    style: const TextStyle(fontFamily: "noto san lao"),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      if (rating >= index + 1) {
                        return Icon(
                          Icons.star,
                          color: color,
                        );
                      } else if (rating > index) {
                        return Icon(
                          Icons.star_half,
                          color: color,
                        );
                      } else {
                        return Icon(
                          Icons.star_border,
                          color: color,
                        );
                      }
                    }),
                  ),
                ],
              ),
              subtitle: Text(
                "ເບີໂທ: " + riderModel.tel,
                style: const TextStyle(
                  fontFamily: "noto san lao",
                  color: Colors.black,
                ),
              ),
              trailing: IconButton(
                icon: const ImageIcon(
                  AssetImage('asset/images/whatsapp.png'),
                  // size: 48,
                  color: kPri,
                  // color: Colors.red,
                ),
                onPressed: () {
                  openWhatsApp(
                      number: '+856${riderModel.tel}',
                      message: 'ສະບາຍດີ ມີອໍເດີ: ');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
