import 'dart:convert';
import 'package:http/http.dart' as Http;

var TOKEN =
    'ya29.A0ARrdaM_geHeaZR3Hkl0mb3MOPVBzV6QQ1Ql2DHfZpa3zmICyfKcSufxIF_ZHX6dt_Sw8c4kuGsA5IBIQial-kjW9ZDu1slgkb9cyDyjpC9Ez0UNX32KOUMJuXczAbU4xW20_jsTJW7i6GhMVwfG0GYkIeFNWbBldnrmBjPXf0_8WaLBCDrG3mn9pEqG17B5GQGzM7_vIBAkPiNMbHcfnqwogtIt3uhg7xaD_1HNNJksnVJEtCstsCtcWF66Q76XYZEd3U2Q';

class ModelService {
  Future<Map<String, dynamic>> predictDecisionTree(List<List<double>> entries) async {
    var url =
        'https://us-central1-aiplatform.googleapis.com/v1/projects/trafficanomalyflutter/locations/us-central1/endpoints/667843362711142400:predict';
    var body = json.encode({
      'instances': entries,
    });

    print('Body: $body');

    var response = await Http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${TOKEN}',
        //'accept': 'application/json',
        'Content-Type': 'application/json-patch+json',
      },
      body: body,
    );

    return json.decode(response.body);
  }
}
