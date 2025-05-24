import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../api/services/delivery_order_service.dart';
import '../../models/delivery_order.dart';
import '../../utils/strings.dart';
import '../../widgets/my_drawer.dart';
import '../../widgets/navigate_button.dart';
import 'order_details_screen.dart';

class MapHomeScreen extends StatefulWidget {
  const MapHomeScreen({super.key});

  @override
  State<MapHomeScreen> createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen> {
  final MapController _mapController = MapController();
  List<DeliveryOrder> _deliveryOrder = [];
  bool isLoadingDeliveryOrder = true;

  @override
  void initState() {
    super.initState();
    fetchDeliveryOrders();
  }

  Future<void> fetchDeliveryOrders() async {
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
    isLoadingDeliveryOrder = true;
    _deliveryOrder = await DeliveryOrderService().getDeliveryOrders(context);
    isLoadingDeliveryOrder = false;
    setState(() {});
    fitMapToAllMarkers();
  }

  void fitMapToAllMarkers() {
    if (_deliveryOrder.isEmpty) return;

    double? minLat, maxLat, minLng, maxLng;

    for (var order in _deliveryOrder) {
      final lat = double.parse(order.latitude.toString());
      final lng = double.parse(order.longitude.toString());

      minLat = (minLat == null || lat < minLat) ? lat : minLat;
      maxLat = (maxLat == null || lat > maxLat) ? lat : maxLat;
      minLng = (minLng == null || lng < minLng) ? lng : minLng;
      maxLng = (maxLng == null || lng > maxLng) ? lng : maxLng;
    }

    final centerLat = (minLat! + maxLat!) / 2;
    final centerLng = (minLng! + maxLng!) / 2;

    final bounds = LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));

    _mapController.move(bounds.center, _getFitZoomLevel(bounds));
  }

  double _getFitZoomLevel(LatLngBounds bounds) {
    final latDiff = (bounds.north - bounds.south).abs();
    final lngDiff = (bounds.east - bounds.west).abs();

    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

    if (maxDiff < 0.01) return 16;
    if (maxDiff < 0.05) return 14;
    if (maxDiff < 0.1) return 12;
    if (maxDiff < 0.5) return 10;
    if (maxDiff < 1.0) return 8;
    return 6;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      drawer: MyDrawer(),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(24.89, 66.87),
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers:
                    _deliveryOrder.map((order) {
                      return Marker(
                        width: 100.0,
                        height: 70.0,
                        point: LatLng(
                          double.parse(order.latitude.toString()),
                          double.parse(order.longitude.toString()),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              child: Text(
                                '${order.outstandingQuantity} ${AppStrings.bottle}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.location_on_rounded,
                              color: colorScheme.primary,
                              size: 30,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder:
                (_, controller) => Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(blurRadius: 6, color: Colors.black26),
                    ],
                  ),
                  child:
                      isLoadingDeliveryOrder
                          ? Center(
                            child: CircularProgressIndicator(
                              color: colorScheme.primary,
                            ),
                          )
                          : _deliveryOrder.isEmpty
                          ? Center(
                            child: Text(
                              AppStrings.noOrdersFound,
                              style: TextStyle(
                                color: colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          : ListView.builder(
                            controller: controller,
                            itemCount: _deliveryOrder.length,
                            itemBuilder: (context, index) {
                              final order = _deliveryOrder[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(order.item.toString()),
                                      subtitle: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_rounded,
                                            color: colorScheme.tertiaryFixedDim,
                                            size: 18,
                                          ),
                                          Text(
                                            order.address.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  colorScheme.tertiaryFixedDim,
                                            ),
                                          ),
                                        ],
                                      ),
                                      leading: Icon(
                                        Icons.local_shipping,
                                        color: colorScheme.primary,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => OrderDetailsScreen(
                                                  orderData: order,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                    Divider(
                                      color: colorScheme.tertiaryFixedDim,
                                      height: 1,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                ),
          ),
          SafeArea(
            child: Builder(
              builder: (context) {
                return NavigateButton(
                  icon: Icons.menu,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
