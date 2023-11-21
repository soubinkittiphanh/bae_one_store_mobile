import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class FavouriteSreen extends StatelessWidget {
  const FavouriteSreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    launchWhatsApp() async {
      const link = WhatsAppUnilink(
        phoneNumber: '+8562077150008',
        text: "Hey! I'm inquiring about the apartment listing",
      );
      // Convert the WhatsAppUnilink instance to a string.
      // Use either Dart's string interpolation or the toString() method.
      // The "launch" method is part of "url_launcher".
      await launch('$link');
    }

    return Center(
        child: Column(
      children: [
        OutlinedButton(
          onPressed: launchWhatsApp,
          child: const Text("Whatsapp"),
        )
      ],
    )
        //  Image.asset(
        //   'asset/images/waiting.png',
        //   height: 200,
        // ),
        );
  }
}
