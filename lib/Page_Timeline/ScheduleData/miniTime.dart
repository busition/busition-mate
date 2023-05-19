class MiniTime{
  String? time;

  MiniTime(this.time);

  MiniTime.fromJson(Map<String, dynamic> json){
    time = json['s'];
  }
}