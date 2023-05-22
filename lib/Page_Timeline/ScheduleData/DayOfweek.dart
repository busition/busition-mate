import 'package:Busition_Mate/Page_Timeline/ScheduleData/miniTime.dart';

class DayOfWeek{
  String? week;

  DayOfWeek(this.week);

  DayOfWeek.fromJson(Map<String, dynamic> json){
    week = json["s"];
  }
}