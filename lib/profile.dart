class Profile {
  int? status;
  String? lastSigninDate;
  String? serviceName;
  String? userName;
  String? userEmail;
  String? userPhoneNumber;

  Profile(
      {this.status,
        this.lastSigninDate,
        this.serviceName,
        this.userName,
        this.userEmail,
        this.userPhoneNumber});

  Profile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    lastSigninDate = json['last_signin_date'];
    serviceName = json['service_name'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPhoneNumber = json['user_phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['last_signin_date'] = this.lastSigninDate;
    data['service_name'] = this.serviceName;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['user_phone_number'] = this.userPhoneNumber;
    return data;
  }
}
