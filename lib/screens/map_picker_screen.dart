import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  _MapPickerScreenState createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? selectedLocation;
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _suggestions = [];

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
    });
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() => _suggestions.clear());
      return;
    }

    final dio = Dio();
    try {
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'addressdetails': 1,
          'limit': 5,
        },
        options: Options(
          headers: {'User-Agent': 'FlutterMapPicker/1.0'}, // Required
        ),
      );

      final results = response.data as List;

      setState(() {
        _suggestions =
            results
                .map(
                  (e) => {
                    'lat': double.parse(e['lat']),
                    'lon': double.parse(e['lon']),
                    'display': e['display_name'],
                  },
                )
                .toList();
      });
    } catch (e) {
      print('Search error: $e');
    }
  }

  void _onSuggestionTap(Map<String, dynamic> suggestion) {
    final lat = suggestion['lat'];
    final lon = suggestion['lon'];

    final point = LatLng(lat, lon);
    setState(() {
      selectedLocation = point;
      _suggestions.clear();
      _searchController.clear();
    });

    _mapController.move(point, 13.0);
  }

  @override
  Widget build(BuildContext context) {
    if (selectedLocation == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Pick Location")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Pick Location")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _searchLocation,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search location...",
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_suggestions.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1,
                              ),
                            ),
                          ),
                          child: ListTile(
                            tileColor: Theme.of(context).colorScheme.secondary,
                            title: Text(suggestion['display']),
                            onTap: () => _onSuggestionTap(suggestion),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: selectedLocation!,
                initialZoom: 13.0,
                onTap: (tapPosition, point) {
                  setState(() => selectedLocation = point);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLocation!,
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            selectedLocation!.latitude,
            selectedLocation!.longitude,
          );

          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            Navigator.pop(context, {
              'latitude': selectedLocation!.latitude,
              'longitude': selectedLocation!.longitude,
              'city': place.locality,
              'country': place.country,
            });
          } else {
            Navigator.pop(context, {
              'latitude': selectedLocation!.latitude,
              'longitude': selectedLocation!.longitude,
              'city': null,
              'country': null,
            });
          }
        },
        label: Text("Select"),
        icon: Icon(Icons.check),
      ),
    );
  }
}
