class Profile {
  String? userName;
  String? userEmail;
  String? activation;

  Profile(
      {
        this.userName,
        this.userEmail,
        this.activation});

  Profile.fromJson(Map<String, dynamic> json) {
    userName = json['username'];
    userEmail = json['email'];
    activation = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['user_phone_number'] = this.activation;
    return data;
  }
}
