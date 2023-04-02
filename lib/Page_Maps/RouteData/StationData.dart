import 'BoardingSchedule.dart';

class StationData {
  int? stationId;
  String? stationName;
  int? stoppingOrder;
  double? stationLatitude;
  double? stationLongitude;
  int? passengerCount;
  BoardingSchedule? boardingSchedule;
  String? travelDistance;

  StationData(
      {this.stationId,
        this.stationName,
        this.stoppingOrder,
        this.stationLatitude,
        this.stationLongitude,
        this.passengerCount,
        this.boardingSchedule,
        this.travelDistance});

  StationData.fromJson(Map<String, dynamic> json) {
    stationId = json['station_id'];
    stationName = json['station_name'];
    stoppingOrder = json['stopping_order'];
    stationLatitude = json['station_latitude'];
    stationLongitude = json['station_longitude'];
    passengerCount = json['passenger_count'];
    boardingSchedule = json['boarding_schedule'] != null
        ? BoardingSchedule.fromJson(json['boarding_schedule'])
        : null;
    travelDistance = json['travel_distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['station_id'] = stationId;
    data['station_name'] = stationName;
    data['stopping_order'] = stoppingOrder;
    data['station_latitude'] = stationLatitude;
    data['station_longitude'] = stationLongitude;
    data['passenger_count'] = passengerCount;
    if (boardingSchedule != null) {
      data['boarding_schedule'] = boardingSchedule!.toJson();
    }
    data['travel_distance'] = travelDistance;
    return data;
  }
}