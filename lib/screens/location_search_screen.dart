import 'package:flutter/material.dart';
import 'package:paniwani/models/autocomplate_prediction.dart';

import '../api/api_helpers.dart';
import '../models/place_auto_complate_response.dart';
import '../utils/utils.dart';
import '../widgets/location_list_tile.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  Utils utils = Utils();
  List<AutocompletePrediction> placePredictions = [];

  void placeAutoComplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/autocomplete/json",
      {"input": query, "key": "AIzaSyBwIQQCT80qJDnmN-bh0KLL9Ln_mQS7RVA"},
    );

    String? response = await APIFunction.get(
      context,
      utils,
      uri.toString(),
      '',
    );
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);

      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(child: Icon(Icons.send)),
        ),
        title: const Text("Set Delivery Location"),
        actions: [
          CircleAvatar(
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                onChanged: (value) {
                  placeAutoComplete(value);
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Search your location",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Icon(
                      Icons.location_pin,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          ElevatedButton.icon(
            onPressed: () {
              placeAutoComplete("Karachi");
            },
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            label: const Text("Use my Current Location"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.inversePrimary,
              elevation: 0,
              fixedSize: const Size(double.infinity, 40),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: placePredictions.length,
              itemBuilder:
                  (context, index) => LocationListTile(
                    press: () {},
                    location: placePredictions[index].description.toString(),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
