import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String? dOB;
  String? date;
  int? income;
  String? docId;
  String? email;
  String? fcm;
  bool? isActive;
  String? name;
  String? password;
  String? userId;

  Profile(
      {this.dOB,
        this.date,
        this.income,
        this.docId,
        this.email,
        this.fcm,
        this.isActive,
        this.name,
        this.password,
        this.userId});

  Profile.fromJson(DocumentSnapshot<Map<String, dynamic>> json) {
    dOB = json['DOB'];
    date = json['Date'];
    income = json['Income'];
    docId = json['docId'];
    email = json['email'];
    fcm = json['fcm'];
    isActive = json['isActive'];
    name = json['name'];
    password = json['password'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DOB'] = this.dOB;
    data['Date'] = this.date;
    data['Income'] = this.income;
    data['docId'] = this.docId;
    data['email'] = this.email;
    data['fcm'] = this.fcm;
    data['isActive'] = this.isActive;
    data['name'] = this.name;
    data['password'] = this.password;
    data['userId'] = this.userId;
    return data;
  }
}