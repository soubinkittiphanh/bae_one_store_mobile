class GeographyModel {
  final int id;
  final String abbr;
  final String description;
  GeographyModel(
      {required this.id, required this.abbr, required this.description});
  GeographyModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        abbr = json['abbr'],
        description = json['description'];
}
