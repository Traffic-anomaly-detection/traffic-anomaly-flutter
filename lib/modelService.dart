import 'dart:convert';
import 'dart:developer';
import 'dart:html';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as Http;
import 'package:csv/csv.dart' as csv;
import 'package:http/retry.dart';
import 'package:retry/retry.dart';

class ModelService {
  String getJWT() {
    var now = (DateTime.now().millisecondsSinceEpoch) ~/
        Duration.millisecondsPerSecond;
    final jwt = JWT({
      "iss":
          "online-prediction-service-701@trafficanomalyflutter.iam.gserviceaccount.com",
      "scope": "https://www.googleapis.com/auth/cloud-platform",
      "aud": "https://oauth2.googleapis.com/token",
      "exp": now,
      "iat": now + 3600
    }, header: {
      "alg": "RS256",
      "typ": "JWT"
    });
    var token = jwt.sign(
        RSAPrivateKey(
            '-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC2WFsc2NTezbzj\nC6h46IjTJqtbF8ybzxSWtFSRWaB8u+BiNvtbw1b9UdQQdi0eYxx9tgYGPuOm+PxI\nCUPqgpvnr9ezLxchyjHjoGsgRUEwyMVBsbRah4xgYReSaU/o7B7tPsT2VpcYcIzL\nK3cdRJU8iH7R4+6OlmUXmZdW82m2QUz6fPMNFhu07SYalbmlUtuR6+g06Zx2/MI/\nIel3YUBk91Sjx2PGssSvmrWSGdx5tZaMXL2kXG1m/G30A1gUnTG0SS4p3oZjrMa2\nWXiTFE6xchgpBy2QKULwM/rIyr43550SptQNum5ydNOsYaNtwT9uAZFnUdw3ns3D\nFRyx7IepAgMBAAECggEAAndZOh+Jgi3eNUHbDuKlURnpzjp7MQvR6ARdVOmZqjFr\nDOmLjxEubyoJAt+nGpnkmT0iY5/voA/KM3ONj/w7Aa41+sk/8csRNcVQ0VWquMSS\n651CDzAgX2a7+UPqia7kAMqK/mSJUf0M6JJaimwDoBt7xAWqfmfF08CaVJWMQCf0\nxE6wso7adXDHTx+ffVJ+VFa8Cpdwvvsbr1oFE/YfCZSDlqyh+/aGeD1ur16iqjEg\nkP9GOXWX2m+mNNan6E3ow6Jgb8bsAxefbux6BVRZNkvVwRERPyltDP/+s+fNhKAo\nTWQQhNhgYJX4GmCtTGH1jdJPzkNLTcsykpJ9qTRZlQKBgQDv7aXCi88P0YD4rIuu\ng9LdyawctBZM6Mrsp50VwhCthXWS+CUbvSTjDS+WVF4YwZ6k9xfsSCdbYfQCFZzt\nZZWSPQDUrveIl7mOWHBlWLdYzX41mgpt7VphWVzd0oIGbjDTOF7YybR0NNj2z05Y\nwhKFyFehZvwuRpQIN+mIREjcRQKBgQDCj0Hit94yf/B89YICHc2g/wYIdGgo1XGj\nb7z2waby394SD3YOgbyVM0DYzH5AaVjFiqDytV+iFM+g04v2t5LoZLRyVNp4Ocao\njYh0NIYEkscKq2Z/sZf6lB32l80+O3mvxfLYjWDu2SQdMC69opeiL8F3zeD/oGKx\nC+twZS7+FQKBgCIKI2RQlZX28UdWo5Kk3TveKu7/ldJfjLq6pQy7NcaIkr/BOPKQ\niTU1X7UCTz9P6QQakmhRbFQIt6e8DUGZEflnckC6eiAE9qx9W6TlS03sCaXtLuGd\ntR7uoMBP52amJ4MwEjTLmTCLduS9UK5DCoG0hMo/ZDPki4gG9rkAhx3JAoGANQJT\nMTJnl9rD60f45Bq6q+LQAf21Y2rES4NmONUKZ6IXH1SXFdzDRONyB5+vxlztkuTy\ndS51n/OLnoYE3HOn0ymdAImd/KPBPKtTQlYNLbHQCVgp1SDOB7fTchxqD0qlHP8R\n626ZunnvHQTDt2dVaRsZ20p8wykvuo1E2Jq48wECgYEAqN4IsZFLnHP/8hcf42tS\ng3EQUv93iZzQuNlpii4XcbcUuBj1tS8vG+XYdxbGHesdFuFqvzxg6w2EGB/F1abT\nsbOWgm732hN0r7ghfgGbc2Dyo/bjgv/BZsaJUQuKlO/5FiCZFMq9TRqXcxDfzw0H\niL4hECTp1k614+FxoAnzcfE=\n-----END PRIVATE KEY-----\n'),
        algorithm: JWTAlgorithm.RS256);

    return token;
  }

