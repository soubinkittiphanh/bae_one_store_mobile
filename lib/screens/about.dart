import 'package:flutter/material.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/config/host_con.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: kPri,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Center(child: Text("Version: $release")),
            Center(
                child: Text(
                    "Env: ${hostname.contains("99563") ? "DEV" : "PRODUCTION"}")),
            const Center(child: Text("copyright: DCOMMERCE")),
            const Center(child: Text("ONLINE DC")),
            const Divider(
              thickness: 0.5,
              color: Colors.red,
            ),
            const Text("20231120: SKIP BALANCE CHECK BEFORE POST SALE"),
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
      ),
    );
  }
}
