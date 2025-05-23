import 'package:paniwani/models/bundle.dart';

class User {
  String? id;
  String? phoneNumber;
  String? fullName;
  String? email;
  DateTime? dateOfBirth;
  String? gender;
  List<Bundle>? activeBundles;
  bool? waterDeliveryBoy;

  User({
    this.id,
    this.phoneNumber,
    this.fullName,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.activeBundles = const [],
    this.waterDeliveryBoy = false,
  });

  bool get isProfileComplete {
    return fullName != null &&
        email != null &&
        dateOfBirth != null &&
        gender != null;
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['email'];
    phoneNumber = json['number'];
    fullName = json['full_name'];
    email = json['email'];
    dateOfBirth = DateTime.parse(json['date_of_birth']);
    gender = json['gender'];
    waterDeliveryBoy = json['water_delivery_boy'] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': phoneNumber,
      'full_name': fullName,
      'email': email,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'water_delivery_boy': waterDeliveryBoy,
    };
  }
}
