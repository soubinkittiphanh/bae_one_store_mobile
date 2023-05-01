import 'dart:developer';

import 'package:get/get.dart';

import '../getxcontroller/ticket_header_controller.dart';
import '../models/ticket_header_model.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:onestore/config/host_con.dart';

class TicketHeaderService {
  static final ticketController = Get.put(TicketHeaderContr());
  static Future<void> requestTicketHeaderData() async {
    List<TicketHeaderModel> tempTicket = [];
    final url = Uri.parse(hostname + "ticket_f");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as List;
      tempTicket = jsonResponse.map((el) {
        log("===============> " + el["ticket_diamon"].toString());
        return TicketHeaderModel(
          name: el["ticket_name"].toString(),
          diamon: el["ticket_diamon"],
          price: double.parse(el["ticket_price"].toString()),
        );
      }).toList();
      log("Garena ticket count:========> " + tempTicket.length.toString());
      ticketController.setTicketHeader(tempTicket);
    } else {
      log("Garena ticket count fail:========> " + tempTicket.length.toString());
      ticketController.setTicketHeader(tempTicket);
    }
  }
}
