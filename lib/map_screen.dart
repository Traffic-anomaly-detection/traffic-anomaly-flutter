import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _center = const LatLng(13.729273, 100.775390);
  String _selectedRoad = 'Show All';
  bool _isSelectRealtime = true;
  bool _isShowInfo = false;
  final accident = const [
    'Accident 1',
    'Accident 2',
    'Accident 3',
    'Accident 4',
    'Accident 5',
    'Accident 6',
    'Accident 7'
  ];

  @override
  Widget build(BuildContext context) {
    late GoogleMapController mapController;

    List<DropdownMenuItem<String>> roadItems = [
      'Show All',
      'Road Number 1',
      'Road Number 2',
    ].map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      );
    }).toList();

    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'KMITL\'s Traffic Anomaly Detection',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      InkWell(
                        onTap: () {},
                        onHover: (value) {
                          setState(() => _isShowInfo = value);
                        },
                        child: FaIcon(
                          FontAwesomeIcons.infoCircle,
                          size: 14,
                          color: Color(0xff868EF2),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 10),
                  Divider(
                    color: Theme.of(context).accentColor,
                    thickness: 3,
                  ),
                  // Container(
                  //     decoration: BoxDecoration(
                  //         border: Border.all(
                  //             color: Theme.of(context).primaryColor, width: 3),
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Container(
                  //       margin: EdgeInsets.symmetric(horizontal: 10),
                  //       child: TextField(
                  //         decoration: InputDecoration(border: InputBorder.none),
                  //       ),
                  //     )),
                  // SizedBox(height: 10),
                  // Container(
                  //   padding: EdgeInsets.all(5),
                  //   decoration: BoxDecoration(
                  //       color: Theme.of(context).primaryColor,
                  //       borderRadius: BorderRadius.circular(3)),
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Center(
                  //       child: Text(
                  //     'Search',
                  //     style: TextStyle(color: Colors.white),
                  //   )),
                  // ),
                  SizedBox(height: 10),
                  Text(
                    'Road Number',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff868EF2),
                        fontWeight: FontWeight.normal),
                  ),

                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Theme.of(context).accentColor,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _selectedRoad,
                          isExpanded: true,
                          isDense: true,
                          icon: FaIcon(
                            FontAwesomeIcons.arrowDown,
                            color: Color(0xff868EF2),
                            size: 16,
                          ),
                          items: roadItems,
                          onChanged: (value) {
                            setState(() {
                              _selectedRoad = value as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Divider(
                  //   color: Theme.of(context).primaryColor.withOpacity(0.5),
                  //   thickness: 3,
                  // ),
                  // SizedBox(height: 10),
                  Text(
                    'Prediction Result',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff868EF2),
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Divider(
                            color: Color(0xff868EF2),
                            thickness: 3,
                          ),
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: accident.length,
                                // separatorBuilder: (context, index) {
                                //   return Divider();
                                // },
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    // dense: true,
                                    visualDensity: VisualDensity(vertical: -4),
                                    leading: FaIcon(FontAwesomeIcons.car),
                                    title: Text(
                                      accident[index].toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    trailing: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          backgroundColor: Color(0xff868EF2),
                                        ),
                                        child: Text(
                                          'Jump',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          Divider(
                            color: Color(0xff868EF2),
                            thickness: 3,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  accident.length.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isSelectRealtime = false;
                            });
                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: _isSelectRealtime
                                  ? Theme.of(context).accentColor
                                  : Color(0xff868EF2),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                            ),
                            child: Center(
                              child: Text(
                                'Accident History',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isSelectRealtime = true;
                            });
                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: _isSelectRealtime
                                  ? Color(0xff868EF2)
                                  : Theme.of(context).accentColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                            ),
                            child: Center(
                              child: Text(
                                'Real-time Prediction',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 7,
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                //mapType: MapType.satellite,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),
              Builder(builder: (context) {
                if (_isShowInfo) {
                  return Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    height: 300,
                    width: 300,
                    child: Center(
                      child: Text(
                        'ToolTip',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
            ],
          ),
        )
      ],
    );
  }
}
