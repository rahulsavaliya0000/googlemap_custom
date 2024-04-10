import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
       // this code is for custom buttons in map
class FloatingActionButtonWidget extends StatelessWidget {
  final Marker selectedMarker;
  final VoidCallback zoomInCallback;
  final VoidCallback zoomOutCallback;
  final Function(LatLng) launchGoogleMapsCallback;
  final Function(LatLng) displayDirectionsCallback;

  const FloatingActionButtonWidget({
    Key? key,
    required this.selectedMarker,
    required this.zoomInCallback,
    required this.zoomOutCallback,
    required this.launchGoogleMapsCallback,
    required this.displayDirectionsCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.grey.withOpacity(.40),
              onPressed: zoomInCallback,
              child: Image(
                image: AssetImage(
                    'assets/image/zoomin.png'), // Change the path accordingly
                width: 44, // Adjust the width as needed
                height: 40, // Adjust the height as needed
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              // duration: Duration(milliseconds: 300),
              height: selectedMarker != null ? 56.0 : 0.0,
              width: selectedMarker != null ? 56.0 : 0.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {
                  launchGoogleMapsCallback(selectedMarker.position);
                },
                child: Image.asset('assets/image/location.png'),
                backgroundColor: Colors.black.withOpacity(.5),
                elevation: 0,
              ),
            ),
            SizedBox(width: 10),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: selectedMarker != null ? 56.0 : 0.0,
              width: selectedMarker != null ? 56.0 : 0.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(90),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  // shape: ,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black54, // Change color as needed
                    width: 1, // Adjust width as needed
                  ),
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    displayDirectionsCallback(selectedMarker.position);
                  },
                  backgroundColor: Colors.blue.shade500.withOpacity(.4),
                  elevation: 0,
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: SvgPicture.asset(
                        'assets/image/maps.svg',
                        width: 40, // Adjust width as needed
                        height: 44, // Adjust height as needed
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              onPressed: zoomOutCallback,
              backgroundColor: Colors.grey.withOpacity(.40),
              child: Image(
                image: AssetImage(
                    'assets/image/zoomout.png'), // Change the path accordingly
                width: 40, // Adjust the width as needed
                height: 40, // Adjust the height as needed
              ),
            ),
          ],
        ),
      ],
    );
  }
}
