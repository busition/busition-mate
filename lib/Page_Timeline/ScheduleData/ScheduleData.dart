import 'DepartureTime.dart';

class ScheduleData {
  int? routeId;
  String? departurePoint;
  String? destination;
  DepartureTime? departureTime;
  int? shuttleDirection;

  ScheduleData(
      {this.routeId,
        this.departurePoint,
        this.destination,
        this.departureTime,
        this.shuttleDirection});

  ScheduleData.fromJson(Map<String, dynamic> json) {
    routeId = json['route_id'];
    departurePoint = json['departure_point'];
    destination = json['destination'];
    departureTime = json['departure_time'] != null
        ? new DepartureTime.fromJson(json['departure_time'])
        : null;
    shuttleDirection = json['shuttle_direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['route_id'] = this.routeId;
    data['departure_point'] = this.departurePoint;
    data['destination'] = this.destination;
    if (this.departureTime != null) {
      data['departure_time'] = this.departureTime!.toJson();
    }
    data['shuttle_direction'] = this.shuttleDirection;
    return data;
  }
}
