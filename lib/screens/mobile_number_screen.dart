import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:paniwani/utils/utils.dart';
import 'package:paniwani/widgets/primary_button.dart';
import '../api/services/auth_service.dart';
import '../storage/shared_pref.dart';
import '../utils/strings.dart';
import '../widgets/custom_text_field.dart';
import 'otp_verification_screen.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({super.key});

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  Utils utils = Utils();
  final SharedPref _pref = SharedPref();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  final PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'PK');
  bool isNumberValid = false;
  String diCode = '';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> validateBaseUrl() async {
    _urlController.text = _urlController.text.toLowerCase().replaceAll(' ', '');
    if (_urlController.text.endsWith("/")) {
      _urlController.text = _urlController.text.substring(
        0,
        _urlController.text.length - 1,
      );
    }
    if (!_urlController.text.startsWith("https://") &&
        !_urlController.text.startsWith("http://")) {
      _urlController.text = "https://${_urlController.text}";
    }
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    await validateBaseUrl();
    await _pref.saveString(_pref.prefBaseUrl, _urlController.text);

    setState(() {
      _isLoading = true;
    });
    utils.showProgressDialog(context);
    try {
      setState(() {
        _phoneController.text = _phoneController.text.replaceAll(' ', '');
      });
      final result = await _authService.sendOTP(
        context: context,
        phoneNumber: diCode + _phoneController.text,
      );
      if (result) {
        utils.hideProgressDialog(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => OtpVerificationScreen(
                  phoneNumber: diCode + _phoneController.text,
                ),
          ),
        );
      } else {
        utils.hideProgressDialog(context);
        utils.showToast("OTP send failed", context);
      }
    } catch (e) {
      utils.showToast(AppStrings.error, context);
      utils.hideProgressDialog(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.water_damage_rounded,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    size: 100,
                  ),
                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 100),
                  Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.mobileNumberLabel,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      CustomTextField(
                        controller: _urlController,
                        labelText: "Base URL",
                        onValidate: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter baseURL";
                          }
                          return null;
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            setState(() {
                              diCode = number.dialCode ?? '';
                            });
                          },
                          onInputValidated: (bool value) async {
                            setState(() {
                              isNumberValid = value;
                            });
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          selectorTextStyle: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          initialValue: _phoneNumber,
                          textFieldController: _phoneController,
                          inputDecoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: AppStrings.sendOtp,
                    onPressed:
                        _isLoading
                            ? null
                            : isNumberValid
                            ? _sendOtp
                            : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
