import 'dart:async';
import '../models/user.dart';

class AuthService {
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<bool> sendOtp(String phoneNumber) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<User?> verifyOtp(String phoneNumber, String otp) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Assume OTP is "123456" for testing
    if (otp != "123456") {
      return null;
    }

    // Check if user exists
    final isExistingUser = phoneNumber == "1234567890";
    
    if (isExistingUser) {
      _currentUser = User(
        id: "user123",
        phoneNumber: phoneNumber,
        fullName: "John Doe",
        email: "john.doe@example.com",
        dateOfBirth: DateTime(1990, 1, 1),
        gender: "Male",
      );
    } else {
      _currentUser = User(
        id: "newuser123",
        phoneNumber: phoneNumber,
      );
    }

    return _currentUser;
  }

  Future<bool> updateUserInfo(
    String fullName,
    String email,
    DateTime dateOfBirth,
    String gender,
  ) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (_currentUser != null) {
      _currentUser!.fullName = fullName;
      _currentUser!.email = email;
      _currentUser!.dateOfBirth = dateOfBirth;
      _currentUser!.gender = gender;
      return true;
    }
    
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
  }
}