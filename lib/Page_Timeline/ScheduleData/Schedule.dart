import 'ScheduleData.dart';

class Schedule {
  int? scheduleCount;
  List<ScheduleData>? scheduleData;

  Schedule({this.scheduleCount, this.scheduleData});

  Schedule.fromJson(Map<String, dynamic> json) {
    scheduleCount = json['schedule_count'];
    if (json['schedule_data'] != null) {
      scheduleData = <ScheduleData>[];
      json['schedule_data'].forEach((v) {
        scheduleData!.add(new ScheduleData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schedule_count'] = this.scheduleCount;
    if (this.scheduleData != null) {
      data['schedule_data'] =
          this.scheduleData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}