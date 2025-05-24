import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:paniwani/api/api_helpers.dart';
import 'package:paniwani/models/delivery_order.dart';
import 'package:paniwani/screens/rider_screens/map_home_screen.dart';
import 'package:paniwani/utils/utils.dart';
import 'package:paniwani/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/services/delivery_order_service.dart';
import '../../utils/comman_dialogs.dart';
import '../../utils/strings.dart';
import '../../widgets/my_quantity_selector_field.dart';
import '../../widgets/navigate_button.dart';

class OrderDetailsScreen extends StatefulWidget {
  DeliveryOrder? orderData;
  OrderDetailsScreen({super.key, this.orderData});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final Utils _utils = Utils();
  late MapController mapController;
  LatLng? currentLocation;
  late LatLng destination;
  List<LatLng> routePoints = [];
  final TextEditingController deliveredQtyController = TextEditingController();
  final TextEditingController receivedQtyController = TextEditingController(
    text: '0',
  );
  int deliveredBottleQuantity = 1;
  int receivedBottleQuantity = 0;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    setState(() {
      deliveredBottleQuantity = int.parse(
        widget.orderData!.outstandingQuantity.toString(),
      );
      deliveredQtyController.text =
          widget.orderData!.outstandingQuantity.toString();
    });
    destination = LatLng(
      double.parse(widget.orderData!.latitude.toString()),
      double.parse(widget.orderData!.longitude.toString()),
    );

    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
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
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
    fetchRoute();
  }

  void updateQuantity(String value) {
    final enteredQty = int.tryParse(value) ?? 1;
    setState(() {
      deliveredBottleQuantity = enteredQty;
      deliveredQtyController.text = deliveredBottleQuantity.toString();
    });
  }

  Future<void> fetchRoute() async {
    if (currentLocation == null) return;

    final response = await APIFunction.get(
      context,
      null,
      'https://router.project-osrm.org/route/v1/driving/${currentLocation!.longitude},${currentLocation!.latitude};${destination.longitude},${destination.latitude}?geometries=geojson',
      '',
    );
    print('response: $response');
    if (response != null) {
      final data = response;
      final coords = data['routes'][0]['geometry']['coordinates'] as List;
      setState(() {
        routePoints =
            coords
                .map((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
                .toList();
      });
    }
  }

  void openInGoogleMaps() async {
    final lat = widget.orderData!.latitude;
    final lng = widget.orderData!.longitude;
    final url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _utils.showToast(AppStrings.couldNotOpenGoogleMaps, context);
    }
  }

  @override
  void dispose() {
    deliveredQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body:
          currentLocation == null
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: currentLocation!,
                      initialZoom: 13,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: currentLocation!,
                            width: 60,
                            height: 60,
                            child: Icon(
                              Icons.my_location,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                          Marker(
                            point: destination,
                            width: 60,
                            height: 60,
                            child: Icon(
                              Icons.location_on_rounded,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      if (routePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: routePoints,
                              color: colorScheme.primary,
                              strokeWidth: 4.0,
                            ),
                          ],
                        ),
                    ],
                  ),

                  DraggableScrollableSheet(
                    initialChildSize: 0.25,
                    minChildSize: 0.2,
                    maxChildSize:
                        widget.orderData!.outstandingQuantity != 0
                            ? 0.56
                            : 0.35,
                    builder: (context, scrollController) {
                      return ListView(
                        shrinkWrap: true,
                        controller: scrollController,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 12.0,
                                  bottom: 8,
                                ),
                                child: FloatingActionButton(
                                  onPressed: openInGoogleMaps,
                                  backgroundColor: colorScheme.primary,
                                  child: const Icon(
                                    Icons.directions,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    widget.orderData!.customer.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${AppStrings.orderDate}: ${widget.orderData!.orderDate}",
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: colorScheme.primary,
                                    child: Text(
                                      _utils.getInitials(
                                        widget.orderData!.customer.toString(),
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${AppStrings.ordered}: ${widget.orderData!.bottleQuantity} (${widget.orderData!.bottleType})",
                                      ),
                                      Text(
                                        "${AppStrings.deliveryDate}: ${widget.orderData!.deliveryDate}",
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Delivered: ${widget.orderData!.deliveredQuantity}  |  Pending: ${widget.orderData!.outstandingQuantity}",
                                      ),
                                      SizedBox(height: 8),
                                      Divider(
                                        color: colorScheme.tertiaryFixedDim,
                                      ),
                                    ],
                                  ),
                                ),
                                if (widget.orderData!.outstandingQuantity != 0)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      spacing: 20,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: MyQuantitySelectorField(
                                                label: AppStrings.deliveredQty,
                                                decreaseQuantity: () {
                                                  if (deliveredBottleQuantity >
                                                      1) {
                                                    setState(() {
                                                      deliveredBottleQuantity--;
                                                      deliveredQtyController
                                                              .text =
                                                          deliveredBottleQuantity
                                                              .toString();
                                                    });
                                                  }
                                                },
                                                increaseQuantity: () {
                                                  setState(() {
                                                    deliveredBottleQuantity++;
                                                    deliveredQtyController
                                                            .text =
                                                        deliveredBottleQuantity
                                                            .toString();
                                                  });
                                                },
                                                quantityController:
                                                    deliveredQtyController,
                                                bottleQuantity:
                                                    deliveredBottleQuantity,
                                                updateQuantity: updateQuantity,
                                              ),
                                            ),
                                            Expanded(
                                              child: MyQuantitySelectorField(
                                                label: AppStrings.receivedQty,
                                                decreaseQuantity: () {
                                                  if (receivedBottleQuantity >
                                                      1) {
                                                    setState(() {
                                                      receivedBottleQuantity--;
                                                      receivedQtyController
                                                              .text =
                                                          receivedBottleQuantity
                                                              .toString();
                                                    });
                                                  }
                                                },
                                                increaseQuantity: () {
                                                  setState(() {
                                                    receivedBottleQuantity++;
                                                    receivedQtyController.text =
                                                        receivedBottleQuantity
                                                            .toString();
                                                  });
                                                },
                                                quantityController:
                                                    receivedQtyController,
                                                bottleQuantity:
                                                    receivedBottleQuantity,
                                                updateQuantity: updateQuantity,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 55,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: PrimaryButton(
                                            text:
                                                receivedBottleQuantity > 0
                                                    ? '${AppStrings.delivered} / ${AppStrings.received}'
                                                    : AppStrings.delivered,
                                            onPressed: () async {
                                              // Handle order update
                                              if (deliveredBottleQuantity >
                                                  widget
                                                      .orderData!
                                                      .outstandingQuantity!) {
                                                dialogAlert(
                                                  context,
                                                  _utils,
                                                  "You cannot deliver more bottles than the outstanding quantity.",
                                                );
                                                return;
                                              }
                                              _utils.showProgressDialog(
                                                context,
                                              );
                                              await DeliveryOrderService()
                                                  .updateDeliveryOrder(
                                                    context,
                                                    widget.orderData!.name
                                                        .toString(),
                                                    deliveredBottleQuantity,
                                                  );
                                              if (receivedBottleQuantity > 0) {
                                                await DeliveryOrderService()
                                                    .bottleReturn(
                                                      context,
                                                      widget.orderData!.customer
                                                          .toString(),
                                                      widget.orderData!.name
                                                          .toString(),
                                                      widget
                                                          .orderData!
                                                          .waterBottleProduct
                                                          .toString(),
                                                      receivedBottleQuantity,
                                                    );
                                              }
                                              _utils.hideProgressDialog(
                                                context,
                                              );
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          MapHomeScreen(),
                                                ),
                                                (Route<dynamic> route) => false,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SafeArea(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NavigateButton(
                          icon: Icons.arrow_back_ios_rounded,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorScheme.secondary,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 12,
                            ),
                            child: Column(
                              spacing: 8,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 8,
                                  children: [
                                    Icon(
                                      Icons.my_location,
                                      color: colorScheme.primary,
                                      size: 18,
                                    ),
                                    Text(
                                      "Current Location",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.tertiary,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.inversePrimary,
                                  height: 1,
                                ),
                                Row(
                                  spacing: 8,
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                                    Text(
                                      widget.orderData!.address.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.tertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
