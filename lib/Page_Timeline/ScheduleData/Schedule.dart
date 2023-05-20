import 'ScheduleData.dart';

class Schedule {
  int? scheduleCount;
  List<ScheduleData>? scheduleData;
  static late List<ScheduleData> staticScheduleList;

  Schedule({this.scheduleCount, this.scheduleData});

  Schedule.fromJson(Map<String, dynamic> json) {
    scheduleCount = json['schedule_count'];
    if (json['schedule_data'] != null) {
      scheduleData = <ScheduleData>[];
      json['schedule_data'].forEach((v) {
        scheduleData!.add(ScheduleData.fromJson(v));
      });
      staticScheduleList = scheduleData!;
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['schedule_count'] = scheduleCount;
    if (scheduleData != null) {
      data['schedule_data'] = scheduleData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
