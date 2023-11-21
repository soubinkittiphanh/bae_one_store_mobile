import 'package:onestore/widgets/message_card.dart';

class RiderModel {
  final int id;
  final String name;
  final String tel;
  final bool isActive;
  final String rating;
  RiderModel({
    required this.id,
    required this.name,
    required this.tel,
    required this.isActive,
    required this.rating,
  });
  RiderModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        tel = json['tel'],
        isActive = json['isActive'],
        rating = json['rating'];
}
