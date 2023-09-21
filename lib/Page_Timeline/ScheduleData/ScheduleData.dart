import 'DepartureTime.dart';

class ScheduleData {
  String? name;
  int? routeId;
  String? departurePoint;
  String? destination;
  DepartureTime? departureTime;
  int? shuttleDirection;

  ScheduleData(
      {this.routeId,
      this.name,
      this.departurePoint,
      this.destination,
      // this.departureTime,
      this.shuttleDirection});

  ScheduleData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    routeId = json['id'];
    departurePoint = json['departure_point'];
    destination = json['destination'];
    departureTime =
        json['first_departure_time'] && json['last_arrival_time'] != null
            ? DepartureTime.fromJson(json)
            : null;
    shuttleDirection = json['shuttle_direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['route_id'] = routeId;
    data['departure_point'] = departurePoint;
    data['destination'] = destination;
    data['shuttle_direction'] = shuttleDirection;
    return data;
  }
}
