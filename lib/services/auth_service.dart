import 'dart:async';
import '../models/user.dart';

class AuthService {
  User? _currentUser;
  
  // Add a debug print to the getter
  User? get currentUser {
    print("Current user: $_currentUser");
    return User(
        id: "user123",
        phoneNumber: "+923332897837",
        fullName: "John Doe",
        email: "john.doe@example.com",
        dateOfBirth: DateTime(1990, 1, 1),
        gender: "Male",
      );;
  }

  Future<bool> sendOtp(String phoneNumber) async {
    print("Sending OTP to $phoneNumber");
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<User?> verifyOtp(String phoneNumber, String otp) async {
    print("Verifying OTP: $phoneNumber, $otp");
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Assume OTP is "123456" for testing
    if (otp != "123456") {
      print("OTP verification failed: incorrect OTP");
      return null;
    }
    
    // Check if user exists
    final isExistingUser = phoneNumber == "1234567890";
    print("Is existing user: $isExistingUser");
    
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
    
    print("User after verification: $_currentUser");
    return _currentUser;
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

  Future<void> logout() async {
    print("Logging out user: $_currentUser");
    _currentUser = null;
  }
}