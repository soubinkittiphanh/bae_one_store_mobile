import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestore/getxcontroller/chat_type_controller.dart';
import 'package:onestore/widgets/Inquiry/comp_inquiry.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    final chatTypeContr = Get.put(ChatTypeController());
    // final deviceSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            // height: deviceSize.height * 0.15,
            child: ListView.builder(
              itemBuilder: (ctx, id) =>
                  GetBuilder<ChatTypeController>(builder: (ctr) {
                return CompInquiryForm(chatTypeItem: ctr.chatTypeItem[id]);
              }),
              itemCount: chatTypeContr.loadChatTypeItem.length,
            ),
          ),
          Column(
            children: const [
              Text("ຄຳແນະນຳ"),
              Divider(
                thickness: 0.5,
                color: Colors.red,
              ),
              Text(
                  "ທ່ານ ສາມາດກົດ ແຈ້ງ ເຕີມ ຫລື ແຈ້ງ ຖອນ ເພື່ອ ແຈ້ງໃຫ້ແອັດມິນຊາບ ໃນການຮ້ອງຂໍ ລະບົບຈະສົ່ງຫາແອັດມິນໃຫ້ຮັບຮູ້ ອັດຕະໂນມັດໃນການຮ້ອງຂໍຂອງທ່ານ  "),
              Text(
                  "ຖ້າຫາກທ່ານ ມີຄວາມຈຳເປັນຕ້ອງ ສົ່ງເອກສານ ຫລັກຖານຕ່າງໆ ເຊັ່ນ ໃບໂອນເງິນ ທ່ານສາມາດ ກົດປຸ່ມ 'ສົ່ງຂໍ້ຄວາມຫາແອັດມິນ' ໄດ້ໂດຍຕົງ"),
           
            ],
          ),
        ],
      ),
    );
  }
}
