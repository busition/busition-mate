class DayTime {
  String? dayOfWeek;
  String? time;

  DayTime({this.dayOfWeek, this.time});

  DayTime.fromJson(Map<String, dynamic> json) {
    dayOfWeek = json['day_of_week'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day_of_week'] = this.dayOfWeek;
    data['time'] = this.time;
    return data;
  }
}
