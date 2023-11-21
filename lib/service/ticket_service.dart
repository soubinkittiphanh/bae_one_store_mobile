class TicketService {
  static String totalLabelCondition(String shipping) {
    if (shipping.contains("WKI") || shipping.contains("RIDER")) {
      return 'ຍອດລວມ: ';
    } else if (shipping.contains("TRANSFER") || shipping.contains("CASH")) {
      return '';
    }
    return "COD: ";
  }
}
