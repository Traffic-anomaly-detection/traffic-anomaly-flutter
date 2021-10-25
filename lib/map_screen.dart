import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);
  final LatLng _center = const LatLng(13.729273, 100.775390);
  @override
  Widget build(BuildContext context) {
    late GoogleMapController mapController;

    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Material(
                  elevation: 10,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                  ),
                ),
                const SizedBox(
                  height: 20,
                  width: 0,
                ),
                Material(
                  elevation: 10,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Container(
                      width: 300,
                      height: 600,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ))),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
