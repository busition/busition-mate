import 'DayTime.dart';

class DepartureTime {
  List? firstDepartureTime;
  List? lastArrivalTime;

  // DayTime? dayTime;
  //
  DepartureTime({this.firstDepartureTime, this.lastArrivalTime});

  //
  DepartureTime.fromJson(Map<String, dynamic> data) {
    firstDepartureTime = data["first_departure_time"];
    lastArrivalTime = data["last_arrival_time"];
    print("Dep: " + firstDepartureTime.toString());
    print("Dep: " + lastArrivalTime.toString());

  }
}
