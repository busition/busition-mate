import 'DayTime.dart';

class DepartureTime {
  DayTime? dayTime;

  DepartureTime({this.dayTime});

  DepartureTime.fromJson(Map<String, dynamic> json) {
    dayTime = json['day_time'] != null
        ? new DayTime.fromJson(json['day_time'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dayTime != null) {
      data['day_time'] = this.dayTime!.toJson();
    }
    return data;
  }
}