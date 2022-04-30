class Accident {
  int? accidentId;
  int? roadNo;
  int? km;
  String? direction;
  double? lat;
  double? lon;
  DateTime? dateTime;
  DateTime? timeStamp;

  Accident(
      {this.accidentId,
      this.roadNo,
      this.km,
      this.lat,
      this.lon,
      this.dateTime,
      this.timeStamp});

  Accident.fromJson(Map<String, dynamic> json) {
    accidentId = json['accident_id'];
    roadNo = json['road_no'];
    km = json['km'];
    direction = json['direction'];
    lat = json['lat'];
    lon = json['lon'];
    dateTime = DateTime.parse(json['date_time'].toString());
    timeStamp = DateTime.parse(json['time_stamp'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accident_id'] = this.accidentId;
    data['road_no'] = this.roadNo;
    data['km'] = this.km;
    data['direction'] = this.direction;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['date_time'] = this.dateTime;
    data['time_stamp'] = this.timeStamp;
    return data;
  }
}
