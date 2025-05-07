import 'package:flutter/material.dart';
import 'package:paniwani/screens/splash_screen.dart';
import 'package:paniwani/utils/utils.dart';
import 'package:paniwani/widgets/custom_date_picker.dart';
import 'package:paniwani/widgets/primary_button.dart';
import 'package:provider/provider.dart';
import '../api/services/auth_service.dart';
import '../models/restaurant.dart';
import '../utils/strings.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_text_field.dart';

class UserInfoScreen extends StatefulWidget {
  String phoneNumber;
  UserInfoScreen({super.key, required this.phoneNumber});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  Utils utils = Utils();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime? _selectedDate;
  String? _selectedGender;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Restaurant>().fetchGenders(context);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveUserInfo() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      utils.showToast(
        AppStrings.selectMessage + AppStrings.dateOfBirth,
        context,
      );
      return;
    }
    if (_selectedGender == null) {
      utils.showToast(AppStrings.selectMessage + AppStrings.gender, context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.getCompleteRegistration(
        context,
        widget.phoneNumber,
        _nameController.text,
        _emailController.text,
        _selectedDate.toString(),
        _selectedGender!,
      );

      if (result != null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        utils.showToast(AppStrings.error, context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        var genders = restaurant.genders;
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Center(
                    child: Text(
                      AppStrings.completeProfile,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Center(
                    child: Text(
                      AppStrings.provideInformation,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _nameController,
                    labelText: AppStrings.fullName,
                    onValidate: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.enterYour + AppStrings.fullName;
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: _emailController,
                    labelText: AppStrings.email,
                    keyboardType: TextInputType.emailAddress,
                    onValidate: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.enterYour + AppStrings.email;
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  CustomDatePicker(
                    controller: TextEditingController(
                      text:
                          _selectedDate == null
                              ? ''
                              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                    ),
                    onDateSelected: () => _selectDate(context),
                    hintText: AppStrings.dateOfBirth,
                    icon: Icons.calendar_today,
                  ),
                  CustomDropdown<String>(
                    selectedValue: _selectedGender,
                    items: genders,
                    hintText: AppStrings.selectGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    getLabel: (gender) => gender,
                  ),

                  const SizedBox(height: 10),
                  PrimaryButton(
                    text: AppStrings.saveAndContinue,
                    onPressed: _isLoading ? null : _saveUserInfo,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
