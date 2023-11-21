import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:onestore/models/ticket_header_model.dart';

class TicketHeaderContr extends GetxController {
  final List<TicketHeaderModel> ticketHeaderList = [];
  void setTicketHeader(List<TicketHeaderModel> ticketData) {
    ticketHeaderList.length = 0;
    for (var item in ticketData) {
      ticketHeaderList.add(item);
    }
    update();
  }

  List<TicketHeaderModel> getTicketHeader() {
    return ticketHeaderList;
  }
}
