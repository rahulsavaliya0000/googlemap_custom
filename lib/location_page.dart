import 'dart:async';
import 'dart:ui' as ui;
//this code is custom biutton in map to show distance between two place
import 'package:evmlocation/floatbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng sardarPatelVidhyabhavn = LatLng(21.2245002, 72.8885254);
  static const LatLng tapovan = LatLng(21.2240722, 72.885951);
  static const LatLng civilize = LatLng(21.2235496, 72.8887743);
  static const LatLng bhagvatiVidhyalay = LatLng(21.2207221, 72.889892);
  LatLng? _currentP;
  Map<PolylineId, Polyline> polylines = {};
  late Marker _selectedMarker =
      Marker(markerId: MarkerId("default")); // Initialize _selectedMarker
  late BitmapDescriptor customMarkerIcon; // Declare custom marker icon

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    loadCustomMarkerIcon2();
  }

  Future<BitmapDescriptor> loadCustomMarkerIcon(
      double width, double height) async {
    final Uint8List markerIconBytes = await _getMarkerIconBytes(
        'assets/image/pin.png', width.toInt(), height.toInt());
    return BitmapDescriptor.fromBytes(markerIconBytes);
  }

  Future<void> loadCustomMarkerIcon2() async {
    customMarkerIcon = await loadCustomMarkerIcon(
        170, 170); // Adjust width and height as needed
  }

// Function to load the marker icon bytes and resize it
  Future<Uint8List> _getMarkerIconBytes(
      String assetPath, int width, int height) async {
    final ByteData byteData = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(
        byteData.buffer.asUint8List(),
        targetWidth: width,
        targetHeight: height);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? Center(
              child: CupertinoActivityIndicator(
              radius: 20,
              color: Colors.black,
            ))
          : GoogleMap(
              layoutDirection: TextDirection.rtl,
              compassEnabled: false,
              mapType: MapType.terrain,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: _currentP!,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(
                    "_currentLocation",
                  ),
                  position: _currentP!,
                  icon: customMarkerIcon,
                  draggable: true,
                  infoWindow: InfoWindow(
                    title: 'Live',
                    snippet: 'Current location',
                  ),
                ),
                Marker(
                  markerId: MarkerId("sardarPatelVidhyabhavn"),
                  position: sardarPatelVidhyabhavn,
                  onTap: () {
                    _onMarkerTapped(sardarPatelVidhyabhavn);
                  },
                  icon: customMarkerIcon,
                ),
                Marker(
                  markerId: MarkerId("bhagvatiVidhyalay"),
                  position: bhagvatiVidhyalay,
                  onTap: () {
                    _onMarkerTapped(bhagvatiVidhyalay);
                  },
                  icon: customMarkerIcon,
                ),
                Marker(
                  markerId: MarkerId("civilize"),
                  position: civilize,
                  onTap: () {
                    _onMarkerTapped(civilize);
                  },
                  icon: customMarkerIcon,
                ),
                Marker(
                  markerId: MarkerId("tapovan"),
                  position: tapovan,
                  onTap: () {
                    _onMarkerTapped(tapovan);
                  },
                  icon: customMarkerIcon,
                )
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
      floatingActionButton: _selectedMarker!=''
          ? FloatingActionButtonWidget(
              selectedMarker: _selectedMarker,
              zoomInCallback: _zoomIn,
              zoomOutCallback: _zoomOut,
              launchGoogleMapsCallback: _launchGoogleMaps,
              displayDirectionsCallback: _displayDirections,
            )
          : null,
    );
  }

  Future<void> getLocationUpdates() async {
    try {
      final LocationData locationData = await _locationController.getLocation();
      setState(() {
        _currentP = LatLng(locationData.latitude!, locationData.longitude!);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _zoomIn() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _zoomOut() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.zoomOut());
  }

  void _onMarkerTapped(LatLng position) {
    setState(() {
      _selectedMarker = Marker(
        markerId: MarkerId(position.toString()),
        position: position,
      );
    });
  }

  void _launchGoogleMaps(LatLng position) async {
    final url =
        "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _displayDirections(LatLng destination) async {
    final String currentLatitude = _currentP!.latitude.toString();
    final String currentLongitude = _currentP!.longitude.toString();

    final googleMapsURL =
        "https://www.google.com/maps/dir/?api=1&origin=$currentLatitude,$currentLongitude&destination=${destination.latitude},${destination.longitude}";

    print('Google Maps URL: $googleMapsURL');
    if (await canLaunch(googleMapsURL)) {
      await launch(googleMapsURL);
    } else {
      throw 'Could not launch $googleMapsURL';
    }
  }
}
