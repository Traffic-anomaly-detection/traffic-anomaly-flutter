import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:traffic_anomaly_app/accident.dart';
import 'accidentService.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _center = const LatLng(13.729273, 100.775390);

  String _selectedRoad = 'Show All';
  String _selectedDirection = 'Show All';
  bool _isSelectRealtime = true;
  bool _isShowInfo = false;
  Future<List<Accident>>? accidents;

  final screens = [];

  @override
  void initState() {
    super.initState();
    getAccident();
  }

  void onChangeRoad(String value) {
    setState(() {
      _selectedRoad = value;
    });
  }

  void onChangeDirection(String value) {
    setState(() {
      _selectedDirection = value;
    });
  }

  void getAccident([int? value]) async {
    if (value == null) {
      setState(() {
        accidents = AccidentService().getAllAccident();
      });
    } else {
      setState(() {
        accidents = AccidentService().getNAccident(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    late GoogleMapController mapController;
    var myMarker = <Marker>[];
    var beforeMin =
        DateTime.now().subtract(Duration(minutes: 5)).add(Duration(hours: 7));

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'twitter',
      (int uid) {
        IFrameElement _iFrame = IFrameElement()
          ..src = "web/twitter.html"
          ..style.width = '100%'
          ..style.height = '100%';

        _iFrame.style.border = "none";
        return _iFrame;
      },
    );

    List<DropdownMenuItem<String>> roadItems = [
      'Show All',
      'Road Number 1',
      'Road Number 2',
      'Road Number 7',
    ].map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      );
    }).toList();

    List<DropdownMenuItem<String>> directionItems = [
      'Show All',
      'In',
      'Out',
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

    void _gotoThisPosition(LatLng position) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 11.0,
          ),
        ),
      );
    }

    List<Accident> filterResult(List<Accident> accidentList,
        String selectedRoad, String selectedDirection) {
      List<Accident> newList = [];
      print(accidentList.length.toString());
      newList = accidentList
          .where((element) => element.dateTime!.isAfter(beforeMin))
          .toList();
      // print(accidentList[0].dateTime!.isUtc.toString());
      // print(beforeMin.isUtc.toString());

      // print(accidentList[0].dateTime!.toString());
      // print(beforeMin.toUtc().toString());
      // // print(accidentList[100].dateTime!.timeZoneName);
      // // print(accidentList.length.toString());
      // print(newList.length.toString());

      if (selectedRoad == 'Show All') {
        if (selectedDirection == 'Show All') {
          return newList;
        } else {
          newList = newList
              .where((element) =>
                  element.direction.toString() ==
                  selectedDirection.toLowerCase())
              .toList();
        }
      } else {
        newList = newList.where((element) {
          if (selectedDirection == 'Show All') {
            if (('Road Number ' + element.roadNo.toString()) == _selectedRoad) {
              return true;
            } else {
              return false;
            }
          } else {
            if (element.direction.toString() ==
                    selectedDirection.toLowerCase() &&
                ('Road Number ' + element.roadNo.toString()) == _selectedRoad) {
              return true;
            } else {
              return false;
            }
          }
        }).toList();
      }

      return newList;
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
                            onChangeRoad(value as String);
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Road direction',
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
                          value: _selectedDirection,
                          isExpanded: true,
                          isDense: true,
                          icon: FaIcon(
                            FontAwesomeIcons.arrowDown,
                            color: Color(0xff868EF2),
                            size: 16,
                          ),
                          items: directionItems,
                          onChanged: (value) {
                            onChangeDirection(value as String);
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
                      child: FutureBuilder(
                          future: accidents,
                          builder: (context,
                              AsyncSnapshot<List<Accident>> snapshot) {
                            if (snapshot.hasData) {
                              List<Accident> accidentList = snapshot.data!;
                              List<Accident> showList = filterResult(
                                  accidentList,
                                  _selectedRoad,
                                  _selectedDirection);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Result after : ',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          child: Text(
                                            '${DateFormat('yyyy-MM-dd - kk:mm').format(beforeMin.subtract(Duration(hours: 7)))}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Color(0xff868EF2),
                                    thickness: 3,
                                  ),
                                  if (showList.isEmpty) ...[
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Anomaly Not found !',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24),
                                        ),
                                      ),
                                    )
                                  ] else ...[
                                    Expanded(
                                      child: ListView.separated(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: showList.length,
                                        // separatorBuilder: (context, index) {
                                        //   return Divider();
                                        // },
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            // dense: true,
                                            visualDensity:
                                                VisualDensity(vertical: -4),
                                            leading:
                                                FaIcon(FontAwesomeIcons.car),
                                            contentPadding: EdgeInsets.zero,
                                            title: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'Road No. ${showList[index].roadNo} at Km. ${showList[index].km}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color:
                                                            Color(0xff868EF2)),
                                                    child: Text(
                                                      showList[index]
                                                          .dateTime
                                                          .toString()
                                                          .substring(0, 16),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            trailing: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  backgroundColor:
                                                      Color(0xff868EF2),
                                                ),
                                                child: Text(
                                                  'Jump',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                                onPressed: () {
                                                  _gotoThisPosition(LatLng(
                                                      showList[index].lat!,
                                                      showList[index].lon!));
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider();
                                        },
                                      ),
                                    ),
                                  ],
                                  Divider(
                                    color: Color(0xff868EF2),
                                    thickness: 3,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                          showList.length.toString(),
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
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: InkWell(
                  //         onTap: () {
                  //           setState(() {
                  //             _isSelectRealtime = false;
                  //           });
                  //         },
                  //         child: Container(
                  //           height: 50,
                  //           padding: EdgeInsets.symmetric(
                  //               vertical: 10, horizontal: 15),
                  //           decoration: BoxDecoration(
                  //             color: _isSelectRealtime
                  //                 ? Theme.of(context).accentColor
                  //                 : Color(0xff868EF2),
                  //             borderRadius: BorderRadius.only(
                  //                 topLeft: Radius.circular(10),
                  //                 bottomLeft: Radius.circular(10)),
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               'Anomaly News',
                  //               textAlign: TextAlign.center,
                  //               style: TextStyle(color: Colors.white),
                  //               maxLines: 2,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: InkWell(
                  //         onTap: () {
                  //           setState(() {
                  //             _isSelectRealtime = true;
                  //           });
                  //         },
                  //         child: Container(
                  //           height: 50,
                  //           padding: EdgeInsets.symmetric(
                  //               vertical: 10, horizontal: 15),
                  //           decoration: BoxDecoration(
                  //             color: _isSelectRealtime
                  //                 ? Color(0xff868EF2)
                  //                 : Theme.of(context).accentColor,
                  //             borderRadius: BorderRadius.only(
                  //                 topRight: Radius.circular(10),
                  //                 bottomRight: Radius.circular(10)),
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               'Real-time Prediction',
                  //               maxLines: 2,
                  //               textAlign: TextAlign.center,
                  //               style: TextStyle(color: Colors.white),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 30,
                  // )
                ],
              ),
            ),
          ),
        ),
        Flexible(
            flex: 7,
            child: Stack(
              children: [
                Stack(
                  children: [
                    Offstage(
                      offstage: !_isSelectRealtime,
                      child: FutureBuilder(
                        future: accidents,
                        builder:
                            (context, AsyncSnapshot<List<Accident>> snapshot) {
                          if (snapshot.hasData) {
                            List<Accident> accidentList = snapshot.data!;
                            List<Accident> showList = filterResult(accidentList,
                                _selectedRoad, _selectedDirection);
                            showList.forEach((element) {
                              myMarker.add(Marker(
                                infoWindow: InfoWindow(
                                    title: 'Anomaly on road ' +
                                        element.roadNo.toString() +
                                        ' at km. ' +
                                        element.km.toString(),
                                    snippet: 'Location at ' +
                                        element.lat.toString() +
                                        ', ' +
                                        element.lon.toString() +
                                        '\n\n , Detected at ' +
                                        element.dateTime
                                            .toString()
                                            .substring(0, 16)),
                                markerId:
                                    MarkerId(element.accidentId.toString()),
                                position: LatLng(element.lat!, element.lon!),
                                onTap: () {
                                  setState(() {});
                                },
                              ));
                            });
                            return GoogleMap(
                              onMapCreated: _onMapCreated,
                              trafficEnabled: false,
                              //mapType: MapType.satellite,
                              initialCameraPosition: CameraPosition(
                                target: _center,
                                zoom: 11.0,
                              ),
                              markers: myMarker.toSet(),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
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
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    'Disclaimer : This application is a graduation projects of the students of King Mongkut\'s Institute of Technology Ladkrabang. This only for educational purpose and in still on beta state. The result of this program only a prediction of machine learning model. ',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
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
                Offstage(
                    offstage: _isSelectRealtime,
                    child: Container(
                      padding: EdgeInsets.all(40),
                      color: Colors.black12,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          const Radius.circular(40.0),
                        ),
                        child: HtmlElementView(
                          viewType: "twitter",
                        ),
                      ),
                    ))
              ],
            ))
      ],
    );
  }
}
