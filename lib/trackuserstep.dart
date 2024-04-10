
// this code is for tracking user's step 


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  List<LatLng> _pathPoints = [];
  LocationData? _currentLocation;
  Location _location = Location();
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.4220, -122.0841),
          zoom: 16,
        ),
        // markers: _buildCircles(),
        circles: _buildCircles(),
        myLocationEnabled: true,
      ),
      
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Set<Circle> _buildCircles() {
    Set<Circle> circles = {};
    for (int i = 0; i < _pathPoints.length; i++) {
      circles.add(
        Circle(
          circleId: CircleId('circle_$i'),
          center: _pathPoints[i],
          radius: 1, // Adjust radius as needed
          fillColor: Color.fromARGB(255, 209, 21, 8).withOpacity(0.2),
          strokeColor: Colors.red,
        ),
      );
    }
    return circles;
  }

  void _requestLocationPermission() async {
    var permission = await _location.requestPermission();
    if (permission == PermissionStatus.granted) {
      setState(() {
        _permissionGranted = true;
      });
      _location.onLocationChanged.listen((LocationData currentLocation) {
        setState(() {
          _currentLocation = currentLocation;
          _updatePathPoints();
        });
      });
    }
  }

  void _updatePathPoints() {
    if (_currentLocation != null) {
      var newPoint = LatLng(
        _currentLocation!.latitude!,
        _currentLocation!.longitude!,
      );

      const numPoints = 100000;
      if (_pathPoints.length >= numPoints) {
        var lastPoints = _pathPoints.sublist(_pathPoints.length - numPoints);
        var avgPoint = _calculateAveragePoint(lastPoints);
        _pathPoints.add(avgPoint);
        _mapController.animateCamera(CameraUpdate.newLatLng(avgPoint));
      } else {
        _pathPoints.add(newPoint);
        _mapController.animateCamera(CameraUpdate.newLatLng(newPoint));
      }
    }
  }

  LatLng _calculateAveragePoint(List<LatLng> points) {
    double totalLat = 0;
    double totalLng = 0;
    for (var point in points) {
      totalLat += point.latitude;
      totalLng += point.longitude;
    }
    double avgLat = totalLat / points.length;
    double avgLng = totalLng / points.length;
    return LatLng(avgLat, avgLng);
  }
}
