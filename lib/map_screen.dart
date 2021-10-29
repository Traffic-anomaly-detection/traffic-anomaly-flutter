import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);
  final LatLng _center = const LatLng(13.729273, 100.775390);
  final accident = const ['Accident 1', 'Accident 2', 'Accident 3'];
  @override
  Widget build(BuildContext context) {
    late GoogleMapController mapController;

    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search from',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    )),
                SizedBox(height: 10),
                Divider(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  thickness: 3,
                ),
                SizedBox(height: 10),
                Text(
                  'Latest events',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                      itemCount: accident.length,
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemBuilder: (context, index) {
                        return ListTile(
                          dense: true,
                          visualDensity: VisualDensity(vertical: -4),
                          leading: FaIcon(FontAwesomeIcons.car),
                          title: Text(accident[index].toString()),
                          trailing: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).primaryColor),
                            child: Text(
                              'Jump',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {},
                          ),
                        );
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total : '),
                    Text(accident.length.toString())
                  ],
                )
              ],
            ),
          ),
        ),
        Flexible(
          flex: 7,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
        )
      ],
    );
  }
}
