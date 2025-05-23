import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paniwani/screens/navigation_bar_screen.dart';
import '../api/services/auth_service.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';
import '../widgets/primary_button.dart';
import 'user_info_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  Utils utils = Utils();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _canResend = false;
  int _timerSeconds = 30;
  Timer? _timer;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timerSeconds = 30;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;
    final otp = _otpControllers.map((controller) => controller.text).join();

    setState(() {
      _isLoading = true;
    });
    try {
      final user = await _authService.verifyOtp(
        context,
        widget.phoneNumber,
        otp,
      );

      utils.loggerPrint({user, "I want to check User Data"});

      if (user != null) {
        // If user profile is not complete, go to user info screen
        if (!user.isProfileComplete) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder:
                  (context) => UserInfoScreen(phoneNumber: widget.phoneNumber),
            ),
            (route) => false,
          );
        } else {
          // If user profile is complete, go directly to home screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavigationBarScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        utils.showToast(AppStrings.error, context);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.sendOTP(
        context: context,
        phoneNumber: widget.phoneNumber,
      );
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _startTimer();
    } catch (e) {
      utils.showToast(AppStrings.error, context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    AppStrings.otpLabel,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Enter the 6-digit OTP sent to ${widget.phoneNumber.isNotEmpty ? widget.phoneNumber : 'your mobile number'}",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => OtpBox(controller: _otpControllers[index]),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text:
                          !_canResend
                              ? AppStrings.resendOtpTimer
                              : AppStrings.donotResivedOtp,
                      style: TextStyle(color: Colors.grey),
                      children: [
                        if (!_canResend)
                          TextSpan(
                            text: "$_timerSeconds seconds",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        else
                          TextSpan(
                            text: AppStrings.resendOtp,
                            style: TextStyle(color: Colors.orange),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    if (!_isLoading) {
                                      _resendOtp();
                                    }
                                  },
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: PrimaryButton(
                    text: AppStrings.verifyOtp,
                    onPressed: _isLoading ? null : _verifyOtp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OtpBox extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  OtpBox({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size =
            (constraints.maxWidth < 300) ? constraints.maxWidth / 8 : 50;
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              controller: controller,
              onChanged: (value) {
                if (value.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
                if (value.isEmpty) {
                  FocusScope.of(context).previousFocus();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
