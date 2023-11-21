class InvoiceInfo {
  static String logoUnitel = "asset/images/ticket_logo/unitel.jpeg";
  static String logoTruemoney = "asset/images/ticket_logo/true.jpeg";
  static String logoLaotel = "asset/images/ticket_logo/ltc.jpeg";
  static String logoETL = "asset/images/ticket_logo/etl.jpeg";
  static String logoBeeline = "asset/images/ticket_logo/beeline.jpg";
  static String headerUnitel = "Unitel";
  static String headerTruemoney = "True Money";
  static String headerLaotel = "Lao telecom";
  static String headerETL = "ETL";
  static String headerBeeline = "Beeline";
  static String header(String code) {
    String hd = "";
    if (code == "1000") {
      hd = headerTruemoney;
    } else if (code == "1003") {
      hd = headerLaotel;
    } else if (code == "1004") {
      hd = headerUnitel;
    } else if (code == "1005") {
      hd = headerETL;
    } else if (code == "1006") {
      hd = headerBeeline;
    } else {
      hd = "Royal online";
    }
    return hd;
  }

  static String logoStr(String code) {
    String lg = "";
    if (code == "1000") {
      lg = logoTruemoney;
    } else if (code == "1003") {
      lg = logoLaotel;
    } else if (code == "1004") {
      lg = logoUnitel;
    } else if (code == "1005") {
      lg = logoETL;
    } else if (code == "1006") {
      lg = logoBeeline;
    } else {
      lg = "Royal online";
    }
    return lg;
  }
}
