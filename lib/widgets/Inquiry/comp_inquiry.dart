import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestore/getxcontroller/user_info_controller.dart';
import 'package:onestore/models/chat_type_model.dart';
import 'package:onestore/screens/topup_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class CompInquiryForm extends StatefulWidget {
  const CompInquiryForm({
    Key? key,
    required this.chatTypeItem,
  }) : super(key: key);
  final ChatTypeModel chatTypeItem;

  @override
  _CompInquiryFormState createState() => _CompInquiryFormState();
}

class _CompInquiryFormState extends State<CompInquiryForm> {
  launchWhatsApp() async {
    const link = WhatsAppUnilink(
      phoneNumber: '+8562097489646',
      text: "ສະບາຍດີແອັດມິນ \n",
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }

  bool isExpand = false;
  @override
  Widget build(BuildContext context) {
    // final userCredProvider = Provider.of<UserCredentialProvider>(context);
    final userInfoController = Get.put(UserInfoController());
    return GestureDetector(
      onTap: widget.chatTypeItem.id == 1 ? launchWhatsApp : null,
      child: Column(
        children: [
          widget.chatTypeItem.id != 1
              ? ListTile(
                  leading: const Icon(Icons.message),
                  title: Text(
                    widget.chatTypeItem.name,
                    style: const TextStyle(fontFamily: 'noto san lao'),
                  ),
                  trailing: IconButton(
                    icon:
                        Icon(isExpand ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        isExpand = !isExpand;
                      });
                    },
                  ),
                )
              : ListTile(
                  leading: const Icon(Icons.message),
                  title: Text(
                    widget.chatTypeItem.name,
                    style: const TextStyle(fontFamily: 'noto san lao'),
                  ),
                ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            firstChild: TopupForm(
              chatType: widget.chatTypeItem,
              userId: userInfoController.userId,
            ),
            secondChild: Container(),
            crossFadeState:
                isExpand ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          )
        ],
      ),
    );
  }
}
