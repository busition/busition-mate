import 'dart:convert';

import 'package:Busition_Mate/LoginClass.dart';
import 'package:http/http.dart' as http;

import 'Page_Timeline/ScheduleData/ScheduleData.dart';

class UserProfile {
  static late List<ScheduleData> list;
  Token? token;
  String bearerUrl = "https://api.dev2.busition.com:8001/v1_4/users_test/bearer";

  UserProfile();

  UserProfile.fromJson(Map<String, dynamic> json) {
    token = json['token'] != null ? Token.fromJson(json['token']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (token != null) {
      data['token'] = token!.toJson();
    }
    return data;
  }

  Future<UserProfile> fetchProfile(http.Client client) async {
    var url = Uri.parse(bearerUrl);
    final response = await client.get(url,
        headers: {'Authorization': "Bearer ${LoginClass.idTokenResult.token}"});
    var data = utf8.decode(response.bodyBytes);
    final list = jsonDecode(data);
    final profileData = UserProfile.fromJson(list);
    return profileData;
  }
}

class Token {
  String? name;
  String? iss;
  String? aud;
  int? authTime;
  String? userId;
  String? sub;
  int? iat;
  int? exp;
  String? email;
  bool? emailVerified;
  String? phoneNumber;
  Firebase? firebase;
  String? uid;

  Token(
      {this.name,
      this.iss,
      this.aud,
      this.authTime,
      this.userId,
      this.sub,
      this.iat,
      this.exp,
      this.email,
      this.emailVerified,
      this.phoneNumber,
      this.firebase,
      this.uid});

  Token.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    iss = json['iss'];
    aud = json['aud'];
    authTime = json['auth_time'];
    userId = json['user_id'];
    sub = json['sub'];
    iat = json['iat'];
    exp = json['exp'];
    email = json['email'];
    emailVerified = json['email_verified'];
    phoneNumber = json['phone_number'];
    firebase = json['firebase'] != null
        ? new Firebase.fromJson(json['firebase'])
        : null;
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['iss'] = this.iss;
    data['aud'] = this.aud;
    data['auth_time'] = this.authTime;
    data['user_id'] = this.userId;
    data['sub'] = this.sub;
    data['iat'] = this.iat;
    data['exp'] = this.exp;
    data['email'] = this.email;
    data['email_verified'] = this.emailVerified;
    data['phone_number'] = this.phoneNumber;
    if (this.firebase != null) {
      data['firebase'] = this.firebase!.toJson();
    }
    data['uid'] = this.uid;
    return data;
  }
}

class Firebase {
  Identities? identities;
  String? signInProvider;

  Firebase({this.identities, this.signInProvider});

  Firebase.fromJson(Map<String, dynamic> json) {
    identities = json['identities'] != null
        ? new Identities.fromJson(json['identities'])
        : null;
    signInProvider = json['sign_in_provider'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.identities != null) {
      data['identities'] = this.identities!.toJson();
    }
    data['sign_in_provider'] = this.signInProvider;
    return data;
  }
}

class Identities {
  List<String>? phone;
  List<String>? email;

  Identities({this.phone, this.email});

  Identities.fromJson(Map<String, dynamic> json) {
    phone = json['phone'].cast<String>();
    email = json['email'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['email'] = this.email;
    return data;
  }
}
