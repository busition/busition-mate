import 'Page_Timeline/ScheduleData/ScheduleData.dart';

class Profile {
  static late List<ScheduleData> list;
  String? userName;
  String? email;
  bool? is_active;
  int? organization;

  Profile(
      {
        this.organization,
        this.userName,
        this.email,
        this.is_active});

  Profile.fromJson(Map<String, dynamic> json) {
    userName = json['username'];
    email = json['email'];
    is_active = json['is_active'];
    organization = json['organization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['user_email'] = this.email;
    data['user_phone_number'] = this.is_active;
    return data;
  }
}
