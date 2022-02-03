import 'dart:convert';
import 'dart:developer';

import 'package:traffic_anomaly_app/accident.dart';
import 'package:http/http.dart' as Http;

class AccidentService {
  Future<List<Accident>> getAllAccident() async {
    var url = 'https://tad-backend-db.herokuapp.com/api/accident';
    var response = await Http.get(Uri.parse(url));
    List<Accident> accidents = [];
    if (response.statusCode == 200) {
      List a = json.decode(response.body);

      a.forEach((e) {
        accidents.add(Accident.fromJson(e));
      });
    } else {
      log('ERROR : Cannot get accident');
    }

    // List<Accident> accidents = map.entries.map((e) => {
    //   Accident.fromJson(e)
    // }).toList() ;

    return accidents;
  }
}
