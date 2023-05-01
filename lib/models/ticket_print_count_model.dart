const String ticketPrintCountTable = "ticket_print";

class TikcetPrintCountFields {
  static final List<String> values = [
    id,
    ticketOrderNumber,
    isPrint,
    printCount,
    lastPrint
  ];
  static final String id = "_id";
  static final String ticketOrderNumber = "ticketOrderNumber";
  static final String isPrint = "isPrint";
  static final String printCount = "printCount";
  static final String lastPrint = "lastPrint";
}

class TicketPrintCountModel {
  final int? id;
  final String ticketOrderNumber;
  final bool isPrint;
  final int printCount;
  final DateTime lastPrint;
  const TicketPrintCountModel({
    this.id,
    required this.ticketOrderNumber,
    this.isPrint = false,
    this.printCount = 0,
    required this.lastPrint,
  });
  static TicketPrintCountModel fromJson(Map<String, Object?> json) =>
      TicketPrintCountModel(
        id: json[TikcetPrintCountFields.id] as int?,
        ticketOrderNumber:
            json[TikcetPrintCountFields.ticketOrderNumber] as String,
        isPrint: json[TikcetPrintCountFields.isPrint] == 1,
        printCount: json[TikcetPrintCountFields.printCount] as int,
        lastPrint:
            DateTime.parse(json[TikcetPrintCountFields.lastPrint] as String),
      );

  Map<String, Object?> toJson() => {
        TikcetPrintCountFields.id: id,
        TikcetPrintCountFields.ticketOrderNumber: ticketOrderNumber,
        TikcetPrintCountFields.isPrint: isPrint ? 1 : 0,
        TikcetPrintCountFields.printCount: printCount,
        TikcetPrintCountFields.lastPrint: lastPrint.toIso8601String(),
      };

  TicketPrintCountModel copy({
    int? id,
    String? ticketOrderNumber,
    bool? isPrint,
    int? printCount,
    DateTime? lastPrint,
  }) =>
      TicketPrintCountModel(
        id: id ?? this.id,
        ticketOrderNumber: ticketOrderNumber ?? this.ticketOrderNumber,
        isPrint: isPrint ?? this.isPrint,
        printCount: printCount ?? this.printCount,
        lastPrint: lastPrint ?? this.lastPrint,
      );
}
