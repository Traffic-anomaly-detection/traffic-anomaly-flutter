import 'dart:convert';
import 'dart:developer';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as Http;

class ModelService {
  String getJWT() {
    var now = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
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
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var jwt = getJWT();

    var data =
        'grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=${jwt}';

    var url = Uri.parse('https://oauth2.googleapis.com/token');
    var res = await Http.post(url, headers: headers, body: data);
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    //print(res.body);
    Map result = json.decode(res.body);
    log('current token        : ' + result['access_token']);
    log('expire in (seconds)  : ' + result['expires_in'].toString());
    return result['access_token'];
  }

  Future<Map<String, dynamic>> predictDecisionTree(
      List<List<double>> entries) async {
    //var token = await getToken();
    var token = await getToken();

    var url =
        'https://us-central1-aiplatform.googleapis.com/v1/projects/trafficanomalyflutter/locations/us-central1/endpoints/667843362711142400:predict';
    var body = json.encode({
      'instances': entries,
    });

    print('Body: $body');

    var response = await Http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${token}',
        //'accept': 'application/json',
        'Content-Type': 'application/json-patch+json',
      },
      body: body,
    );

    return json.decode(response.body);
  }
}