  Future<String> getToken() async {
    print('Requesting Token .....');

    var jwt = getJWT();
    var data =
        'grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=${jwt}';

    final client = RetryClient(
      Http.Client(),
      when: ((response) {
        return response.statusCode != 200;
      }),
      onRetry: (p0, p1, retryCount) {
        print('request token failed');
        print('retrying.....');
        jwt = getJWT();
        data =
            'grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=${jwt}';
      },
      retries: 8,
    );
    // late final res;
    var url = Uri.parse('https://oauth2.googleapis.com/token');

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var res = await client.post(url, headers: headers, body: data);

    Map result = json.decode(res.body);
    //print('current token        : ' + result['access_token']);
    //print('expire in (seconds)  : ' + result['expires_in'].toString());
    print('REQUEST TOKEN SUCCESSFULLY');
    return result['access_token'];
  }

  Future<Map<String, dynamic>> predictDecisionTree(
      String token, List<List> entries, int road, String direction) async {
    //var token = await getToken();

    var url = '';

    if (road == 1) {
      if (direction == 'in') {
        url =
            'https://us-central1-aiplatform.googleapis.com/v1/projects/trafficanomalyflutter/locations/us-central1/endpoints/1586648055438901248:predict';
      } else if (direction == 'out') {
        url =
            'https://us-central1-aiplatform.googleapis.com/v1/projects/trafficanomalyflutter/locations/us-central1/endpoints/6942553912289263616:predict';
      } else {
        return {};
      }
    } else if (road == 2) {
      if (direction == 'in') {
        url =
            'https://us-central1-aiplatform.googleapis.com/v1/projects/trafficanomalyflutter/locations/us-central1/endpoints/8369069094258868224:predict';
      } else if (direction == 'out') {
        url =
            'https://us-central1-aiplatform.googleapis.com/v1/projects/trafficanomalyflutter/locations/us-central1/endpoints/1717252444632645632:predict';
      } else {
        return {};
      }
    } else if (road == 7) {
      if (direction == 'in') {
        url =
            'https://us-central1-aiplatform.googleapis.com/v1/projects/trafficanomalyflutter/locations/us-central1/endpoints/4023095453846339584:predict';
      } else if (direction == 'out') {
        url =
            'https://us-central1-aiplatform.googleapis.com/v1/projects/trafficanomalyflutter/locations/us-central1/endpoints/3326163411510755328:predict';
      } else {
        return {};
      }
    } else {}

    var body = json.encode({
      'instances': entries,
    });

    //print('Body: $body');

    var response = await Http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${token}',
        //'accept': 'application/json',
        'Content-Type': 'application/json-patch+json',
      },
      body: body,
    );
    //print('body: ' + body);
    return json.decode(response.body);
  }

  Future<List<List>> getCurrentCellData() async {
    var csvfile = await Http.get(Uri.parse(
        'http://analytics2.dlt.transcodeglobal.com/cell_data/current_celldata.csv'));
    csv.CsvToListConverter converter = new csv.CsvToListConverter(eol: '\n');
    List<List> listCreated =
        converter.convert(csvfile.body, shouldParseNumbers: true);

    // the csv file is converted to a 2-Dimensional list

    return listCreated;
  }

  List<List> filterRoad(List<List> celldata, int roadNo, String direction) {
    var filteredRoad = [...celldata];

    filteredRoad.removeWhere((element) => element.elementAt(1) != roadNo);
    filteredRoad.removeWhere((element) => element.elementAt(3) != direction);
    return filteredRoad;
  }

  List<List> getPredictableList(List<List> list) {
    var tempList = [...list];
    List<List> newList = [];
    // [
    //   'all_units',
    //   'inflow_units',
    //   'avg_speed',
    //   'max_speed',
    //   'avg_traveltime',
    //   "max_traveltime"
    // ];
    tempList.forEach((List element) {
      element.removeRange(0, 4);
      element.removeRange(2, 4);
      newList.add(element);
    });
    return newList;
  }

  Future<List<List>> getRoadData() async {
    final _rawData = await rootBundle.loadString("assets/csv/road1.csv");

    csv.CsvToListConverter converter = new csv.CsvToListConverter(eol: '\n');
    List<List> roadData = converter.convert(_rawData, shouldParseNumbers: true);

    // print('road data : ' + roadData.toString());

    return roadData;
  }
}



// class RequestJWTErrorException implements Exception {
//   String cause;
//   RequestJWTErrorException(this.cause);
// }
