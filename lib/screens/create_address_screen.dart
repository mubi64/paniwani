import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:paniwani/api/services/address_service.dart';
import 'package:paniwani/widgets/primary_button.dart';

import '../models/address.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';
import '../widgets/custom_text_field.dart';
import 'map_picker_screen.dart';

class CreateAddressScreen extends StatefulWidget {
  const CreateAddressScreen({super.key});

  @override
  _CreateAddressScreenState createState() => _CreateAddressScreenState();
}

class _CreateAddressScreenState extends State<CreateAddressScreen> {
  final Utils _utils = Utils();
  final _formKey = GlobalKey<FormState>();

  TextEditingController addressTitle = TextEditingController(text: '');
  TextEditingController addressLine1 = TextEditingController(text: '');
  TextEditingController city = TextEditingController(text: '');
  TextEditingController country = TextEditingController(text: '');
  double? latitude;
  double? longitude;
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always)
        return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      selectedLocation = LatLng(position.latitude, position.longitude);

      latitude = selectedLocation?.latitude;
      longitude = selectedLocation?.longitude;
    });
    List<Placemark> placemarks = await placemarkFromCoordinates(
      selectedLocation!.latitude,
      selectedLocation!.longitude,
    );
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      setState(() {
        city.text = place.locality.toString();
        country.text = place.country.toString();
      });
    }
  }

  void _pickLocationFromMap() async {
    final pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MapPickerScreen()),
    );

    if (pickedLocation != null) {
      setState(() {
        latitude = pickedLocation['latitude'];
        longitude = pickedLocation['longitude'];
        city.text = pickedLocation['city'];
        country.text = pickedLocation['country'];
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate() &&
        latitude != null &&
        longitude != null) {
      _formKey.currentState!.save();
      _utils.showProgressDialog(context, text: "Create Address...");

      Address address = await AddressService().createAddress(
        context,
        addressTitle.text,
        addressLine1.text,
        city.text,
        country.text,
        latitude.toString(),
        longitude.toString(),
      );
      _utils.hideProgressDialog(context);
      Navigator.pop(context);
    } else {
      _utils.hideProgressDialog(context);
      _utils.showToast(
        'Please fill all fields and select location on map',
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.createAddress)),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 8,
                    children: [
                      CustomTextField(
                        controller: addressTitle,
                        labelText: AppStrings.title,
                        onValidate: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.enterYour + AppStrings.title;
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: addressLine1,
                        labelText: AppStrings.completeAddress,
                        onValidate: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.enterYour +
                                AppStrings.completeAddress;
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: city,
                        labelText: AppStrings.city,
                        onValidate: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.enterYour + AppStrings.city;
                          }
                          return null;
                        },
                        enabled: false,
                      ),
                      CustomTextField(
                        controller: country,
                        labelText: AppStrings.country,
                        onValidate: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.enterYour + AppStrings.country;
                          }
                          return null;
                        },
                        enabled: false,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                            icon: Icon(Icons.map),
                            label: Text(
                              "Pick from Map",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            onPressed: _pickLocationFromMap,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: PrimaryButton(
                onPressed: _submit,
                text: AppStrings.createAddress,
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
