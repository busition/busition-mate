import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Schedule.g.dart'; // 자동 생성될 파일 이름

@JsonSerializable()
class ScheduleResponse extends ChangeNotifier {
  int schedule_count;
  List<Schedule> schedule_data;

  ScheduleResponse({required this.schedule_count, required this.schedule_data});

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleResponseToJson(this);

  changeStatus(bool status, int id) {
    for (int i = 0; i < schedule_data.length; i++) {
      if (schedule_data[i].id == id) {
        schedule_data[i].isActive = status;
        notifyListeners();
        break;
      }
    }
  }
}

@JsonSerializable()
class Schedule {
  bool _isActive = false;

  bool get isActive => _isActive;

  set isActive(bool value) {
    _isActive = value;
    print("isActive: $_isActive");
  }

  // Nullable field
  @JsonKey(defaultValue: 999)
  int id;
  @JsonKey(defaultValue: '')
  String name;
  @JsonKey(defaultValue: '')
  String? description;
  @JsonKey(defaultValue: '')
  String departure_point;

  @JsonKey(defaultValue: 0)
  int shuttle_direction;

  @JsonKey(defaultValue: '')
  String destination;

  @JsonKey(defaultValue: [])
  List<String> first_departure_time;
  @JsonKey(defaultValue: [])
  List<String> last_arrival_time;
  @JsonKey(defaultValue: [])
  List<int> day_of_week;
  DateTime? nearest_departure;

  Schedule({
    required this.id,
    required this.name,
    this.description,
    required this.departure_point,
    required this.destination,
    required this.shuttle_direction,
    required this.first_departure_time,
    required this.last_arrival_time,
    required this.day_of_week,
  }) {}

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);

  void findNearestDepartureTime() {
    if (first_departure_time.isEmpty) {
      nearest_departure = null;
      return;
    }

    DateTime now = DateTime.now();
    // 현재 시간 이후로 가장 가까운 시간을 찾음
    DateTime nearestTime =
        DateTime(now.year, now.month, now.day, 23, 59); // 마지막 시간으로 초기화
    for (var time in first_departure_time) {
      var parts = time.split(':');
      DateTime departureTime = DateTime(now.year, now.month, now.day,
          int.parse(parts[0]), int.parse(parts[1]));

      // 시간이 현재 시간 이후이고 가장 가까운 시간보다 가까우면 업데이트
      if (departureTime.isAfter(now) && departureTime.isBefore(nearestTime)) {
        nearestTime = departureTime;
      }
    }
    nearest_departure = nearestTime;
  }
}
