import './miniTime.dart';
import './DayOfweek.dart';

class DayTime {
  DayOfWeek? dayOfWeek;
  MiniTime? time;

  DayTime({this.dayOfWeek, this.time});

  DayTime.fromJson(Map<String, dynamic> json) {
    if (json['time'] != null){
      time = MiniTime.fromJson(json['time']);
    }
    if (json['day_of_week'] != null ){
      dayOfWeek = DayOfWeek.fromJson(json['day_of_week']);
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day_of_week'] = dayOfWeek;
    data['time'] = time;
    return data;
  }
}
