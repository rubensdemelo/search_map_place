import 'dart:async';

import 'package:flutter/material.dart';

import 'package:search_map_place_v2/search_map_place_v2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String apiKEY = 'YOUR KEY HERE';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Map Place Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final _mapController = Completer();

  final CameraPosition _initialCamera = const CameraPosition(
    target: LatLng(-20.3000, -40.2990),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialCamera,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
          ),
          Positioned(
            top: 60,
            left: MediaQuery.of(context).size.width * 0.05,
            child: SearchMapPlaceWidget(
              apiKey: apiKEY,
              onSelected: (place) async {
                final geolocation = await place.geolocation;
                final GoogleMapController controller =
                    await _mapController.future;
                await controller.animateCamera(
                    CameraUpdate.newLatLng(geolocation.coordinates));
                await controller.animateCamera(
                    CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
              },
            ),
          ),
        ],
      ),
    );
  }
}
