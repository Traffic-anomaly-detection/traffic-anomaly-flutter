import 'dart:developer';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:csv/csv.dart' as csv;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traffic_anomaly_app/accident.dart';
import 'package:traffic_anomaly_app/modelService.dart';
import 'accidentService.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _center = const LatLng(13.729273, 100.775390);
  var myMarker = <Marker>[];
  String _selectedRoad = 'Show All';
  bool _isSelectRealtime = true;
  bool _isShowInfo = false;
  late Future<List<Accident>> accidents;

  late List<List> roadData;

  late List<List> road1in;
  late List<List> road1out;
  late List<List> road2in;
  late List<List> road2out;
  late List<List> road7in;
  late List<List> road7out;

  final screens = [];

  @override
  void initState() {
    super.initState();
    loadRoadData();
    getCurrentCellData().whenComplete(() => predictAccident());
    getAllAccident();
  }

  Future<void> loadRoadData() async {
    print('Start loading road coordinates .....');

    roadData = await ModelService().getRoadData();

    print('Loading road data complete\n\n\n');
  }

  Future<void> getCurrentCellData() async {
    print('Start loading current cell data .....');
    var currentCellData = await ModelService().getCurrentCellData();
    road1in = ModelService().filterRoad(currentCellData, 1, 'in');
    road1out = ModelService().filterRoad(currentCellData, 1, 'out');
    road2in = ModelService().filterRoad(currentCellData, 2, 'in');
    road2out = ModelService().filterRoad(currentCellData, 2, 'out');
    road7in = ModelService().filterRoad(currentCellData, 7, 'in');
    road7out = ModelService().filterRoad(currentCellData, 7, 'out');

    road1in = ModelService().getPredictableList(road1in);
    road1out = ModelService().getPredictableList(road1out);
    road2in = ModelService().getPredictableList(road2in);
    road2out = ModelService().getPredictableList(road2out);
    road7in = ModelService().getPredictableList(road7in);
    road7out = ModelService().getPredictableList(road7out);

    print('Loading current cell data complete\n\n\n');
    //var entries = ModelService().getPredictableList(currentCellData);
    //print("current cell data : " + currentCellData.toString());
    //print("entries : " + road7out.toString());
    // log("entries length : " + entries.length.toString());
  }

  void predictAccident() async {
    //var currentCellData = await getCurrentCellData();
    var token = await ModelService().getToken();
    var predictedroad1in =
        await ModelService().predictDecisionTree(token, road1in, 1, 'in');
    var predictedroad1out =
        await ModelService().predictDecisionTree(token, road1out, 1, 'out');
    var predictedroad2in =
        await ModelService().predictDecisionTree(token, road2in, 2, 'in');
    var predictedroad2out =
        await ModelService().predictDecisionTree(token, road2out, 2, 'out');
    var predictedroad7in =
        await ModelService().predictDecisionTree(token, road7in, 7, 'in');
    var predictedroad7out =
        await ModelService().predictDecisionTree(token, road7out, 7, 'out');
    print('predict result 1 in: ' + predictedroad1in.toString());
    print('predict result 1 out: ' + predictedroad1out.toString());
    print('predict result 2 in: ' + predictedroad2in.toString());
    print('predict result 2 out: ' + predictedroad2out.toString());
    print('predict result 7 in: ' + predictedroad7in.toString());
    print('predict result 7 out: ' + predictedroad7out.toString());
  }

  void getAllAccident() async {
    accidents = AccidentService().getAllAccident();
  }

  @override
  Widget build(BuildContext context) {
    late GoogleMapController mapController;

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'twitter',
      (int uid) {
        IFrameElement _iFrame = IFrameElement()..src = "web/twitter.html";
        _iFrame.style.border = "none";
        return _iFrame;
      },
    );

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
                      child: FutureBuilder(
                          future: accidents,
                          builder: (context,
                              AsyncSnapshot<List<Accident>> snapshot) {
                            if (snapshot.hasData) {
                              List<Accident> accidentList = snapshot.data!;
                              return Column(
                                children: [
                                  Divider(
                                    color: Color(0xff868EF2),
                                    thickness: 3,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: accidentList.length,
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
                                            title: Text(
                                              accidentList[index]
                                                  .accidentId
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
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
                                                      accidentList[index].lat!,
                                                      accidentList[index]
                                                          .lon!));
                                                },
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
                                          accidentList.length.toString(),
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
                            accidentList.forEach((element) {
                              myMarker.add(Marker(
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
                Offstage(
                    offstage: _isSelectRealtime,
                    child: Container(
                      padding: EdgeInsets.all(40),
                      color: Theme.of(context).accentColor,
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
