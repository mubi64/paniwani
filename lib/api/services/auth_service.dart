import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../utils/utils.dart';
import '../api_helpers.dart';

class AuthService extends ChangeNotifier {
  final Utils utils = Utils();
  User? _currentUser;

  // Getter for cached user only
  User? get currentUser => _currentUser;

  // Fetches user info (and sets _currentUser)
  Future<void> getCurrentUser(BuildContext context) async {
    _currentUser = await getUserInfo(context);
    notifyListeners();
  }

  Future<bool> sendOTP({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      utils.loggerPrint('Sending OTP to $phoneNumber');
      FormData formData = FormData.fromMap({'mobile_number': phoneNumber});

      var response = await APIFunction.post(
        context,
        utils,
        APIFunction.sentOtp,
        formData,
        '',
      );

      if (response != null) {
        utils.loggerPrint('OTP sent successfully');
        return true;
      } else {
        utils.loggerPrint('Failed to send OTP: $response');
        return false;
      }
    } catch (e) {
      utils.loggerPrint('Error in sending OTP: $e');
      return false;
    }
  }

  Future<User?> verifyOtp(
    BuildContext context,
    String phoneNumber,
    String otp,
  ) async {
    utils.loggerPrint(phoneNumber);
    utils.loggerPrint(otp);
    try {
      FormData formData = FormData.fromMap({
        'mobile_number': phoneNumber,
        'input_otp': otp,
      });

      var response = await APIFunction.post(
        context,
        utils,
        APIFunction.verifyOtp,
        formData,
        '',
      );

      utils.loggerPrint({response, "I want to checl Data"});
      if (response != null) {
        final data = response.data['message'];
        final isNewUser = data['is_new_user'];

        if (isNewUser) {
          _currentUser = User(id: phoneNumber, phoneNumber: phoneNumber);
        } else {
          _currentUser = await getUserInfo(context);
          utils.loggerPrint({_currentUser, 'Cusrrent user'});
        }

        utils.loggerPrint('OTP Verified Successfully');
      }
    } catch (e) {
      utils.loggerPrint('Error in OTP Verification: $e');
    }

    utils.loggerPrint("User after verification: $_currentUser");
    return _currentUser;
  }

  Future<User?> getUserInfo(BuildContext context) async {
    utils.loggerPrint("Fetching user info");
    // Simulate API call
    var response = await APIFunction.get(
      context,
      utils,
      APIFunction.customerInfo,
      '',
    );

    if (response != null) {
      final data = response['message'];
      _currentUser = User(
        id: data['email'],
        phoneNumber: data['number'],
        fullName: data['full_name'],
        email: data['email'],
        dateOfBirth: DateTime.parse(data['date_of_birth']),
        gender: data['gender'],
      );
      notifyListeners();
      utils.loggerPrint('User info fetched successfully: $data');
      return _currentUser;
    } else {
      utils.loggerPrint(
        "Failed to fetch user info: ${response?.statusMessage}",
      );
      return null;
    }
  }

  Future<User?> getCompleteRegistration(
    BuildContext context,
    String phoneNumber,
    String fullName,
    String email,
    String dateOfBirth,
    String gender,
  ) async {
    utils.loggerPrint('$phoneNumber, $fullName, $email, $dateOfBirth, $gender');
    try {
      FormData formData = FormData.fromMap({
        'mobile_number': phoneNumber,
        'full_name': fullName,
        'email': email,
        'birth_date': dateOfBirth,
        'gender': gender,
      });
      var response = await APIFunction.post(
        context,
        utils,
        APIFunction.completeRegistration,
        formData,
        null,
      );
      if (response != null && response.statusCode == 200) {
        // final data = response.data['message'];
        _currentUser = User(
          id: email,
          phoneNumber: phoneNumber,
          fullName: fullName,
          email: email,
          dateOfBirth: DateTime.parse(dateOfBirth.toString()),
          gender: gender,
        );
        utils.loggerPrint('Registration completed successfully');
        return _currentUser;
      } else {
        utils.loggerPrint(
          'Failed to complete registration: ${response?.statusMessage}',
        );
        return null;
      }
    } catch (e) {
      utils.loggerPrint('Error in completing registration: $e');
      return null;
    }
  }

  Future<List<String>> getGenders(BuildContext context) async {
    var response = await APIFunction.get(
      context,
      utils,
      APIFunction.genders,
      '',
    );

    if (response != null) {
      final data = response['message'];
      utils.loggerPrint('User info fetched successfully: $data');
      return List<String>.from(data);
    } else {
      utils.loggerPrint("Failed to fetch user info: $response");
      return [];
    }
  }

  Future<bool> updateUserInfo(
    String fullName,
    String email,
    DateTime dateOfBirth,
    String gender,
  ) async {
    print("Updating user info: $fullName, $email");
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (_currentUser != null) {
      _currentUser!.fullName = fullName;
      _currentUser!.email = email;
      _currentUser!.dateOfBirth = dateOfBirth;
      _currentUser!.gender = gender;
      print("User updated: $_currentUser");
      return true;
    }

    print("Update failed: _currentUser is null");
    return false;
  }

  Future<void> logout(BuildContext context) async {
    var response = await APIFunction.get(
      context,
      utils,
      APIFunction.logout,
      '',
    );
    _currentUser = null;
  }
}
