import 'package:flutter/material.dart';
import 'package:onestore/config/host_con.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("About")),
        body: Center(
          child: Column(
            children: [
              const Text("Version: $release"),
              Text("Env: ${hostname.contains("99563") ? "DEV" : "PRODUCTION"}"),
              const Text("copyright: WTD"),
              const Text("JFILL ONLINE"),
              const Divider(
                thickness: 0.5,
                color: Colors.red,
              ),
              const Text("ລາຍການອັບເດດ"),
              const Text("ປັບປຸງ ໃບບິນ ໃຫ້ສາມາດ ພິມຫລາຍບິນ ພ້ອມກັນໄດ້"),
              const Text("ປັບປຸງ ຫນ້າຕາໃບບິນ ໃຫ້ສວຍງານຂື້ນ"),
              const Text("ສາມາດ ສະແກນຄິວອາ ເພື່ອເຕີມມູນຄ່າໂທໄດ້"),
              const Text(
                  "ສາມາດ ລົດການຊັບຊ້ອນ ໃນການສັ່ງອໍເດີ ໂດຍການຕັດ ຟັງຊັ່ນເພີ່ມກະຕ່າອອກ"),
              const Text("Update security token check on request"),
              const Text("Speed up placing order and print"),
            ],
          ),
        ));
  }
}
