import 'package:paniwani/models/bundle.dart';

class User {
  final String id;
  final String phoneNumber;
  String? fullName;
  String? email;
  DateTime? dateOfBirth;
  String? gender;
  List<Bundle> activeBundles;

  User({
    required this.id,
    required this.phoneNumber,
    this.fullName,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.activeBundles = const [],
  });

  bool get isProfileComplete {
    return fullName != null && email != null && dateOfBirth != null && gender != null;
  }
}