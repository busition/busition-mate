import 'DayTime.dart';

class BoardingSchedule {
  DayTime? dayTime;

  BoardingSchedule({this.dayTime});

  BoardingSchedule.fromJson(Map<String, dynamic> json) {
    dayTime = json['day_time'] != null
        ? DayTime.fromJson(json['day_time'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dayTime != null) {
      data['day_time'] = dayTime!.toJson();
    }
    return data;
  }
}