class TimeData {
  String name;
  DateTime time;
  String wayTo;

  TimeData({required this.name, required this.time, required this.wayTo});

  factory TimeData.fromJson(Map<String, dynamic> parsedJson) {
    /* API 연결 후 변경 예정 */
    return TimeData(
        name: parsedJson["name"].toString(),
        time: parsedJson["time"],
        wayTo: parsedJson["wayto"].toString()
    );
  }
}
