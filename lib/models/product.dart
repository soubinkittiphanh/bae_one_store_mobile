class Product {
  final int proId;
  final String proCategory;
  final String proCatID;
  final String proName;
  final double proPrice;
  final String proDesc;
  final int proStatus;
  final String proImagePath;
  final String categName;
  final int stock;
  final int saleCount;
  final double retailPrice;
  final String outlet;

  Product({
    required this.proId,
    required this.proName,
    required this.proCatID,
    required this.proDesc,
    required this.proPrice,
    required this.proCategory,
    required this.proStatus,
    this.proImagePath = '',
    required this.categName,
    required this.stock,
    required this.saleCount,
    required this.retailPrice,
    required this.outlet,
  });
}
