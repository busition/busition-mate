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
        ? DepartureTime.fromJson(json['departure_time'])
        : null;
    shuttleDirection = json['shuttle_direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['route_id'] = routeId;
    data['departure_point'] = departurePoint;
    data['destination'] = destination;
    if (departureTime != null) {
      data['departure_time'] = departureTime!.toJson();
    }
    data['shuttle_direction'] = shuttleDirection;
    return data;
  }
}
